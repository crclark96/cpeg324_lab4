library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity intermediate_reg_tb is
end intermediate_reg_tb;

architecture behavioral of intermediate_reg_tb is
-- Declaration of the component to be instantiated
  component intermediate_reg
    generic(N : integer := 3);
    port(input : in std_logic_vector(N downto 0);
         clk    : in std_logic;
         output : out std_logic_vector(N downto 0)
         );
  end component;
-- Specifies which entity is bound with the component
  signal input : std_logic_vector(3 downto 0);
  signal output : std_logic_vector(3 downto 0);
  signal clk : std_logic;
begin
-- Component instantiation
  inter_reg : intermediate_reg port map(input => input,
                                        output => output,
                                        clk => clk);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the sign_extend
      input : std_logic_vector(3 downto 0);
      clk : std_logic;
-- Expected outputs of adder
      output   : std_logic_vector(3 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0001",'0',"UUUU"),
       ("0001",'1',"0001"),
       ("0010",'0',"0001"),
       ("0010",'1',"0010"),
       ("0011",'0',"0010"),
       ("0011",'1',"0011"));
       
  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      input <= patterns(n).input;
      clk <= patterns(n).clk;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert output = patterns(n).output
        report "bad output value" severity error;
    end loop;
    assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;
