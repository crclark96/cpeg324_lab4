library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity comparator_2_bit_tb is
end comparator_2_bit_tb;

architecture behavioral of comparator_2_bit_tb is
-- Declaration of the component to be instantiated
  component comparator_2_bit
    port(a : in std_logic_vector(1 downto 0);
         b : in std_logic_vector(1 downto 0);
         s : out std_logic
         );
  end component;
-- Specifies which entity is bound with the component
  signal a,b : std_logic_vector(1 downto 0);
  signal s : std_logic;
begin
-- Component instantiation
  c0 : comparator_2_bit port map(a => a,
                                 b => b,
                                 s => s
                                 );
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the demux
      a : std_logic_vector(1 downto 0);
      b : std_logic_vector(1 downto 0);
-- Expected outputs of mux      
      s : std_logic;
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00", "00", '1'),
       ("00", "01", '0'),
       ("00", "10", '0'),
       ("00", "11", '0'),
       ("01", "00", '0'),
       ("01", "01", '1'),
       ("01", "10", '0'),
       ("01", "11", '0'),
       ("10", "00", '0'),
       ("10", "01", '0'),
       ("10", "10", '1'),
       ("10", "11", '0'),
       ("11", "00", '0'),
       ("11", "01", '0'),
       ("11", "10", '0'),
       ("11", "11", '1'));
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      a <= patterns(n).a;
      b <= patterns(n).b;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert s = patterns(n).s
        report "bad output value" severity error;
    end loop;
      assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


