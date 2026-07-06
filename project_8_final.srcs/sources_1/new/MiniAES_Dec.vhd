library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MiniAES_Dec is
  generic (
    DATA_WIDTH   : integer := 16;
    NIBBLE_WIDTH : integer := 4;
    ROUNDS       : integer := 2;
    SHIFT        : integer := 1
  );
  port(
    state_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    key       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of MiniAES_Dec is

  type state_array_t is array (0 to ROUNDS) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal round_state : state_array_t;
--  signal inv_subbytes_out  :state_array_t;
  signal inv_addkey_out  :state_array_t;
  signal inv_shiftrows_out : state_array_t;
  signal inv_mixcolumns_out : state_array_t;

begin

  round_state(0) <= state_in;
  u_addroundkey: entity work.AddRoundKey
      generic map(DATA_WIDTH => DATA_WIDTH)
      port map(
        state_in  => round_state(0),
        round_key => key,
        state_out => inv_addkey_out(0)
      );
  
  u_invshift: entity work.ShiftRows
      generic map(
        DATA_WIDTH   => DATA_WIDTH,
        NIBBLE_WIDTH => NIBBLE_WIDTH,
        SHIFT        => DATA_WIDTH/NIBBLE_WIDTH - SHIFT  -- rotate right
      )
      port map(
        state_in  => inv_addkey_out(0),
        state_out => inv_shiftrows_out(0)
      );


    u_invsub: entity work.InvSubBytes
      generic map(
        DATA_WIDTH   => DATA_WIDTH,
        NIBBLE_WIDTH => NIBBLE_WIDTH
      )
      port map(
        state_in  => inv_shiftrows_out(0),
        state_out => round_state(1)
      );
  gen_rounds: for i in 2 to ROUNDS generate

    u_addroundkey: entity work.AddRoundKey
      generic map(DATA_WIDTH => DATA_WIDTH)
      port map(
        state_in  => round_state(i-1),
        round_key => key,
        state_out => inv_addkey_out(i-1)
      );

    
      u_invmix: entity work.InvMixColumns
        generic map(
          DATA_WIDTH   => DATA_WIDTH,
          NIBBLE_WIDTH => NIBBLE_WIDTH
        )
        port map(
          state_in  => inv_addkey_out(i-1),
          state_out => inv_mixcolumns_out(i-1)
        );
      


    u_invshift: entity work.ShiftRows
      generic map(
        DATA_WIDTH   => DATA_WIDTH,
        NIBBLE_WIDTH => NIBBLE_WIDTH,
        SHIFT        => DATA_WIDTH/NIBBLE_WIDTH - SHIFT  -- rotate right
      )
      port map(
        state_in  => inv_mixcolumns_out(i-1),
        state_out => inv_shiftrows_out(i-1)
      );


    u_invsub: entity work.InvSubBytes
      generic map(
        DATA_WIDTH   => DATA_WIDTH,
        NIBBLE_WIDTH => NIBBLE_WIDTH
      )
      port map(
        state_in  => inv_shiftrows_out(i-1),
        state_out => round_state(i)
      );

  end generate;

  state_out <= round_state(ROUNDS);

end architecture;
