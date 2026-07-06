library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SubBytes is
    generic(
        DATA_WIDTH : integer := 16;
        NIBBLE_WIDTH : integer := 4
    );
    port(
        state_in : in std_logic_vector(DATA_WIDTH-1 downto 0);
        state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of SubBytes is
    constant NUM_NIBBLES : integer := DATA_WIDTH / NIBBLE_WIDTH;

    function sbox(n : std_logic_vector(NIBBLE_WIDTH-1 downto 0)) return std_logic_vector is
    begin
        case n is
            when x"0" => return x"6";
            when x"1" => return x"4";
            when x"2" => return x"C";
            when x"3" => return x"5";
            when x"4" => return x"0";
            when x"5" => return x"7";
            when x"6" => return x"2";
            when x"7" => return x"E";
            when x"8" => return x"1";
            when x"9" => return x"F";
            when x"A" => return x"3";
            when x"B" => return x"D";
            when x"C" => return x"8";
            when x"D" => return x"A";
            when x"E" => return x"9";
            when others => return x"B";
        end case;
    end function;
    
begin
    gen_sbox: for i in 0 to NUM_NIBBLES-1 generate
        state_out((i+1)*NIBBLE_WIDTH-1 downto i*NIBBLE_WIDTH) <= sbox(state_in((i+1)*NIBBLE_WIDTH-1 downto i*NIBBLE_WIDTH));
    end generate;
end architecture;