library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
-- 1. ENTIDADE DO BLOCO DE CONTROLE (Gera endereços e gerencia tempo)
--------------------------------------------------------------------------------
entity bloco_controle is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        buttons       : in  std_logic_vector(2 downto 0);
        current_index : out integer range 0 to 31 -- Informa ao Operacional onde começar a ler
    );
end entity bloco_controle;

architecture rtl of bloco_controle is
    signal speed_counter : integer range 0 to 50000000 := 0;
    signal speed_limit   : integer := 10000000;
    signal scroll_idx    : integer range 0 to 31 := 0;
    signal paused        : std_logic := '0';
    signal btn_prev      : std_logic_vector(2 downto 0) := "111";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                speed_limit <= 10000000;
                paused <= '0';
                scroll_idx <= 0;
            else
                -- Detecta borda de descida dos botões
                if buttons(0) = '0' and btn_prev(0) = '1' then paused <= not paused; end if;
                if buttons(1) = '0' and btn_prev(1) = '1' and speed_limit > 2000000 then 
                    speed_limit <= speed_limit - 2000000; 
                end if;
                if buttons(2) = '0' and btn_prev(2) = '1' and speed_limit < 40000000 then 
                    speed_limit <= speed_limit + 2000000; 
                end if;
                btn_prev <= buttons;

                -- Lógica do Scroll (Máquina de Estados Simplificada)
                if paused = '0' then
                    if speed_counter < speed_limit then
                        speed_counter <= speed_counter + 1;
                    else
                        speed_counter <= 0;
                        if scroll_idx < 31 then scroll_idx <= scroll_idx + 1;
                        else scroll_idx <= 0; end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    current_index <= scroll_idx;
end rtl;