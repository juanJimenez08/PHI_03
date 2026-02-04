library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_controle is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        
        -- HARDWARE INTERFACE (Botões e Switch Físicos)
        switch_enable : in  std_logic;                    -- Switch 0: Master Enable
        buttons       : in  std_logic_vector(2 downto 0); -- Btn 0, 1, 2
        
        -- SOFTWARE INTERFACE (Vem do C via Avalon)
        wr_speed_en   : in  std_logic;                    -- C quer mudar a velocidade?
        new_speed_val : in  integer;                      -- Novo valor de velocidade do C
        wr_ctrl_en    : in  std_logic;                    -- C quer mudar o controle (Pause)?
        new_paused    : in  std_logic;                    -- Novo estado de pause do C
        
        -- SAÍDAS PARA O OPERACIONAL
        current_index : out integer range 0 to 31;
        system_on     : out std_logic                     -- Avisa o operacional se deve ligar os displays
    );
end entity bloco_controle;

architecture rtl of bloco_controle is
    -- Valores padrão iniciais (podem ser sobrescritos pelo C)
    signal speed_counter : integer range 0 to 50000000 := 0;
    signal speed_limit   : integer := 10000000; 
    signal scroll_idx    : integer range 0 to 31 := 0;
    signal is_paused     : std_logic := '0';
    
    -- Detectores de borda
    signal btn_prev      : std_logic_vector(2 downto 0) := "111";
begin

    -- Saída de status para o bloco operacional apagar os displays se Switch=0
    system_on <= switch_enable;

    process(clk)
    begin
        if rising_edge(clk) then
            -- 1. MASTER RESET (Switch 0 desligado ou Reset do sistema)
            -- Se o switch estiver OFF, reseta tudo e fica parado.
            if reset = '1' or switch_enable = '0' then
                speed_counter <= 0;
                scroll_idx    <= 0;
                
                -- Se foi apenas o Switch que desligou, mantemos as configurações de velocidade
                -- Mas se foi RESET geral, voltamos ao padrão de fábrica
                if reset = '1' then
                    speed_limit <= 10000000;
                    is_paused   <= '0';
                end if;
                
            else
                -- 2. ESCRITA DO SOFTWARE (C) - Setup Inicial ou Ajuste
                -- Se o C mandou uma nova velocidade, atualizamos agora
                if wr_speed_en = '1' then
                    speed_limit <= new_speed_val;
                end if;
                
                -- Se o C mandou pausar/despausar logicamente
                if wr_ctrl_en = '1' then
                    is_paused <= new_paused;
                end if;

                -- 3. INTERAÇÃO DOS BOTÕES (Hardware Override)
                -- Botão 0: Pause (Inverte o estado atual, seja ele vindo do C ou não)
                if buttons(0) = '0' and btn_prev(0) = '1' then 
                    is_paused <= not is_paused; 
                end if;
                
                -- Botão 1: Acelera (Diminui o limite)
                if buttons(1) = '0' and btn_prev(1) = '1' then
                    if speed_limit > 1000000 then -- Limite mínimo de segurança
                        speed_limit <= speed_limit - 1000000; 
                    end if;
                end if;
                
                -- Botão 2: Desacelera (Aumenta o limite)
                if buttons(2) = '0' and btn_prev(2) = '1' then
                    if speed_limit < 45000000 then 
                        speed_limit <= speed_limit + 1000000; 
                    end if;
                end if;
                
                -- Atualiza estado anterior dos botões
                btn_prev <= buttons;

                -- 4. CORE LÓGICO (O Scroll)
                if is_paused = '0' then
                    if speed_counter < speed_limit then
                        speed_counter <= speed_counter + 1;
                    else
                        speed_counter <= 0;
                        if scroll_idx < 31 then 
                            scroll_idx <= scroll_idx + 1;
                        else 
                            scroll_idx <= 0; 
                        end if;
                    end if;
                end if;
                
            end if; -- Fim do check do Switch/Reset
        end if; -- Fim do Clock
    end process;
    
    current_index <= scroll_idx;
    
end rtl;
