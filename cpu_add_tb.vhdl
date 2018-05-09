library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity cpu_add_tb is
end cpu_add_tb;

architecture behav of cpu_add_tb is
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
       ("11100000", '1', "00000000"), -- print reg 0
       ("11101000", '0', "00000000"),
       ("11101000", '1', "00000000"), -- print reg 1
       ("11110000", '0', "00000000"),
       ("11110000", '1', "00000000"), -- print reg 2
       ("11111000", '0', "00000000"),
       ("11111000", '1', "00000000"), -- print reg 3
       ("10000001", '0', "00000000"),
       ("10000001", '1', "00000000"), -- load r0 1
       ("10011111", '0', "00000000"), 
       ("10011111", '1', "00000000"), -- load r1 -1
       ("10100111", '0', "00000000"),
       ("10100111", '1', "00000000"), -- load r2 7
       ("10111000", '0', "00000000"),
       ("10111000", '1', "00000000"), -- load r3 -8
       ("11100000", '0', "00000000"),
       ("11100000", '1', "00000001"), -- print r0
       ("11101000", '0', "00000001"),
       ("11101000", '1', "11111111"), -- print r1
       ("11110000", '0', "11111111"),
       ("11110000", '1', "00000111"), -- print r2 
       ("11111000", '0', "00000111"),
       ("11111000", '1', "11111000"), -- print r3
       ("01000000", '0', "11111000"),
       ("01000000", '1', "00000000"), -- add r0 r0 r0 (1+1=2)
       ("11100000", '0', "00000000"),
       ("11100000", '1', "00000010"), -- print r0 (2)
       ("01000010", '0', "00000010"),
       ("01000010", '1', "00000000"), -- add r0 r0 r2 (2+7=9)
       ("11100000", '0', "00000000"),
       ("11100000", '1', "00001001"), -- print r0 (9)
       ("01100010", '0', "00001001"),
       ("01100010", '1', "00000000"), -- add r2 r0 r2 (7+9=16)
       ("11110000", '0', "00000000"),
       ("11110000", '1', "00010000"), -- print r2 (16)
       ("01001000", '0', "00010000"),
       ("01001000", '1', "00000000"), -- add r0 r2 r0 (9+16=25)
       ("11100000", '0', "00000000"),
       ("11100000", '1', "00011001"), -- print r0 (25)
       ("01100010", '0', "00011001"),
       ("01100010", '1', "00000000"), -- add r2 r0 r2 (16+25=41)
       ("11110000", '0', "00000000"),
       ("11110000", '1', "00101001"), -- print r2 (41)
       ("01001000", '0', "00101001"),
       ("01001000", '1', "00000000"), -- add r0 r2 r0 (25+41=66)
       ("11100000", '0', "00000000"),
       ("11100000", '1', "01000010"), -- print r0 (66)
       ("01100010", '0', "01000010"),
       ("01100010", '1', "00000000"), -- add r2 r0 r2 (41+66=107)
       ("11110000", '0', "00000000"),
       ("11110000", '1', "01101011"), -- print r2 (107)
       ("01001000", '0', "01101011"),
       ("01001000", '1', "00000000"), -- add r0 r2 r0 (66+107=173) OVERFLOW
       ("11100000", '0', "00000000"),
       ("11100000", '1', "10101101"), -- print r0 (173 -> -83)
       ("01110011", '0', "10101101"),
       ("01110011", '1', "00000000"), -- add r3 r0 r3 (-8+-83=-91)
       ("11111000", '0', "00000000"),
       ("11111000", '1', "10100101"), -- print r3 (-91)
       ("01001100", '0', "10100101"),
       ("01001100", '1', "00000000"), -- add r0 r3 r0 (-83+-91=-174) UNDERFLOW
       ("11100000", '0', "00000000"),
       ("11100000", '1', "01010010"), -- print r0 (-174 -> 82)
       ("01001100", '0', "01010010"),
       ("01001100", '1', "00000000"), -- add r0 r3 r0 (82+-91=-9)
       ("11100000", '0', "00000000"),
       ("11100000", '1', "11110111"), -- print r0 (-9)
       ("01001000", '0', "11110111"),
       ("01001000", '1', "00000000"), -- add r0 r2 r0 (-9+107=98)
       ("11100000", '0', "00000000"),
       ("11100000", '1', "01100010")  -- print r0 (98)
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
