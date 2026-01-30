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
        variable seg : std_logic_vector(6 downto 0);
        variable char_int : integer;
    begin
        char_int := to_integer(unsigned(char));

        -- TRUQUE: Se for letra minúscula (a-z -> 97-122), subtrai 32 para virar maiúscula (A-Z)
        -- Assim 'a' (97) vira 'A' (65) e usa o mesmo desenho.
        if char_int >= 97 and char_int <= 122 then
            char_int := char_int - 32;
        end if;

        -- Mapa de Segmentos (Lógica Ativa Baixa: 0 acende)
        -- Formato: "gfedcba"
        case char_int is
            -- Números (0-9)
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
            when 66 => seg := "0000011"; -- B (b minúsculo)
            when 67 => seg := "1000110"; -- C
            when 68 => seg := "0100001"; -- D (d minúsculo)
            when 69 => seg := "0000110"; -- E
            when 70 => seg := "0001110"; -- F
            when 71 => seg := "0000010"; -- G (Igual ao 6, mas com 'a' ligado, opcional: "0100000")
            when 72 => seg := "0001001"; -- H
            when 73 => seg := "1111001"; -- I (Igual ao 1)
            when 74 => seg := "1100001"; -- J
            when 75 => seg := "0001001"; -- K (Igual ao H)
            when 76 => seg := "1000111"; -- L
            when 77 => seg := "0001000"; -- M (Não cabe, usa A ou n)
            when 78 => seg := "0101011"; -- N (n minúsculo)
            when 79 => seg := "1000000"; -- O (Igual ao 0)
            when 80 => seg := "0001100"; -- P
            when 81 => seg := "0011000"; -- Q (q)
            when 82 => seg := "0101111"; -- R (r minúsculo)
            when 83 => seg := "0010010"; -- S (Igual ao 5)
            when 84 => seg := "0000111"; -- T (t minúsculo)
            when 85 => seg := "1000001"; -- U
            when 86 => seg := "1000001"; -- V (Usa U)
            when 87 => seg := "1000001"; -- W (Usa U)
            when 88 => seg := "0001001"; -- X (Usa H)
            when 89 => seg := "0010001"; -- Y
            when 90 => seg := "0100100"; -- Z (Igual ao 2)

            -- Símbolos Especiais
            when 32 => seg := "1111111"; -- Espaço (Space)
            when 45 => seg := "0111111"; -- Hífen (-)
            when 95 => seg := "1110111"; -- Underline (_)
            
            -- Qualquer outra coisa (Erro ou Desconhecido)
            when others => seg := "1111111"; -- Apagado
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