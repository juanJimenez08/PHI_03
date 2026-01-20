
module myhardware (
	clk_clk,
	hex0_export,
	hex1_export,
	hex2_export,
	hex3_export,
	hex4_export,
	hex5_export,
	leds_export,
	reset_reset_n,
	spi_0_MISO,
	spi_0_MOSI,
	spi_0_SCLK,
	spi_0_SS_n,
	uart_0_rxd,
	uart_0_txd);	

	input		clk_clk;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex3_export;
	output	[6:0]	hex4_export;
	output	[6:0]	hex5_export;
	output	[9:0]	leds_export;
	input		reset_reset_n;
	input		spi_0_MISO;
	output		spi_0_MOSI;
	output		spi_0_SCLK;
	output		spi_0_SS_n;
	input		uart_0_rxd;
	output		uart_0_txd;
endmodule
