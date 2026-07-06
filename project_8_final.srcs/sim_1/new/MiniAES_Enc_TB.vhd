library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_MiniAES_EncDec is
end entity;

architecture sim of tb_MiniAES_EncDec is

  constant DATA_WIDTH   : integer := 16;
  constant NIBBLE_WIDTH : integer := 4;
  constant ROUNDS       : integer := 2;
  constant SHIFT       : integer := 1;

  -- Signals for encryption
  signal state_in_enc           : std_logic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
  signal key_enc                : std_logic_vector(DATA_WIDTH-1 downto 0) := (others=>'0');
  signal state_out_enc          : std_logic_vector(DATA_WIDTH-1 downto 0);

  -- Signals for decryption
  signal state_in_dec           : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal key_dec                : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal state_out_dec          : std_logic_vector(DATA_WIDTH-1 downto 0);

begin

  uut_enc: entity work.MiniAES_Enc
    generic map(
      DATA_WIDTH   => DATA_WIDTH,
      NIBBLE_WIDTH => NIBBLE_WIDTH,
      ROUNDS       => ROUNDS,
      SHIFT        => SHIFT
    )
    port map(
      state_in  => state_in_enc,
      key       => key_enc,
      state_out => state_out_enc
    );

  uut_dec: entity work.MiniAES_Dec
    generic map(
      DATA_WIDTH   => DATA_WIDTH,
      NIBBLE_WIDTH => NIBBLE_WIDTH,
      ROUNDS       => ROUNDS,
      SHIFT        => SHIFT
    )
    port map(
      state_in  => state_in_dec,
      key       => key_dec,
      state_out => state_out_dec
    );
  key_dec <= key_enc;
  state_in_dec <= state_out_enc;

  sstim_proc: process
    begin
      state_in_enc <= x"1234";
      key_enc      <= x"ABCD";
      wait for 10 ns;
    
      state_in_enc <= x"5678";
      key_enc      <= x"1111";
      wait for 10 ns;
      
      state_in_enc <= x"AB11";
      key_enc      <= x"1234";
      wait for 10 ns;
      state_in_enc <= x"AAAA";
      key_enc      <= x"BCBC";
      state_in_enc <= x"9876";
      key_enc      <= x"1235";
      wait for 10 ns;
      wait for 10 ns;
      wait;
    end process;


end architecture;
