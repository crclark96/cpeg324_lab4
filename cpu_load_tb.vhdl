library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity cpu_load_tb is
end cpu_load_tb;

architecture behav of cpu_load_tb is
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
      (("11100000", '0', "UUUUUUUU"), 
       ("11100000", '1', "UUUUUUUU"), -- print r0 (0)
       ("11101000", '0', "UUUUUUUU"),
       ("11101000", '1', "UUUUUUUU"), -- print r1 (0)
       ("11110000", '0', "UUUUUUUU"),
       ("11110000", '1', "00000000"), -- print r2 (0)
       ("11111000", '0', "00000000"),
       ("11111000", '1', "00000000"), -- print r3 (0)
       ("10001111", '0', "00000000"),
       ("10001111", '1', "00000000"), -- load r0 -1
       ("10010001", '0', "00000000"),
       ("10010001", '1', "00000000"), -- load r1 1
       ("10100111", '0', "00000000"),
       ("10100111", '1', "11111111"), -- load r2 7
       ("10111000", '0', "11111111"),
       ("10111000", '1', "00000001"), -- load r3 -8
       ("11100000", '0', "00000001"),
       ("11100000", '1', "00000111"), -- print r0 (-1)
       ("11101000", '0', "00000111"),
       ("11101000", '1', "11111000"), -- print r1 (1)
       ("11110000", '0', "11111000"),
       ("11110000", '1', "11111111"), -- print r2 (7)
       ("11111000", '0', "11111111"),
       ("11111000", '1', "00000001"), -- print r3 (-8)	("11100001", '0', "00000001"),
       ("11100001", '0', "00000001"),
       ("11100001", '1', "00000111"),
       ("11100001", '0', "00000111"),
       ("11100001", '1', "11111000")
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
