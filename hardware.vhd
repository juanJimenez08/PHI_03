library ieee;
use ieee.std_logic_1164.all;

entity hardware is
    port (
       
        CLOCK_50 : in std_logic;                    
        KEY      : in std_logic_vector(3 downto 0); 
        LEDR     : out std_logic_vector(9 downto 0); 
        HEX0     : out std_logic_vector(6 downto 0); 
        HEX1     : out std_logic_vector(6 downto 0); 
        HEX2     : out std_logic_vector(6 downto 0); 
        HEX3     : out std_logic_vector(6 downto 0); 
        HEX4     : out std_logic_vector(6 downto 0); 
        HEX5     : out std_logic_vector(6 downto 0)  
    );
end entity hardware;

architecture rtl of hardware is

    component myhardware is
        port (
            clk_clk       : in  std_logic                     := 'X'; 
            hex0_export   : out std_logic_vector(6 downto 0);         
            hex1_export   : out std_logic_vector(6 downto 0);         
            hex2_export   : out std_logic_vector(6 downto 0);         
            hex3_export   : out std_logic_vector(6 downto 0);         
            hex4_export   : out std_logic_vector(6 downto 0);         
            hex5_export   : out std_logic_vector(6 downto 0);         
            leds_export   : out std_logic_vector(9 downto 0);         
            reset_reset_n : in  std_logic                     := 'X'  
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
            hex5_export   => HEX5         
        );

end architecture rtl;