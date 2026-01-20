library ieee;
use ieee.std_logic_1164.all;

entity hardware is
    port (
       
        CLOCK_50 : in std_logic;                    
        KEY      : in std_logic_vector(3 downto 0); 
        LEDR     : out std_logic_vector(9 downto 0); 
        
		  --hex display
		  HEX0     : out std_logic_vector(6 downto 0); 
        HEX1     : out std_logic_vector(6 downto 0); 
        HEX2     : out std_logic_vector(6 downto 0); 
        HEX3     : out std_logic_vector(6 downto 0); 
        HEX4     : out std_logic_vector(6 downto 0); 
        HEX5     : out std_logic_vector(6 downto 0);
		  --uart
		  UART_RX : in  std_logic;
        UART_TX : out std_logic;
        
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
            clk_clk       : in  std_logic                    := 'X'; -- clk
            hex0_export   : out std_logic_vector(6 downto 0);        -- export
            hex1_export   : out std_logic_vector(6 downto 0);        -- export
            hex2_export   : out std_logic_vector(6 downto 0);        -- export
            hex3_export   : out std_logic_vector(6 downto 0);        -- export
            hex4_export   : out std_logic_vector(6 downto 0);        -- export
            hex5_export   : out std_logic_vector(6 downto 0);        -- export
            leds_export   : out std_logic_vector(9 downto 0);        -- export
            reset_reset_n : in  std_logic                    := 'X'; -- reset_n
            spi_0_MISO    : in  std_logic                    := 'X'; -- MISO
            spi_0_MOSI    : out std_logic;                           -- MOSI
            spi_0_SCLK    : out std_logic;                           -- SCLK
            spi_0_SS_n    : out std_logic;                           -- SS_n
            uart_0_rxd    : in  std_logic                    := 'X'; -- rxd
            uart_0_txd    : out std_logic                            -- txd
        );
    end component myhardware;

begin

   
    u0 : component myhardware
        port map (
           
            clk_clk       => CLOCK_50,    
            reset_reset_n => KEY(0),     
            leds_export   => LEDR,        
            hex0_export   => HEX0,        
            hex1_export   => HEX1,      
            hex2_export   => HEX2,       
            hex3_export   => HEX3,       
            hex4_export   => HEX4,        
            hex5_export   => HEX5,
				spi_0_MISO    => SPI_MISO,    --  spi_0.MISO
            spi_0_MOSI    => SPI_MOSI ,    --       .MOSI
            spi_0_SCLK    => SPI_CLK,    --       .SCLK
            spi_0_SS_n    => SPI_CS,    --       .SS_n
            uart_0_rxd    => UART_RX,    -- uart_0.rxd
            uart_0_txd    => UART_TX     --       .txd
        );

end architecture rtl;