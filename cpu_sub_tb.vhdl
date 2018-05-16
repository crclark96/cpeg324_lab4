library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity cpu_sub_tb is
end cpu_sub_tb;

architecture behav of cpu_sub_tb is
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
       ("11100000", '1', "UUUUUUUU"), -- print r0 
       ("11101000", '0', "UUUUUUUU"), 
       ("11101000", '1', "UUUUUUUU"), -- print r1
       ("11110000", '0', "UUUUUUUU"),
       ("11110000", '1', "00000000"), -- print r2
       ("11111000", '0', "00000000"),
       ("11111000", '1', "00000000"), -- print r3
       ("10000001", '0', "00000000"),
       ("10000001", '1', "00000000"), -- load r0 1
       ("10011111", '0', "00000000"),
       ("10011111", '1', "00000000"), -- load r1 -1
       ("10100111", '0', "00000000"),
       ("10100111", '1', "00000001"), -- load r2 7
       ("10111000", '0', "00000001"),
       ("10111000", '1', "11111111"), -- load r3 -8 
       ("11100000", '0', "11111111"),
       ("11100000", '1', "00000111"), -- print r0 (1)
       ("11101000", '0', "00000111"),
       ("11101000", '1', "00000111"), -- print r1 (-1)
       ("11110000", '0', "00000111"), 
       ("11110000", '1', "00000001"), -- print r2 (7)
       ("11111000", '0', "00000001"), 
       ("11111000", '1', "11111111"), -- print r3 (-8)
       ("00101000", '0', "11111111"),
       ("00101000", '1', "00000111"), -- sub r2 r1 r2 (-1--7=6)
       ("11110000", '0', "00000111"),
       ("11110000", '1', "11111000"), -- print r2 (6)
       ("00100010", '0', "11111000"), 
       ("00100010", '1', "00000110"), -- sub r2 r0 r2 (1-6=-5)
       ("11110000", '0', "00000110"),
       ("11110000", '1', "00000110"), -- print r2 (-5)
       ("00101101", '0', "00000110"),
       ("00101101", '1', "11111011"), -- sub r2 r3 r1 (-8--1=-7)
       ("11110000", '0', "11111011"),
       ("11110000", '1', "11111011"), -- print r2 (-7)
       ("00100110", '0', "11111011"),
       ("00100110", '1', "11111001"), -- sub r2 r1 r2 (-1--7=6)
       ("11110000", '0', "11111001"),
       ("11110000", '1', "11111001"), -- print r2 (6)
       ("00101001", '0', "11111001"),
       ("00101001", '1', "00000110"), -- sub r2 r2 r1 (6--1=7)
       ("11110000", '0', "00000110"),
       ("11110000", '1', "00000110"), -- print r2 (7)
       ("00101110", '0', "00000110"),
       ("00101110", '1', "00000111"), -- sub r2 r3 r2 (-8-7=-15)
       ("11110000", '0', "00000111"),
       ("11110000", '1', "00000111"), -- print r2 (-15)
       ("00110010", '0', "00000111"), 
       ("00110010", '1', "11110001"), -- sub r3 r0 r2 (1--15=16)
       ("11111000", '0', "11110001"),
       ("11111000", '1', "11110001"), -- print r3 (16)
       ("00101011", '0', "11110001"),
       ("00101011", '1', "00010000"), -- sub r2 r2 r3 (-15-16=-31)
       ("11110000", '0', "00010000"),
       ("11110000", '1', "00010000"), -- print r2 (-31)
       ("00111110", '0', "00010000"),
       ("00111110", '1', "11100001"), -- sub r3 r3 r2 (16--31=47)
       ("11111000", '0', "11100001"),
       ("11111000", '1', "11100001"), -- print r3 (47)
       ("00101011", '0', "11100001"),
       ("00101011", '1', "00101111"), -- sub r2 r2 r3 (-31-47=-78)
       ("11110000", '0', "00101111"),
       ("11110000", '1', "00101111"), -- print r2 (-78)
       ("00111110", '0', "00101111"),
       ("00111110", '1', "10110010"), -- sub r3 r3 r2 (47--78=125)
       ("11111000", '0', "10110010"),
       ("11111000", '1', "10110010"), -- print r3 (125)
       ("00001011", '0', "10110010"), 
       ("00001011", '1', "01111101"), -- sub r0 r2 r3 (-78-125=-203=53) UNDERFLOW
       ("11100000", '0', "01111101"),
       ("11100000", '1', "01111101"), -- print r0 (53)
       ("00011110", '0', "01111101"),
       ("00011110", '1', "11001011"), -- sub r1 r3 r2 (125--78=203=-53) OVERFLOW
       ("11101000", '0', "11001011"),
       ("11101000", '1', "11001011"), -- print r1 (-53)	("111000001", '0', "11001011"),
       ("11100001", '1', "11001011"),
       ("11100001", '0', "11001011"),
       ("11100001", '1', "11001011")

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
