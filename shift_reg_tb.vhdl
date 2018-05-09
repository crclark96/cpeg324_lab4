library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_tb is
end shift_reg_tb;

architecture behav of shift_reg_tb is
--  Declaration of the component that will be instantiated.
  component shift_reg
    port (I          : in  std_logic_vector (3 downto 0);
          I_SHIFT_IN : in  std_logic;
          sel        : in  std_logic_vector(1 downto 0);  -- 00:hold; 01: shift left; 10: shift right; 11: load
          clock      : in  std_logic;
          enable     : in  std_logic;
          O          : out std_logic_vector(3 downto 0)
          );
  end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
  signal i, o                    : std_logic_vector(3 downto 0);
  signal i_shift_in, clk, enable : std_logic;
  signal sel                     : std_logic_vector(1 downto 0);
begin
--  Component instantiation.
  shift_reg_0 : shift_reg port map (I => i,
                                    I_SHIFT_IN => i_shift_in,
                                    sel => sel,
                                    clock => clk,
                                    enable => enable,
                                    O => o);

--  This process does the real job.
  process
    type pattern_type is record
--  The inputs of the shift_reg.
      i                         : std_logic_vector (3 downto 0);
      i_shift_in, clock, enable : std_logic;
      sel                       : std_logic_vector(1 downto 0);
--  The expected outputs of the shift_reg.
      o                         : std_logic_vector (3 downto 0);
    end record;
--  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("0010",'0','0','1',"11","UUUU"), --0ns
       ("0010",'0','1','1',"11","0010"), --loads '0010' when clock rises and enable = '1'
       ("0010",'0','0','0',"11","0010"), --enable off
       ("0010",'0','1','0',"11","0010"), --enable off
       ("0010",'0','0','0',"01","0010"), --enable off
       ("0010",'0','1','0',"01","0010"), --5ns enable off
       ("0010",'0','0','1',"01","0010"), --outputs loaded value '0010'
       ("0010",'0','1','1',"01","0100"), --successfully shifts left and fills in '0'
       ("0010",'1','0','0',"01","0100"), --enable off
       ("0010",'1','1','0',"01","0100"), --enable off
       ("0010",'1','0','1',"01","0100"), --10 ns outputs the loaded value '0100'	
       ("0010",'1','1','1',"01","1001"), --successfully shift left and fills in '1'
       ("0010",'0','0','0',"10","1001"), --outputs the shift result '1001'
       ("0010",'0','1','0',"10","1001"), --enable off
       ("0010",'0','0','1',"10","1001"), --outputs the loaded value '1001'
       ("0010",'0','1','1',"10","0100"), --15 ns successfully shifts right and fills in '0'
       ("0010",'1','0','0',"10","0100"), --enable off
       ("0010",'1','1','0',"10","0100"), --enable off	
       ("0010",'1','0','1',"10","0100"), --outputs the loaded value '0100'
       ("0010",'1','1','1',"10","1010"), --successfully shifts right and fills in '1'
       ("1101",'1','0','0',"11","1010"), -- 20 ns enable off
       ("1101",'1','1','0',"11","1010"), --enable off
       ("1101",'1','0','1',"11","1010"), --outputs the loaded value '1010'
       ("1101",'1','1','1',"11","1101"), --loads '1101' when the clock rises and enable = '1'
       ("1101",'0','0','0',"01","1101"), --enable off
       ("1101",'0','1','0',"01","1101"), --25 ns enable off
       ("1101",'0','0','1',"01","1101"), --outputs the loaded value '1101'
       ("1101",'0','1','1',"01","1010"), --successfully shifts left and fills in '0'
       ("1101",'1','0','0',"01","1010"), --enable off
       ("1101",'1','1','0',"01","1010"), --enable off
       ("1101",'1','0','1',"01","1010"), --30 ns outputs the loaded value '1010'
       ("1101",'1','1','1',"01","0101"), --successfully shifts left and fills in '1'
       ("1101",'0','0','0',"10","0101"), --enable off
       ("1101",'0','1','0',"10","0101"), --enable off
       ("1101",'0','0','1',"10","0101"), --outputs the loaded value '0101'
       ("1101",'0','1','1',"10","0010"), --35 ns successfully shifts right and fills in '0'
       ("1101",'1','0','0',"10","0010"), --enable off
       ("1101",'1','1','0',"10","0010"), --enable off
       ("1101",'1','0','1',"10","0010"), --outputs the loaded value '0010'
       ("1101",'1','1','1',"10","1001")  --successfully shifts right and fills in '1'
       );
  begin
--  Check each pattern.
    for n in patterns'range loop
--  Set the inputs.
      i          <= patterns(n).i;
      i_shift_in <= patterns(n).i_shift_in;
      sel        <= patterns(n).sel;
      clk        <= patterns(n).clock;
      enable     <= patterns(n).enable;
--  Wait for the results.
      wait for 1 ns;
--  Check the outputs.
      assert o = patterns(n).o
        report "bad output value" severity error; 
    end loop;
    assert false report "end of test" severity note;
--  Wait forever; this will finish the simulation.
    wait;
  end process;
end behav;
