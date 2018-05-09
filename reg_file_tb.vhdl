library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity reg_file_tb is
end reg_file_tb;

architecture behav of reg_file_tb is
--  Declaration of the component that will be instantiated.
  component reg_file
    port (r1     : in  std_logic_vector (1 downto 0);
          r2     : in  std_logic_vector(1 downto 0);
          enable : in  std_logic;
          clk    : in  std_logic;
          d      : in  std_logic_vector(1 downto 0);
          w      : in  std_logic_vector(7 downto 0);
          v1     : out std_logic_vector(7 downto 0);
          v2     : out std_logic_vector(7 downto 0)
          );
  end component;
--  Specifies which entity is bound with the component.
  signal r1_tb, r2_tb, d_tb  : std_logic_vector(1 downto 0);
  signal clock_tb, enable_tb : std_logic;
  signal w_tb, v1_tb, v2_tb  : std_logic_vector(7 downto 0);
begin
--  Component instantiation.
  reg_file_tb : reg_file port map (r1     => r1_tb,
                                   r2     => r2_tb,
                                   enable => enable_tb,
                                   clk    => clock_tb,
                                   d      => d_tb,
                                   w      => w_tb,
                                   v1     => v1_tb,
                                   v2     => v2_tb);

--  This process does the real job.
  process
    type pattern_type is record
--  The inputs of the reg_file.
      r1, r2, d   : std_logic_vector (1 downto 0);
      enable, clk : std_logic;
      w           : std_logic_vector(7 downto 0);

--  The expected outputs of the reg_file.
      v1, v2 : std_logic_vector (7 downto 0);
    end record;
--  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
--     (("r1", "r2", "d", "enable", "clock", "w", "v1", "v2")
      (("00", "01", "00", '0', '0', "11111111", "00000000", "00000000"),  -- clock and enable off
       ("00", "01", "00", '0', '1', "11111111", "00000000", "00000000"),  -- clock off
       ("00", "01", "00", '1', '0', "00000000", "00000000", "00000000"),  -- enable off
       ("00", "01", "00", '1', '1', "11111111", "00000000", "00000000"),  -- writes 0 to register 0
       ("00", "01", "01", '0', '0', "11111111", "00000000", "00000000"),  -- off
       ("00", "01", "01", '0', '1', "11111111", "00000000", "00000000"),  -- off
       ("00", "01", "01", '1', '0', "00000001", "00000000", "00000000"),  -- off
       ("00", "01", "01", '1', '1', "11111111", "00000000", "00000001"),  -- writes 1 to register 1
       ("10", "11", "10", '0', '0', "11111111", "00000000", "00000000"),  -- off
       ("10", "11", "10", '0', '1', "11111111", "00000000", "00000000"),  -- off
       ("10", "11", "10", '1', '0', "00000010", "00000000", "00000000"),  -- off
       ("10", "11", "10", '1', '1', "11111111", "00000010", "00000000"),  -- writes 2 to register 2
       ("10", "11", "11", '0', '0', "11111111", "00000010", "00000000"),  -- off
       ("10", "11", "11", '0', '1', "11111111", "00000010", "00000000"),  -- off
       ("10", "11", "11", '1', '0', "00000011", "00000010", "00000000"),  -- off
       ("10", "11", "11", '1', '1', "11111111", "00000010", "00000011"),  -- writes 3 to register 3
       ("00", "01", "00", '0', '0', "11111111", "00000000", "00000001"),  
       ("10", "11", "00", '0', '0', "11111111", "00000010", "00000011")
       );

  begin
--  Check each pattern.
    for n in patterns'range loop
--  Set the inputs.
      r1_tb     <= patterns(n).r1;
      r2_tb     <= patterns(n).r2;
      d_tb      <= patterns(n).d;
      clock_tb  <= patterns(n).clk;
      enable_tb <= patterns(n).enable;
      w_tb      <= patterns(n).w;
--  Wait for the results.
      wait for 1 ns;
--  Check the outputs.
      assert v1_tb = patterns(n).v1
        report "bad output value" severity error;
      assert v2_tb = patterns(n).v2
        report "bad output value" severity error;
    end loop;
    assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
