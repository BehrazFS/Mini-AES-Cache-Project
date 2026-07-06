library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.gf_math_generic.ALL;

entity MixColumns is
  generic (
    DATA_WIDTH   : integer := 16; 
    NIBBLE_WIDTH : integer := 4   
  );
  port (
    state_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of MixColumns is

    signal s0, s1, s2, s3 : std_logic_vector(3 downto 0);
    signal s_prime_0, s_prime_1, s_prime_2, s_prime_3 : std_logic_vector(3 downto 0);

begin

    s0 <= state_in(15 downto 12);
    s1 <= state_in(11 downto 8);
    s2 <= state_in(7 downto 4);
    s3 <= state_in(3 downto 0);

    -- Perform the MixColumns matrix multiplication in GF(2^4)
    -- The matrix is [02 03 01 01], [01 02 03 01], [01 01 02 03], [03 01 01 02]
    
    s_prime_0 <= gf_mult(s0, x"2") xor gf_mult(s1, x"3") xor s2 xor s3;
    s_prime_1 <= s0 xor gf_mult(s1, x"2") xor gf_mult(s2, x"3") xor s3;
    s_prime_2 <= s0 xor s1 xor gf_mult(s2, x"2") xor gf_mult(s3, x"3");
    s_prime_3 <= gf_mult(s0, x"3") xor s1 xor s2 xor gf_mult(s3, x"2");

    state_out <= s_prime_0 & s_prime_1 & s_prime_2 & s_prime_3;

end architecture;
