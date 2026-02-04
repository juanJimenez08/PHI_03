library ieee;
use ieee.std_logic_1164.all;

entity hardware is
    port (
        CLOCK_50 : in std_logic;
        KEY      : in std_logic_vector(3 downto 0);
        LEDR     : out std_logic_vector(9 downto 0);
        SW       : in std_logic_vector(9 downto 0); 
        
        -- Hex Displays
        HEX0     : out std_logic_vector(6 downto 0);
        HEX1     : out std_logic_vector(6 downto 0);
        HEX2     : out std_logic_vector(6 downto 0);
        HEX3     : out std_logic_vector(6 downto 0);
        HEX4     : out std_logic_vector(6 downto 0);
        HEX5     : out std_logic_vector(6 downto 0);

        -- UART
        UART_RX  : in  std_logic;
        UART_TX  : out std_logic;
        
        -- SPI
        SPI_MISO : in  std_logic;
        SPI_MOSI : out std_logic;
        SPI_CLK  : out std_logic;
        SPI_CS   : out std_logic
    );
end entity hardware;

architecture rtl of hardware is

    
    component myhardware is
        port (
            clk_clk                 : in  std_logic := 'X'; 
            reset_reset_n           : in  std_logic := 'X'; 
            
            -- Sinais da UART e SPI
            spi_0_MISO              : in  std_logic := 'X'; 
            spi_0_MOSI              : out std_logic;        
            spi_0_SCLK              : out std_logic;        
            spi_0_SS_n              : out std_logic;        
            uart_0_rxd              : in  std_logic := 'X'; 
            uart_0_txd              : out std_logic;        
            leds_export             : out std_logic_vector(9 downto 0);

           
            meu_display_con_hex_out : out std_logic_vector(41 downto 0);
            meu_display_con_buttons : in  std_logic_vector(2 downto 0);
            meu_display_chave       : in  std_logic := 'X'  -- A nova porta do Switch
        );
    end component myhardware;

    -- Sinal intermediário para "fatiar" o vetor gigante dos displays
    signal hex_full_vector : std_logic_vector(41 downto 0);

begin

    u0 : component myhardware
        port map (
            clk_clk                 => CLOCK_50,    
            reset_reset_n           => KEY(0),       -- Reset geral do sistema
            leds_export             => LEDR,         
            
            -- UART e SPI
            spi_0_MISO              => SPI_MISO,    
            spi_0_MOSI              => SPI_MOSI,    
            spi_0_SCLK              => SPI_CLK,    
            spi_0_SS_n              => SPI_CS,    
            uart_0_rxd              => UART_RX,    
            uart_0_txd              => UART_TX,     

            meu_display_con_buttons => KEY(3 downto 1),
            
            -- Vetor de saída para os displays
            meu_display_con_hex_out => hex_full_vector,
            
      
            meu_display_chave       => SW(0)
        );

    -- Atribuição dos vetores fatiados para os pinos físicos HEX
    HEX0 <= hex_full_vector(6 downto 0);
    HEX1 <= hex_full_vector(13 downto 7);
    HEX2 <= hex_full_vector(20 downto 14);
    HEX3 <= hex_full_vector(27 downto 21);
    HEX4 <= hex_full_vector(34 downto 28);
    HEX5 <= hex_full_vector(41 downto 35);

end architecture rtl;