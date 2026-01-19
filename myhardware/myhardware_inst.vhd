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
			reset_reset_n : in  std_logic                    := 'X'  -- reset_n
		);
	end component myhardware;

	u0 : component myhardware
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			hex0_export   => CONNECTED_TO_hex0_export,   --  hex0.export
			hex1_export   => CONNECTED_TO_hex1_export,   --  hex1.export
			hex2_export   => CONNECTED_TO_hex2_export,   --  hex2.export
			hex3_export   => CONNECTED_TO_hex3_export,   --  hex3.export
			hex4_export   => CONNECTED_TO_hex4_export,   --  hex4.export
			hex5_export   => CONNECTED_TO_hex5_export,   --  hex5.export
			leds_export   => CONNECTED_TO_leds_export,   --  leds.export
			reset_reset_n => CONNECTED_TO_reset_reset_n  -- reset.reset_n
		);

