library ieee;
use ieee.std_logic_1164.all;

-- A testbench has no ports
entity controller_tb is
end controller_tb;

architecture behavioral of controller_tb is
-- Declaration of the component to be instantiated
  component controller
    port(I             : in  std_logic_vector(7 downto 0);
         clk           : in  std_logic;
         enable_write  : out std_logic_vector(2 downto 0);
         mux_in        : out std_logic_vector(2 downto 0);
         add_sub       : out std_logic_vector(2 downto 0);
         enable_output : out std_logic_vector(2 downto 0);
         load          : out std_logic_vector(2 downto 0);
         offset        : out std_logic_vector(2 downto 0);
         compare       : out std_logic_vector(2 downto 0);
         nop           : out std_logic_vector(2 downto 0);
         disp_out      : out std_logic_vector(2 downto 0)
         );
  end component;
-- Specifies which entity is bound with the component
  signal I_sig : std_logic_vector(7 downto 0);
  signal clk : std_logic;
  signal enable_write_sig,
    mux_in_sig,
    add_sub_sig,
    enable_output_sig,
    load_sig,
    offset_sig,
    compare_sig,
    nop_sig,
    disp_out_sig : std_logic_vector(2 downto 0);
begin
-- Component instantiation
  controller0 : controller port map(I             => I_sig,
                                    clk           => clk,
                                    enable_write  => enable_write_sig,
                                    mux_in        => mux_in_sig,
                                    add_sub       => add_sub_sig,
                                    enable_output => enable_output_sig,
                                    load          => load_sig,
                                    offset        => offset_sig,
                                    compare       => compare_sig,
                                    nop           => nop_sig,
                                    disp_out      => disp_out_sig);
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the controller
      I_sig : std_logic_vector(7 downto 0);
      clk : std_logic;
-- Expected outputs of controller
      enable_write_sig,
        mux_in_sig,
        add_sub_sig,
        enable_output_sig,
        load_sig,
        offset_sig,
        compare_sig,
        nop_sig,
        disp_out_sig : std_logic_vector(2 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00000000", '0', "1UU", "0UU", "1UU", "0UU", "0UU", "0UU", "0UU", "0UU", "0UU"),
       ("00000000", '1', "11U", "00U", "11U", "00U", "00U", "00U", "00U", "00U", "00U"),
       ("01000101", '0', "11U", "00U", "01U", "00U", "00U", "10U", "00U", "00U", "00U"),
       ("01000101", '1', "111", "000", "001", "000", "000", "110", "000", "000", "000"),
       ("00000101", '0', "111", "000", "101", "000", "000", "110", "000", "000", "000"),
       ("00000101", '1', "111", "000", "110", "000", "000", "111", "000", "000", "000"),
       ("10110111", '0', "111", "100", "110", "000", "100", "111", "000", "000", "100"),
       ("10110111", '1', "111", "110", "111", "000", "110", "111", "000", "000", "110"),
       ("11001101", '0', "011", "110", "111", "000", "010", "111", "100", "000", "010"),
       ("11001101", '1', "001", "111", "111", "000", "001", "111", "110", "000", "001"),
       ("11111000", '0', "001", "111", "111", "100", "001", "011", "010", "000", "101"),
       ("11111000", '1', "000", "111", "111", "110", "000", "001", "001", "000", "110")
       );

  begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      I_sig <= patterns(n).I_sig;
      clk <= patterns(n).clk;
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
        report "bad output value offset" severity error;
      assert compare_sig = patterns(n).compare_sig
        report "bad output value compare" severity error;
      assert nop_sig = patterns(n).nop_sig
        report "bad output value nop" severity error;
      assert disp_out_sig = patterns(n).disp_out_sig
        report "bad output value disp_sig" severity error;
    end loop;
    assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


