library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_controle is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        
        -- HARDWARE INTERFACE (Botões e Switch Físicos)
        switch_enable : in  std_logic;                    -- Switch 0: Liga/Desliga a tela (Standby)
        buttons       : in  std_logic_vector(2 downto 0); -- Btn 0 (Pause), 1 (Faster), 2 (Slower)
        
        -- SOFTWARE INTERFACE (Vem do C via Avalon)
        wr_speed_en   : in  std_logic;                    -- Enable escrita velocidade
        new_speed_val : in  integer;                      -- Valor velocidade
        wr_ctrl_en    : in  std_logic;                    -- Enable escrita controle
        new_paused    : in  std_logic;                    -- Valor pause
        
        -- SAÍDAS PARA O OPERACIONAL
        current_index : out integer range 0 to 31;        -- Qual letra mostrar
        system_on     : out std_logic                     -- Se '0', apaga os displays
    );
end entity bloco_controle;

architecture rtl of bloco_controle is
    -- Configuração Padrão (Factory Default)
    constant DEFAULT_SPEED : integer := 10000000;
    
    -- Sinais internos (Registradores)
    signal speed_counter : integer range 0 to 50000000 := 0;
    signal speed_limit   : integer := DEFAULT_SPEED; 
    signal scroll_idx    : integer range 0 to 31 := 0;
    signal is_paused     : std_logic := '0';
    
    -- Detectores de borda para os botões
    signal btn_prev      : std_logic_vector(2 downto 0) := "111";
begin

    -- Avisa o bloco operacional para desligar os LEDs se o switch estiver OFF
    system_on <= switch_enable;

    process(clk)
    begin
        if rising_edge(clk) then
            
            -- ============================================================
            -- 1. MASTER RESET (Prioridade Máxima) - "Reset de Fábrica"
            -- ============================================================
            if reset = '1' then
                speed_counter <= 0;
                scroll_idx    <= 0;            -- Volta frase pro início
                speed_limit   <= DEFAULT_SPEED; -- Reseta velocidade
                is_paused     <= '0';          -- Tira do pause
            
            -- ============================================================
            -- 2. SWITCH DESLIGADO (Standby)
            -- ============================================================
            elsif switch_enable = '0' then
                -- Apenas zera o contador de tempo para não "pular" letras enquanto desligado.
                speed_counter <= 0;
                
                -- IMPORTANTE: Não zeramos 'scroll_idx', 'speed_limit' nem 'is_paused'.
                -- Assim ele "lembra" de tudo quando ligar de novo.

            -- ============================================================
            -- 3. FUNCIONAMENTO NORMAL (Switch Ligado)
            -- ============================================================
            else
                
                -- A. Comandos do Software (C) - Setup Inicial
                if wr_speed_en = '1' then
                    speed_limit <= new_speed_val;
                end if;
                
                if wr_ctrl_en = '1' then
                    is_paused <= new_paused;
                end if;

                -- B. Comandos dos Botões (Hardware Override)
                
                -- Botão 0: Pause/Play (Toggle)
                if buttons(0) = '0' and btn_prev(0) = '1' then 
                    is_paused <= not is_paused; 
                end if;
                
                -- Botão 1: Acelerar (Menor limite = Mais rápido)
                if buttons(1) = '0' and btn_prev(1) = '1' then
                    if speed_limit > 1000000 then -- Trava mínima (segurança)
                        speed_limit <= speed_limit - 1000000; 
                    end if;
                end if;
                
                -- Botão 2: Desacelerar (Maior limite = Mais lento)
                if buttons(2) = '0' and btn_prev(2) = '1' then
                    if speed_limit < 45000000 then -- Trava máxima
                        speed_limit <= speed_limit + 1000000; 
                    end if;
                end if;
                
                -- Atualiza estado anterior dos botões (para detectar borda)
                btn_prev <= buttons;

                -- C. Lógica do Scroll (Só anda se não estiver pausado)
                if is_paused = '0' then
                    if speed_counter < speed_limit then
                        speed_counter <= speed_counter + 1;
                    else
                        speed_counter <= 0;
                        -- Avança a letra (Circular 0..31)
                        if scroll_idx < 31 then 
                            scroll_idx <= scroll_idx + 1;
                        else 
                            scroll_idx <= 0; 
                        end if;
                    end if;
                end if;
                
            end if; -- Fim do if Reset/Switch/Normal
        end if; -- Fim do Clock
    end process;
    
    -- Saída da posição atual para a memória
    current_index <= scroll_idx;
    
end rtl;