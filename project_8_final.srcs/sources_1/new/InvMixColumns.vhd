library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.gf_math_generic.ALL; 

entity InvMixColumns is
  generic (
    DATA_WIDTH   : integer := 16;
    NIBBLE_WIDTH : integer := 4
  );
  port (
    state_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of InvMixColumns is

    signal s0, s1, s2, s3 : std_logic_vector(3 downto 0);
    signal s_double_prime_0, s_double_prime_1, s_double_prime_2, s_double_prime_3 : std_logic_vector(3 downto 0);

begin

    s0 <= state_in(15 downto 12);
    s1 <= state_in(11 downto 8);
    s2 <= state_in(7 downto 4);
    s3 <= state_in(3 downto 0);

    -- Perform the InvMixColumns matrix multiplication in GF(2^4)
    -- The matrix is [0e 0b 0d 09], [09 0e 0b 0d], [0d 09 0e 0b], [0b 0d 09 0e]
    
    s_double_prime_0 <= gf_mult(s0, x"E") xor gf_mult(s1, x"B") xor gf_mult(s2, x"D") xor gf_mult(s3, x"9");
    s_double_prime_1 <= gf_mult(s0, x"9") xor gf_mult(s1, x"E") xor gf_mult(s2, x"B") xor gf_mult(s3, x"D");
    s_double_prime_2 <= gf_mult(s0, x"D") xor gf_mult(s1, x"9") xor gf_mult(s2, x"E") xor gf_mult(s3, x"B");
    s_double_prime_3 <= gf_mult(s0, x"B") xor gf_mult(s1, x"D") xor gf_mult(s2, x"9") xor gf_mult(s3, x"E");

    state_out <= s_double_prime_0 & s_double_prime_1 & s_double_prime_2 & s_double_prime_3;
end architecture;
