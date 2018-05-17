library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity demux_1_4_tb is
end demux_1_4_tb;

architecture behavioral of demux_1_4_tb is
-- Declaration of the component to be instantiated
  component demux_1_4
    generic(N : integer := 7
            );
    port(out0    : out   std_logic_vector (N downto 0);
         out1    : out  std_logic_vector (N downto 0);
         out2    : out  std_logic_vector (N downto 0);
         out3    : out  std_logic_vector (N downto 0);
         switch : in  std_logic_vector (1 downto 0);
         input : in std_logic_vector (N downto 0)
         );
  end component;
-- Specifies which entity is bound with the component
  signal s                 : std_logic_vector(1 downto 0);
  signal o0, o1, o2, o3, i : std_logic_vector(7 downto 0);
begin
-- Component instantiation
  demux0 : demux_1_4 port map(switch => s,
                          out0    => o0,
                          out1    => o1,
                          out2    => o2,
                          out3    => o3,
                          input => i);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the demux
      i              : std_logic_vector(7 downto 0);
      s              : std_logic_vector(1 downto 0);
-- Expected outputs of mux      
      o0, o1, o2, o3 : std_logic_vector(7 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("10101010", "00", "10101010", "00000000", "00000000", "00000000"),
       ("10101010", "01", "00000000", "10101010", "00000000", "00000000"),
       ("10101010", "10", "00000000", "00000000", "10101010", "00000000"),
       ("10101010", "11", "00000000", "00000000", "00000000", "10101010"));
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      s  <= patterns(n).s;
      i <= patterns(n).i;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert o0 = patterns(n).o0
        report "bad output value o0" severity error;
      assert o1 = patterns(n).o1
        report "bad output value o1" severity error;
      assert o2 = patterns(n).o2
        report "bad output value o2" severity error;
      assert o3 = patterns(n).o3
        report "bad output value o3" severity error;
    end loop;
      assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


