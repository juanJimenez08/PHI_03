library ieee;
use ieee.std_logic_1164.all;

entity scroller_avalon is
    port (
        clk             : in  std_logic;
        reset           : in  std_logic;
        avs_write       : in  std_logic;
        avs_writedata   : in  std_logic_vector(31 downto 0);
        avs_address     : in  std_logic_vector(4 downto 0);
        con_buttons     : in  std_logic_vector(2 downto 0);
        con_hex_out     : out std_logic_vector(41 downto 0)
    );
end scroller_avalon;

architecture struct of scroller_avalon is
    signal wire_index : integer range 0 to 31;

    component bloco_controle is
        port (
            clk : in std_logic; reset : in std_logic;
            buttons : in std_logic_vector(2 downto 0);
            current_index : out integer range 0 to 31
        );
    end component;

    component bloco_operacional is
        port (
            clk : in std_logic; reset : in std_logic;
            wr_en : in std_logic; wr_addr : in std_logic_vector(4 downto 0);
            wr_data : in std_logic_vector(7 downto 0);
            start_index : in integer range 0 to 31;
            hex_output : out std_logic_vector(41 downto 0)
        );
    end component;
begin
    -- Instancia o Controle
    U_CTRL : component bloco_controle
        port map (
            clk => clk, reset => reset,
            buttons => con_buttons,
            current_index => wire_index -- O controle diz: "Mostre a partir da letra X"
        );

    -- Instancia o Operacional
    U_OPER : component bloco_operacional
        port map (
            clk => clk, reset => reset,
            wr_en => avs_write,                -- Avalon escreve aqui
            wr_addr => avs_address,            -- Endereço Avalon
            wr_data => avs_writedata(7 downto 0), -- Dado Avalon
            start_index => wire_index,         -- O Operacional recebe o índice do controle
            hex_output => con_hex_out          -- Joga para fora do chip
        );
end struct;