	component myhardware is
		port (
			clk_clk             : in  std_logic                     := 'X';             -- clk
			hex0_export         : out std_logic_vector(6 downto 0);                     -- export
			hex1_export         : out std_logic_vector(6 downto 0);                     -- export
			hex2_export         : out std_logic_vector(6 downto 0);                     -- export
			hex3_export         : out std_logic_vector(6 downto 0);                     -- export
			hex4_export         : out std_logic_vector(6 downto 0);                     -- export
			hex5_export         : out std_logic_vector(6 downto 0);                     -- export
			leds_export         : out std_logic_vector(9 downto 0);                     -- export
			reset_reset_n       : in  std_logic                     := 'X';             -- reset_n
			spi_0_MISO          : in  std_logic                     := 'X';             -- MISO
			spi_0_MOSI          : out std_logic;                                        -- MOSI
			spi_0_SCLK          : out std_logic;                                        -- SCLK
			spi_0_SS_n          : out std_logic;                                        -- SS_n
			uart_0_rxd          : in  std_logic                     := 'X';             -- rxd
			uart_0_txd          : out std_logic;                                        -- txd
			meu_display_buttons : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- buttons
			meu_display_hex_out : out std_logic_vector(41 downto 0)                     -- hex_out
		);
	end component myhardware;

	u0 : component myhardware
		port map (
			clk_clk             => CONNECTED_TO_clk_clk,             --         clk.clk
			hex0_export         => CONNECTED_TO_hex0_export,         --        hex0.export
			hex1_export         => CONNECTED_TO_hex1_export,         --        hex1.export
			hex2_export         => CONNECTED_TO_hex2_export,         --        hex2.export
			hex3_export         => CONNECTED_TO_hex3_export,         --        hex3.export
			hex4_export         => CONNECTED_TO_hex4_export,         --        hex4.export
			hex5_export         => CONNECTED_TO_hex5_export,         --        hex5.export
			leds_export         => CONNECTED_TO_leds_export,         --        leds.export
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --       reset.reset_n
			spi_0_MISO          => CONNECTED_TO_spi_0_MISO,          --       spi_0.MISO
			spi_0_MOSI          => CONNECTED_TO_spi_0_MOSI,          --            .MOSI
			spi_0_SCLK          => CONNECTED_TO_spi_0_SCLK,          --            .SCLK
			spi_0_SS_n          => CONNECTED_TO_spi_0_SS_n,          --            .SS_n
			uart_0_rxd          => CONNECTED_TO_uart_0_rxd,          --      uart_0.rxd
			uart_0_txd          => CONNECTED_TO_uart_0_txd,          --            .txd
			meu_display_buttons => CONNECTED_TO_meu_display_buttons, -- meu_display.buttons
			meu_display_hex_out => CONNECTED_TO_meu_display_hex_out  --            .hex_out
		);

