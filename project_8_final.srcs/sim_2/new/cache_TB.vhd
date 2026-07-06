library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cache is
end entity;

architecture sim of tb_cache is

  -- ===== Generics (must match DUT defaults) =====
  constant Number_of_Blocks : integer := 4;
  constant AddrWidth        : integer := 8;
  constant DataWidth        : integer := 8;

  -- ===== Signals =====
  signal clk      : std_logic := '0';
  signal MemRead  : std_logic := '0';
  signal MemWrite : std_logic := '0';
  signal Address  : std_logic_vector(AddrWidth-1 downto 0) := (others => '0');
  signal DataIn   : std_logic_vector(DataWidth-1 downto 0) := (others => '0');
  signal DataOut  : std_logic_vector(DataWidth-1 downto 0);
  signal Hit      : std_logic;

  constant CLK_PERIOD : time := 10 ns;
  constant NumberOfTests :integer := 4;
  type addr_array_t is array (0 to NumberOfTests-1) of std_logic_vector(AddrWidth-1 downto 0);
  type dataIn_array_t is array (0 to NumberOfTests-1) of std_logic_vector(DataWidth-1 downto 0);

begin

  -- ===== Clock Generation =====
  clk <= not clk after CLK_PERIOD/2;

  -- ===== DUT =====
  dut: entity work.cache
    generic map (
      Number_of_Blocks => Number_of_Blocks,
      AddrWidth        => AddrWidth,
      DataWidth        => DataWidth
    )
    port map (
      clk      => clk,
      MemRead  => MemRead,
      MemWrite => MemWrite,
      Address  => Address,
      DataIn   => DataIn,
      DataOut  => DataOut,
      Hit      => Hit
    );

  stim_proc : process
    constant Addresses : addr_array_t := (
        0 => "00010011",
        1 => "00010011",
        2 => "00100011",
        3 => "00100011"
    );
    constant DataIns : dataIn_array_t := (
        0 => x"5A",
        1 => x"5A",
        2 => x"A5",
        3 => x"A5"
    );
    begin
    -- Initial state
    MemRead  <= '0';
    MemWrite <= '0';
    Address  <= (others => '0');
    DataIn   <= (others => '0');

    wait for 15 ns;

    for i in 0 to NumberOfTests-1 loop

        -- Setup read
        Address  <= Addresses(i);
        MemRead  <= '1';
        MemWrite <= '0';

        wait until rising_edge(clk);  -- allow Hit to update

        MemRead <= '0';

        -- Check hit/miss AFTER clock
        if Hit = '0' then
            -- Cache miss => write
            DataIn   <= DataIns(i);
            MemWrite <= '1';

            wait until rising_edge(clk);

            MemWrite <= '0';
        end if;

        wait for 10 ns;
    end loop;

    wait;
end process;

end architecture;
