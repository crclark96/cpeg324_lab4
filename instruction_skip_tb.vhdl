library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity instruction_skip_tb is
end instruction_skip_tb;

architecture behavioral of instruction_skip_tb is
-- Declaration of the component to be instantiated
  component instruction_skip
    port(skip_amount : in std_logic_vector(3 downto 0);
         skip_enable : in std_logic;
         clk : in std_logic;
         skip : out std_logic
         );
  end component;
-- Specifies which entity is bound with the component
  signal skip_amount_sig                 : std_logic_vector(3 downto 0);
  signal skip_enable_sig,clk_sig                 : std_logic;
  signal skip_sig : std_logic;
begin
-- Component instantiation
  instruction_skip0 : instruction_skip port map(skip_amount => skip_amount_sig,
                                                skip_enable => skip_enable_sig,
                                                clk => clk_sig,
                                                skip => skip_sig);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the controller
      skip_amount_sig : std_logic_vector(3 downto 0);
      skip_enable_sig,clk_sig : std_logic;
-- Expected outputs of controller
      skip_sig : std_logic;
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0001", '0', '0', '0'), -- nothing
       ("0001", '0', '1', '0'), -- clk on but skip not enable
       ("0001", '1', '0', '0'), -- clk off
       ("0001", '1', '1', '1'), -- clk on and skipping
       ("0010", '0', '0', '1'), -- still skipping
       ("0010", '0', '1', '0'), -- not skipping
       ("0010", '1', '0', '0'), --
       ("0010", '1', '1', '1'), -- skip 2
       ("0010", '0', '0', '1'), -- skipping
       ("0010", '0', '1', '1'), -- skipping
       ("0010", '0', '0', '1'), -- skipping
       ("0010", '0', '1', '0') -- done skipping
     );

  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      skip_amount_sig <= patterns(n).skip_amount_sig;
      skip_enable_sig <= patterns(n).skip_enable_sig;
      clk_sig <= patterns(n).clk_sig;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert skip_sig = patterns(n).skip_sig
        report "bad output value skip_sig" severity error;
    end loop;
      assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


