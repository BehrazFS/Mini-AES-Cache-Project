library ieee;
use ieee.std_logic_1164.all;

entity InvSubBytes is
    generic(
        DATA_WIDTH : integer := 16;
        NIBBLE_WIDTH : integer := 4
    );
    port(
        state_in : in  std_logic_vector(DATA_WIDTH-1 downto 0);
        state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end entity;

architecture rtl of InvSubBytes is
    constant NUM_NIBBLES : integer := DATA_WIDTH / NIBBLE_WIDTH;

    function inv_sbox(n : std_logic_vector(NIBBLE_WIDTH-1 downto 0)) return std_logic_vector is
    begin
        case n is
            when x"0" => return x"4";  -- 4 -> 0
            when x"1" => return x"8";  -- 8 -> 1
            when x"2" => return x"6";  -- 6 -> 2
            when x"3" => return x"A";  -- A -> 3
            when x"4" => return x"1";  -- 1 -> 4
            when x"5" => return x"3";  -- 3 -> 5
            when x"6" => return x"0";  -- 0 -> 6
            when x"7" => return x"5";  -- 5 -> 7
            when x"8" => return x"C";  -- C -> 8
            when x"9" => return x"E";  -- E -> 9
            when x"A" => return x"D";  -- D -> A
            when x"B" => return x"F";  -- F -> B
            when x"C" => return x"2";  -- 2 -> C
            when x"D" => return x"B";  -- B -> D
            when x"E" => return x"7";  -- 7 -> E
            when others => return x"9";-- 9 -> others
        end case;
    end function;

begin
    gen_inv_sbox: for i in 0 to NUM_NIBBLES-1 generate
        state_out((i+1)*NIBBLE_WIDTH-1 downto i*NIBBLE_WIDTH) <= inv_sbox(state_in((i+1)*NIBBLE_WIDTH-1 downto i*NIBBLE_WIDTH));
    end generate;
end architecture;
