library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InvShiftRows is
  generic (
    DATA_WIDTH   : integer := 16;
    NIBBLE_WIDTH : integer := 4;
    SHIFT        : integer := 1
  );
  port (
    state_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of InvShiftRows is
  constant NUM_NIBBLES : integer := DATA_WIDTH / NIBBLE_WIDTH;

  function get_nibble(
    v : std_logic_vector;
    i : integer
  ) return std_logic_vector is
    variable res : std_logic_vector(NIBBLE_WIDTH-1 downto 0);
  begin
    res := v((i+1)*NIBBLE_WIDTH-1 downto i*NIBBLE_WIDTH);
    return res;
  end function;

begin
  gen_rotate : for i in 0 to NUM_NIBBLES-1 generate
       constant SRC : integer := (i - SHIFT + NUM_NIBBLES) mod NUM_NIBBLES;
  begin
    state_out((i+1)*NIBBLE_WIDTH-1 downto i*NIBBLE_WIDTH) <= get_nibble(state_in, SRC);
  end generate;
end architecture;
