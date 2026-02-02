library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity scroller_avalon is
    port (
        -- Interface Avalon-MM (Conecta no Nios II)
        clk             : in  std_logic;
        reset           : in  std_logic;
        avs_write       : in  std_logic;
        avs_writedata   : in  std_logic_vector(31 downto 0);
        -- MUDANÇA: Endereço agora tem 6 bits (0..63) para caber os registradores extras
        avs_address     : in  std_logic_vector(5 downto 0); 

        -- Interface Externa (Conduit - Vai para os pinos do FPGA)
        -- MUDANÇA: Adicionado o Switch Enable
        con_switch      : in  std_logic;                    -- Switch 0 (Enable Geral)
        con_buttons     : in  std_logic_vector(2 downto 0); -- Botões (Speed/Pause)
        con_hex_out     : out std_logic_vector(41 downto 0) -- 6 displays
    );
end scroller_avalon;

architecture struct of scroller_avalon is

    -- Sinais internos de conexão
    signal wire_index     : integer range 0 to 31;
    signal wire_system_on : std_logic;

    -- Sinais para decodificar onde o C quer escrever
    signal write_enable_ram   : std_logic;
    signal write_enable_ctrl  : std_logic;
    signal write_enable_speed : std_logic;

    -- Componente de Controle (Atualizado)
    component bloco_controle is
        port (
            clk : in std_logic; reset : in std_logic;
            switch_enable : in std_logic;
            buttons : in std_logic_vector(2 downto 0);
            wr_speed_en : in std_logic; new_speed_val : in integer;
            wr_ctrl_en : in std_logic; new_paused : in std_logic;
            current_index : out integer range 0 to 31;
            system_on : out std_logic
        );
    end component;

    -- Componente Operacional (Atualizado)
    component bloco_operacional is
        port (
            clk : in std_logic; reset : in std_logic;
            wr_en : in std_logic; wr_addr : in std_logic_vector(5 downto 0);
            wr_data : in std_logic_vector(31 downto 0);
            start_index : in integer range 0 to 31;
            system_on : in std_logic;
            hex_output : out std_logic_vector(41 downto 0)
        );
    end component;

begin

    -- LÓGICA DE DECODIFICAÇÃO DE ENDEREÇO (O Mapa da Memória)
    -- Endereços 0 a 31 (0x00 a 0x1F): Memória de Texto
    write_enable_ram   <= avs_write when (unsigned(avs_address) < 32) else '0';
    
    -- Endereço 32 (0x20): Registrador de Controle (Bit 0 define Pause)
    write_enable_ctrl  <= avs_write when (unsigned(avs_address) = 32) else '0';
    
    -- Endereço 33 (0x21): Registrador de Velocidade (Valor inteiro)
    write_enable_speed <= avs_write when (unsigned(avs_address) = 33) else '0';


    -- Instancia o Controle
    U_CTRL : component bloco_controle
        port map (
            clk           => clk, 
            reset         => reset,
            
            -- Hardware Físico
            switch_enable => con_switch,      -- Conecta ao Switch 0
            buttons       => con_buttons,     -- Conecta aos Botões
            
            -- Configuração via Software (C)
            wr_speed_en   => write_enable_speed,
            new_speed_val => to_integer(unsigned(avs_writedata)), -- Converte 32 bits para int
            wr_ctrl_en    => write_enable_ctrl,
            new_paused    => avs_writedata(0), -- Usa o bit 0 do dado para definir pause
            
            -- Saídas
            current_index => wire_index,
            system_on     => wire_system_on   -- Avisa se o sistema está ligado
        );

    -- Instancia o Operacional
    U_OPER : component bloco_operacional
        port map (
            clk         => clk, 
            reset       => reset,
            
            -- Escrita na RAM (Só acontece se endereço < 32)
            wr_en       => write_enable_ram,
            wr_addr     => avs_address,
            wr_data     => avs_writedata,
            
            -- Leitura e Display
            start_index => wire_index,
            system_on   => wire_system_on, -- Recebe o aviso para apagar ou acender
            hex_output  => con_hex_out
        );

end struct;
