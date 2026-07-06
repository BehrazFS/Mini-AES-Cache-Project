library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MiniAES_Enc is
  generic (
    DATA_WIDTH   : integer := 16;  
    NIBBLE_WIDTH : integer := 4;  
    ROUNDS       : integer := 2;  
    SHIFT        : integer := 1    
  );
  port (
    state_in  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    key       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    state_out : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture comb of MiniAES_Enc is

  type state_array_t is array(0 to ROUNDS) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal round_state : state_array_t;

  signal subbytes_out  :state_array_t;
  signal shiftrows_out : state_array_t;
  signal mixcolumns_out : state_array_t;

begin

  round_state(0) <= state_in;

  gen_rounds: for i in 1 to ROUNDS-1 generate
    -- SubBytes
    u_subbytes: entity work.SubBytes
      generic map(DATA_WIDTH => DATA_WIDTH, NIBBLE_WIDTH => NIBBLE_WIDTH)
      port map(state_in => round_state(i-1), state_out => subbytes_out(i-1));

    -- ShiftRows
    u_shiftrows: entity work.ShiftRows
      generic map(DATA_WIDTH => DATA_WIDTH, NIBBLE_WIDTH => NIBBLE_WIDTH, SHIFT => SHIFT)
      port map(state_in => subbytes_out(i-1), state_out => shiftrows_out(i-1));

    -- MixColumns 
      u_mix: entity work.MixColumns
        generic map(DATA_WIDTH => DATA_WIDTH, NIBBLE_WIDTH => NIBBLE_WIDTH)
        port map(state_in => shiftrows_out(i-1), state_out => mixcolumns_out(i-1));
    
     u_addroundkey: entity work.AddRoundKey
      generic map(DATA_WIDTH => DATA_WIDTH)
      port map(
        state_in  => mixcolumns_out(i-1),
        round_key => key,
        state_out => round_state(i)
      );


  end generate;
     u_subbytes: entity work.SubBytes
      generic map(DATA_WIDTH => DATA_WIDTH, NIBBLE_WIDTH => NIBBLE_WIDTH)
      port map(state_in => round_state(ROUNDS-1), state_out => subbytes_out(ROUNDS-1));

    -- ShiftRows
    u_shiftrows: entity work.ShiftRows
      generic map(DATA_WIDTH => DATA_WIDTH, NIBBLE_WIDTH => NIBBLE_WIDTH, SHIFT => SHIFT)
      port map(state_in => subbytes_out(ROUNDS-1), state_out => shiftrows_out(ROUNDS-1));

     u_addroundkey: entity work.AddRoundKey
      generic map(DATA_WIDTH => DATA_WIDTH)
      port map(
        state_in  => shiftrows_out(ROUNDS-1),
        round_key => key,
        state_out => round_state(ROUNDS)
      );
  state_out <= round_state(ROUNDS);

end architecture;

