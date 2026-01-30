library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_operacional is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        -- Interface de Escrita (Vem do Avalon)
        wr_en       : in  std_logic;
        wr_addr     : in  std_logic_vector(4 downto 0);
        wr_data     : in  std_logic_vector(7 downto 0);
        -- Interface de Leitura (Vem do Controle)
        start_index : in  integer range 0 to 31;
        -- Saída para o Mundo
        hex_output  : out std_logic_vector(41 downto 0)
    );
end entity bloco_operacional;

architecture rtl of bloco_operacional is
    type ram_type is array (0 to 31) of std_logic_vector(7 downto 0);
    signal ram : ram_type := (others => x"20"); -- Espaços

    function char_to_seg(char : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable hex_val : integer;
        variable seg : std_logic_vector(6 downto 0);
    begin
        -- (Mesma função de decodificação anterior - resumida aqui)
        if (unsigned(char) >= 48 and unsigned(char) <= 57) then hex_val := to_integer(unsigned(char)) - 48;
        elsif (unsigned(char) >= 65 and unsigned(char) <= 70) then hex_val := to_integer(unsigned(char)) - 55;
        else hex_val := 16; end if;
        
        case hex_val is
            when 0 => seg := "1000000"; when 1 => seg := "1111001"; when 2 => seg := "0100100";
            when 3 => seg := "0110000"; when 4 => seg := "0011001"; when 5 => seg := "0010010";
            when 6 => seg := "0000010"; when 7 => seg := "1111000"; when 8 => seg := "0000000";
            when 9 => seg := "0010000"; when 10=> seg := "0001000"; when 11=> seg := "0000011";
            when 12=> seg := "1000110"; when 13=> seg := "0100001"; when 14=> seg := "0000110";
            when 15=> seg := "0001110"; when others => seg := "1111111";
        end case;
        return seg;
    end function;
begin
    -- Escrita na RAM (Sincrona)
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                ram(to_integer(unsigned(wr_addr))) <= wr_data;
            end if;
        end if;
    end process;

    -- Leitura Combinacional para os Displays
    process(start_index, ram)
    begin
        hex_output(41 downto 35) <= char_to_seg(ram((start_index) mod 32));
        hex_output(34 downto 28) <= char_to_seg(ram((start_index + 1) mod 32));
        hex_output(27 downto 21) <= char_to_seg(ram((start_index + 2) mod 32));
        hex_output(20 downto 14) <= char_to_seg(ram((start_index + 3) mod 32));
        hex_output(13 downto 7)  <= char_to_seg(ram((start_index + 4) mod 32));
        hex_output(6 downto 0)   <= char_to_seg(ram((start_index + 5) mod 32));
    end process;
end rtl;