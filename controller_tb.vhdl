library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity controller_tb is
end controller_tb;

architecture behavioral of controller_tb is
-- Declaration of the component to be instantiated
  component controller
    port(I             : in  std_logic_vector(7 downto 0);
         enable_write  : out std_logic;
         mux_in        : out std_logic;
         add_sub       : out std_logic;
         enable_output : out std_logic;
         load          : out std_logic;
         offset        : out std_logic;
         compare       : out std_logic
         );
  end component;
-- Specifies which entity is bound with the component
  signal I_sig : std_logic_vector(7 downto 0);
  signal enable_write_sig,
    mux_in_sig,
    add_sub_sig,
    enable_output_sig,
    load_sig,
    offset_sig,
    compare  : std_logic;
begin
-- Component instantiation
  controller0 : controller port map(I             => I_sig,
                                    enable_write  => enable_write_sig,
                                    mux_in        => mux_in_sig,
                                    add_sub       => add_sub_sig,
                                    enable_output => enable_output_sig,
                                    load          => load_sig,
                                    offset        => offset_sig,
                                    compare       => compare);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the controller
      I_sig : std_logic_vector(7 downto 0);
-- Expected outputs of controller
      enable_write_sig,
        mux_in_sig,
        add_sub_sig,
        enable_output_sig,
        load_sig,
        offset_sig,
        compare  : std_logic;
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00000000", '1', '0', '1', '0', '0', '0', '0'),
       ("01000101", '1', '0', '0', '0', '0', '1', '0'),
       ("00000101", '1', '0', '1', '0', '0', '1', '0'),
       ("10110111", '1', '1', '1', '0', '1', '1', '0'),
       ("11001101", '0', '1', '1', '0', '0', '1', '1'),
       ("11111000", '0', '1', '1', '1', '0', '0', '0')
       );

  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      I_sig <= patterns(n).I_sig;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert enable_write_sig = patterns(n).enable_write_sig
        report "bad output value enable_write" severity error;
      assert mux_in_sig = patterns(n).mux_in_sig
        report "bad output value mux_in" severity error;
      assert add_sub_sig = patterns(n).add_sub_sig
        report "bad output value add_sub" severity error;
      assert enable_output_sig = patterns(n).enable_output_sig
        report "bad output value enable_output" severity error;
      assert load_sig = patterns(n).load_sig
        report "bad output value load" severity error;
      assert offset_sig = patterns(n).offset_sig
        report "bad output value" severity error;
    end loop;
    assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


