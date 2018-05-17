library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity cpu_comp_tb is
end cpu_comp_tb;

architecture behav of cpu_comp_tb is
--  Declaration of the component that will be instantiated.
  component cpu
    port (I   : in  std_logic_vector(7 downto 0);
          clk : in  std_logic;
          O   : out std_logic_vector(7 downto 0)
          );
  end component;

--  Specifies which entity is bound with the component.
  signal I, O : std_logic_vector(7 downto 0);
  signal clk  : std_logic;
begin
--  Component instantiation.
  cpu0 : cpu port map(I   => I,
                      clk => clk,
                      O   => O
                      );

--  This process does the real job.
  process
    type pattern_type is record
--  The inputs of the shift_reg.
      I   : std_logic_vector(7 downto 0);
      clk : std_logic;
--  The expected outputs of the shift_reg.
      O   : std_logic_vector (7 downto 0);
    end record;
--  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("10000001", '0', "UUUUUUUU"), 
       ("10000001", '1', "UUUUUUUU"), -- load r0 1
       ("10010001", '0', "UUUUUUUU"),
       ("10010001", '1', "UUUUUUUU"), -- load r1 1
       ("10101111", '0', "UUUUUUUU"),
       ("10101111", '1', "00000001"), -- load r2 -1 
       ("10111111", '0', "00000001"),
       ("10111111", '1', "00000001"), -- load r3 -1
       ("11000010", '0', "00000001"),
       ("11000010", '1', "11111111"), -- cmp r0 r1 (1=1) SKIP ONE
       ("11111000", '0', "11111111"),
       ("11111000", '1', "11111111"), -- print r3 (skipped)
       ("11000011", '0', "11111111"),
       ("11000011", '1', "00000001"), -- cmp r0 r1 (1-1) SKIP TWO
       ("11111000", '0', "00000001"),
       ("10110111", '1', "00000000"), -- load r3 7
       ("11111000", '0', "00000000"),
       ("11111000", '1', "00000001"), -- print r3 (skipped)
       ("11000100", '0', "00000001"),
       ("11000100", '1', "00000000"), -- cmp r0 r2 (-1!=1) DOES NOT SKIP ONE
       ("11111000", '0', "00000000"),
       ("11111000", '1', "00000000"), -- print r3 (not skipped)
       ("11000101", '0', "00000000"),
       ("11000101", '1', "00000000"), -- cmp r0 r2 (-1!=1) DOES NOT SKIP TWO
       ("11111000", '0', "00000000"),
       ("11111000", '1', "11111111"), -- print r3 (not skipped)
       ("11111000", '0', "11111111"),
       ("11111000", '1', "00000000"), -- print r3 (not skipped)
       ("11010110", '0', "00000000"),
       ("11010110", '1', "11111111"), -- cmp r2 r3 (-1=-1) SKIP ONE
       ("11111000", '0', "11111111"),
       ("11111000", '1', "11111111"),  -- print r3 (skipped)
       ("11100001", '0', "11111111"),
       ("11100001", '1', "00000001"),
       ("11100001", '0', "00000001"),
       ("11100001", '1', "00000000")
       );
  begin
--  Check each pattern.
    for n in patterns'range loop
--  Set the inputs.
      I   <= patterns(n).I;
      clk <= patterns(n).clk;
--  Wait for the results.
      wait for 1 ns;
--  Check the outputs.
      assert O = patterns(n).O
        report "bad output value" severity error;
    end loop;
    assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
