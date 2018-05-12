library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity forwarding_controller_tb is
end forwarding_controller_tb;

architecture behavioral of forwarding_controller_tb is
-- Declaration of the component to be instantiated
  component forwarding_controller
    port(I : in std_logic_vector(7 downto 0);
         clk : in std_logic;
         do_forwarding : out std_logic;
         same_r1 : out std_logic;
         same_r2 : out std_logic;
         load_not_add_sub : out std_logic
         );
  end component;
-- Specifies which entity is bound with the component
  signal I : std_logic_vector(7 downto 0);
  signal clk, do_forwarding, same_r1, same_r2, load_not_add_sub : std_logic;
begin
-- Component instantiation
  fc0 : forwarding_controller port map(I => I,
                                       clk => clk,
                                       do_forwarding => do_forwarding,
                                       same_r1 => same_r1,
                                       same_r2 => same_r2,
                                       load_not_add_sub => load_not_add_sub
                                       );
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the demux
      I : std_logic_vector(7 downto 0);
      clk : std_logic;
-- Expected outputs of mux      
      do_forwarding : std_logic;
      same_r1 : std_logic;
      same_r2 : std_logic;
      load_not_add_sub : std_logic;
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("10000001", '0', 'U', 'U', 'U', 'U'),
       ("10000001", '1', 'U', 'U', 'U', 'U'),
       ("10010001", '0', 'U', 'U', 'U', 'U'),
       ("10010001", '1', 'U', 'U', 'U', 'U'),
       ("10101111", '0', 'U', 'U', 'U', 'U'),
       ("10101111", '1', 'U', 'U', 'U', 'U'),
       ("10111111", '0', '0', '0', '0', '1'),
       ("10111111", '1', '0', '0', '0', '1'),
       ("10000011", '0', '0', '0', '0', '1'),
       ("10000011", '1', '0', '0', '0', '1'),
       ("01010000", '0', '0', '0', '0', '1'),
       ("01010000", '1', '0', '0', '0', '1'),
       ("10000100", '0', '1', '1', '1', '0'),
       ("10000100", '1', '1', '1', '1', '0'),
       ("00100100", '0', '0', '0', '0', '1'),
       ("00100100", '1', '0', '0', '0', '1'),
       ("10000101", '0', '1', '0', '1', '0'),
       ("10000101", '1', '1', '0', '1', '0'),
       ("11100000", '0', '0', '0', '0', '1'),
       ("11100000", '1', '0', '0', '0', '1'),
       ("10000110", '0', '1', '1', '1', '0'),
       ("10000110", '1', '1', '1', '1', '0'),
       ("11000011", '0', '0', '0', '0', '1'),
       ("11000011", '1', '0', '0', '0', '1'),
       ("11110000", '0', '1', '1', '0', '0'),
       ("11110000", '1', '1', '1', '0', '0'),
       ("01000101", '0', '0', '0', '0', '0'),
       ("01000101", '1', '0', '0', '0', '0'),
       ("01100000", '0', '0', '0', '0', '0'),
       ("01100000", '1', '0', '0', '0', '0'),
       ("01001111", '0', '1', '1', '1', '0'),
       ("01001111", '1', '1', '1', '1', '0'),
       ("00111000", '0', '0', '0', '0', '0'),
       ("00111000", '1', '0', '0', '0', '0'),
       ("01000101", '0', '1', '0', '1', '0'),
       ("01000101", '1', '1', '0', '1', '0'),
       ("11100000", '0', '1', '0', '0', '0'),
       ("11100000", '1', '1', '0', '0', '0'),
       ("01111001", '0', '1', '1', '1', '0'),
       ("01111001", '1', '1', '1', '1', '0'),
       ("01001001", '0', '0', '1', '0', '0'),
       ("01001001", '1', '0', '1', '0', '0'),
       ("11000111", '0', '1', '0', '0', '0'),
       ("11000111", '1', '1', '0', '0', '0'),
       ("11100000", '0', '1', '1', '0', '0'),
       ("11100000", '1', '1', '1', '0', '0'),
       ("00000111", '0', '0', '0', '0', '0'),
       ("00000111", '1', '0', '0', '0', '0'),
       ("01100000", '0', '0', '1', '0', '0'),
       ("01100000", '1', '0', '1', '0', '0'),
       ("00001101", '0', '1', '1', '1', '0'),
       ("00001101", '1', '1', '1', '1', '0'),
       ("00101100", '0', '1', '0', '0', '0'),
       ("00101100", '1', '1', '0', '0', '0'),
       ("00000101", '0', '1', '0', '1', '0'),
       ("00000101", '1', '1', '0', '1', '0'),
       ("11100000", '0', '1', '0', '0', '0'),
       ("11100000", '1', '1', '0', '0', '0'),
       ("00000111", '0', '1', '1', '1', '0'),
       ("00000111", '1', '1', '1', '1', '0'),
       ("00100111", '0', '0', '0', '0', '0'),
       ("00100111", '1', '0', '0', '0', '0'),
       ("11000101", '0', '1', '0', '0', '0'),
       ("11000101", '1', '1', '0', '0', '0'),
       ("11100000", '0', '1', '0', '1', '0'),
       ("11100000", '1', '1', '0', '1', '0'),
       ("11100001", '0', '0', '0', '0', '0'),
       ("11100001", '1', '0', '0', '0', '0')
       );
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      I <= patterns(n).I;
      clk <= patterns(n).clk;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert do_forwarding = patterns(n).do_forwarding
        report "bad output value do_forwarding" severity error;
      assert same_r1 = patterns(n).same_r1
        report "bad output value same_r1" severity error;
      assert same_r2 = patterns(n).same_r2
        report "bad output value same_r2" severity error;
      assert load_not_add_sub = patterns(n).load_not_add_sub
        report "bad output value load_not_add_sub" severity error;
    end loop;
      assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


