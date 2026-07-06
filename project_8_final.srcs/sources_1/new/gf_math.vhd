library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package gf_math_generic is

  -- Generic parameters
  constant N_BITS : integer := 4;  -- field size (e.g., 4 for GF(2^4))
  constant IRREDUCIBLE_POLY : std_logic_vector(N_BITS-1 downto 0) := "0011";

  -- Function to multiply two N_BITS numbers in GF(2^N_BITS)
  function gf_mult (a : std_logic_vector(N_BITS-1 downto 0); 
                    b : std_logic_vector(N_BITS-1 downto 0)) 
    return std_logic_vector;

end package gf_math_generic;


package body gf_math_generic is

  function gf_mult (a : std_logic_vector(N_BITS-1 downto 0); 
                    b : std_logic_vector(N_BITS-1 downto 0)) 
    return std_logic_vector is
    
    variable a_reg   : std_logic_vector(N_BITS-1 downto 0) := a;
    variable b_reg   : std_logic_vector(N_BITS-1 downto 0) := b;
    variable result  : std_logic_vector(N_BITS-1 downto 0) := (others => '0');
    variable i       : integer;
    
  begin
    -- Russian Peasant Multiplication algorithm for GF(2^N_BITS)
    for i in 0 to N_BITS-1 loop
      if b_reg(0) = '1' then
        result := result xor a_reg;
      end if;

      -- Shift left a_reg and reduce modulo IRREDUCIBLE_POLY if MSB is 1
      if a_reg(N_BITS-1) = '1' then
        a_reg := (a_reg(N_BITS-2 downto 0) & '0') xor IRREDUCIBLE_POLY;
      else
        a_reg := a_reg(N_BITS-2 downto 0) & '0';
      end if;

      -- Shift right b_reg
      b_reg := '0' & b_reg(N_BITS-1 downto 1);
    end loop;
    
    return result;
  end function gf_mult;

end package body gf_math_generic;
