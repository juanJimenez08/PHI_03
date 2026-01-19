library ieee;
use ieee.std_logic_1164.all;

entity hardware is
    port (
        -- Entradas Físicas da Placa
        CLOCK_50 : in std_logic;                    -- Clock de 50MHz
        KEY      : in std_logic_vector(3 downto 0); -- Botões (KEY[0] será o Reset)

        -- Saídas Físicas da Placa
        LEDR     : out std_logic_vector(9 downto 0); -- 10 LEDs Vermelhos
        HEX0     : out std_logic_vector(6 downto 0); -- Display 0
        HEX1     : out std_logic_vector(6 downto 0); -- Display 1
        HEX2     : out std_logic_vector(6 downto 0); -- Display 2
        HEX3     : out std_logic_vector(6 downto 0); -- Display 3
        HEX4     : out std_logic_vector(6 downto 0); -- Display 4
        HEX5     : out std_logic_vector(6 downto 0)  -- Display 5
    );
end entity hardware;

architecture rtl of hardware is

    -- =============================================================
    -- DECLARAÇÃO DO COMPONENTE (Copiado do seu Platform Designer)
    -- =============================================================
    component myhardware is
        port (
            clk_clk       : in  std_logic                     := 'X'; -- clk
            hex0_export   : out std_logic_vector(6 downto 0);         -- export
            hex1_export   : out std_logic_vector(6 downto 0);         -- export
            hex2_export   : out std_logic_vector(6 downto 0);         -- export
            hex3_export   : out std_logic_vector(6 downto 0);         -- export
            hex4_export   : out std_logic_vector(6 downto 0);         -- export
            hex5_export   : out std_logic_vector(6 downto 0);         -- export
            leds_export   : out std_logic_vector(9 downto 0);         -- export
            reset_reset_n : in  std_logic                     := 'X'  -- reset_n
        );
    end component myhardware;

begin

    -- =============================================================
    -- INSTANCIAÇÃO (Conectando o chip aos pinos da placa)
    -- =============================================================
    u0 : component myhardware
        port map (
            -- Lado do Processador (Esq)  =>  Lado da Placa (Dir)
            clk_clk       => CLOCK_50,    -- Conecta ao oscilador de 50MHz
            reset_reset_n => KEY(0),      -- Conecta ao botão 0 (Reset)
            
            leds_export   => LEDR,        -- Conecta aos LEDs vermelhos
            
            hex0_export   => HEX0,        -- Conecta ao Display 0
            hex1_export   => HEX1,        -- Conecta ao Display 1
            hex2_export   => HEX2,        -- Conecta ao Display 2
            hex3_export   => HEX3,        -- Conecta ao Display 3
            hex4_export   => HEX4,        -- Conecta ao Display 4
            hex5_export   => HEX5         -- Conecta ao Display 5
        );

end architecture rtl;