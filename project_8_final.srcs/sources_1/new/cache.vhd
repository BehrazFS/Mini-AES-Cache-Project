library IEEE;
use IEEE.STD_LOGIC_1164.ALL;    
use IEEE.numeric_std.all; 
entity cache is  
	generic(
        Number_of_Blocks : integer := 4;
        AddrWidth: integer := 8;
        DataWidth: integer:=8
    );
    Port (
        clk        : in  STD_LOGIC;
        MemRead    : in  STD_LOGIC;
        MemWrite   : in  STD_LOGIC;
        Address    : in  STD_LOGIC_VECTOR(AddrWidth-1 downto 0);
        DataIn     : in  STD_LOGIC_VECTOR(DataWidth-1 downto 0);
        DataOut    : out  STD_LOGIC_VECTOR(DataWidth-1 downto 0);
        Hit        : out std_logic
    );
end cache;

architecture Behavioral of cache is
  constant DATA_WIDTH   : integer := 16;
  constant NIBBLE_WIDTH : integer := 4;
  constant ROUNDS       : integer := 2;
  constant SHIFT       : integer := 1;
  constant ENCRYPTION_KEY : std_logic_vector(DATA_WIDTH-1 downto 0) := x"ABCD"; 
type CacheBlock is record
    tag  : std_logic_vector(AddrWidth - Number_of_Blocks -1 downto 0);
    data : std_logic_vector(DATA_WIDTH-1 downto 0);
    valid : std_logic;
end record;
Type MyMem is array(2**Number_of_Blocks -1 downto 0) of CacheBlock;

constant DEFAULT_Block : CacheBlock := (
    tag  => (others => '0'),
    data => (others => '0'),
    valid => '0'
);

-- Initialized memory
signal mem : MyMem := (
    others => DEFAULT_Block
);

signal tag : std_logic_vector(AddrWidth - Number_of_Blocks -1 downto 0); --4bit
signal block_i : std_logic_vector(Number_of_Blocks-1 downto 0); -- 4bit
signal encrypted_data,decrypted_data : std_logic_vector(DATA_WIDTH-1 downto 0);
begin
    uut_enc: entity work.MiniAES_Enc
    generic map(
      DATA_WIDTH   => DATA_WIDTH,
      NIBBLE_WIDTH => NIBBLE_WIDTH,
      ROUNDS       => ROUNDS,
      SHIFT        => SHIFT
    )
    port map(
      state_in  => ("00000000" & DataIn),
      key       => ENCRYPTION_KEY,
      state_out => encrypted_data
    );

  uut_dec: entity work.MiniAES_Dec
    generic map(
      DATA_WIDTH   => DATA_WIDTH,
      NIBBLE_WIDTH => NIBBLE_WIDTH,
      ROUNDS       => ROUNDS,
      SHIFT        => SHIFT
    )
    port map(
      state_in  => Mem(to_integer(unsigned(block_i))).data,
      key       => ENCRYPTION_KEY,
      state_out => decrypted_data
    ); 
    tag <= Address(AddrWidth-1 downto Number_of_Blocks);
    block_i <= Address(Number_of_Blocks-1 downto 0);
    process (clk)
    begin
        if clk'event and clk = '1' then
            if MemWrite = '1' then
                Mem(to_integer(unsigned(block_i))).tag <= tag;
                Mem(to_integer(unsigned(block_i))).data <= encrypted_data;
                Mem(to_integer(unsigned(block_i))).valid <= '1';
            end if;
        end if;
    end process;
    process(block_i,tag,MemRead)
    begin
        if MemRead = '1' then
            if Mem(to_integer(unsigned(block_i))).tag = tag and Mem(to_integer(unsigned(block_i))).valid = '1'  then
                DataOut <= decrypted_data(DataWidth-1 downto 0);
                Hit <= '1';
            else
                DataOut <= (Others=> '0');
                Hit <= '0';
            end if;
        else
            Hit <= 'Z';
            Dataout <= (Others=> 'Z');
        end if;
    end process;
end Behavioral;