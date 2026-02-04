library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bloco_operacional is
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        
        -- Interface de Escrita da Memória 
        wr_en       : in  std_logic;
        wr_addr     : in  std_logic_vector(5 downto 0); -- Endereço de 6 bits
        wr_data     : in  std_logic_vector(31 downto 0); 
        
        -- Interface de Leitura 
        start_index : in  integer range 0 to 31;
        system_on   : in  std_logic; 
        
       --saida
        hex_output  : out std_logic_vector(41 downto 0)
    );
end entity bloco_operacional;

architecture rtl of bloco_operacional is

    -- Memória RAM de 32 posições (Chars)
    type ram_type is array (0 to 31) of std_logic_vector(7 downto 0);
    signal ram : ram_type := (others => x"20"); -- Inicia com espaços

    
    function char_to_seg(char : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
        variable char_int : integer;
    begin
        char_int := to_integer(unsigned(char));
        
        -- Converte minúscula para maiúscula (a=97 -> A=65)
        if char_int >= 97 and char_int <= 122 then
            char_int := char_int - 32;
        end if;

        case char_int is
            -- Números
            when 48 => seg := "1000000"; -- 0
            when 49 => seg := "1111001"; -- 1
            when 50 => seg := "0100100"; -- 2
            when 51 => seg := "0110000"; -- 3
            when 52 => seg := "0011001"; -- 4
            when 53 => seg := "0010010"; -- 5
            when 54 => seg := "0000010"; -- 6
            when 55 => seg := "1111000"; -- 7
            when 56 => seg := "0000000"; -- 8
            when 57 => seg := "0010000"; -- 9
            -- Letras (A-Z)
            when 65 => seg := "0001000"; -- A
            when 66 => seg := "0000011"; -- B
            when 67 => seg := "1000110"; -- C
            when 68 => seg := "0100001"; -- D
            when 69 => seg := "0000110"; -- E
            when 70 => seg := "0001110"; -- F
            when 71 => seg := "0000010"; -- G
            when 72 => seg := "0001001"; -- H
            when 73 => seg := "1111001"; -- I
            when 74 => seg := "1100001"; -- J
            when 75 => seg := "0001001"; -- K
            when 76 => seg := "1000111"; -- L
            when 77 => seg := "0001000"; -- M
            when 78 => seg := "0101011"; -- N
            when 79 => seg := "1000000"; -- O
            when 80 => seg := "0001100"; -- P
            when 81 => seg := "0011000"; -- Q
            when 82 => seg := "0101111"; -- R
            when 83 => seg := "0010010"; -- S
            when 84 => seg := "0000111"; -- T
            when 85 => seg := "1000001"; -- U
            when 86 => seg := "1000001"; -- V
            when 87 => seg := "1000001"; -- W
            when 88 => seg := "0001001"; -- X
            when 89 => seg := "0010001"; -- Y
            when 90 => seg := "0100100"; -- Z
            -- Outros
            when 32 => seg := "1111111"; -- Espaço
            when 45 => seg := "0111111"; -- -
            when 95 => seg := "1110111"; -- _
            when others => seg := "1111111"; -- Apagado
        end case;
        return seg;
    end function;

begin

    -- Escrita na RAM (Vem do C)
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                -- Só escreve na RAM se o endereço for < 32
                if unsigned(wr_addr) < 32 then
                    ram(to_integer(unsigned(wr_addr(4 downto 0)))) <= wr_data(7 downto 0);
                end if;
            end if;
        end if;
    end process;

    -- Leitura e Exibição nos Displays
    process(start_index, ram, system_on)
    begin
        if system_on = '1' then
            -- Funcionamento Normal (Switch ON)
            hex_output(41 downto 35) <= char_to_seg(ram((start_index) mod 32));
            hex_output(34 downto 28) <= char_to_seg(ram((start_index + 1) mod 32));
            hex_output(27 downto 21) <= char_to_seg(ram((start_index + 2) mod 32));
            hex_output(20 downto 14) <= char_to_seg(ram((start_index + 3) mod 32));
            hex_output(13 downto 7)  <= char_to_seg(ram((start_index + 4) mod 32));
            hex_output(6 downto 0)   <= char_to_seg(ram((start_index + 5) mod 32));
        else
            -- Desligado (Switch OFF) 
            hex_output <= (others => '1');
        end if;
    end process;

end rtl;
