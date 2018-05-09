library ieee;
use ieee.std_logic_1164.all;

--  A testbench has no ports.
entity shift_reg_8_bit_tb is
end shift_reg_8_bit_tb;

architecture behav of shift_reg_8_bit_tb is
--  Declaration of the component that will be instantiated.
  component shift_reg_8_bit
    port (I          : in  std_logic_vector (7 downto 0);
          I_SHIFT_IN : in  std_logic;
          sel        : in  std_logic_vector(1 downto 0);  -- 00:hold; 01: shift left; 10: shift right; 11: load
          clk      : in  std_logic;
          enable     : in  std_logic;
          O          : out std_logic_vector(7 downto 0)
          );
  end component;
--  Specifies which entity is bound with the component.
-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
  signal i, o                    : std_logic_vector(7 downto 0);
  signal i_shift_in, clk, enable : std_logic;
  signal sel                     : std_logic_vector(1 downto 0);
begin
--  Component instantiation.
  shift_reg_8_bit_0 : shift_reg_8_bit port map (I => i,
                                    I_SHIFT_IN => i_shift_in,
                                    sel => sel,
                                    clk => clk,
                                    enable => enable,
                                    O => o);

--  This process does the real job.
  process
    type pattern_type is record
--  The inputs of the shift_reg.
      i                         : std_logic_vector (7 downto 0);
      i_shift_in, clock, enable : std_logic;
      sel                       : std_logic_vector(1 downto 0);
--  The expected outputs of the shift_reg.
      o                         : std_logic_vector (7 downto 0);
    end record;
--  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00000010",'0','0','1',"11","UUUUUUUU"), --0ns
       ("00000010",'0','1','1',"11","00000010"), --loads '00000010' when clock rises and enable = '1'
       ("00000010",'0','0','0',"11","00000010"), --enable off
       ("00000010",'0','1','0',"11","00000010"), --enable off
       ("00000010",'0','0','0',"01","00000010"), --enable off
       ("00000010",'0','1','0',"01","00000010"), --5ns enable off
       ("00000010",'0','0','1',"01","00000010"), --outputs loaded value '00000010'
       ("00000010",'0','1','1',"01","00000100"), --successfully shifts left and fills in '0'
       ("00000010",'1','0','0',"01","00000100"), --enable off
       ("00000010",'1','1','0',"01","00000100"), --enable off
       ("00000010",'1','0','1',"01","00000100"), --10 ns outputs the loaded value '00000100'	
       ("00000010",'1','1','1',"01","00001001"), --successfully shift left and fills in '1'
       ("00000010",'0','0','0',"10","00001001"), --outputs the shift result '00001001'
       ("00000010",'0','1','0',"10","00001001"), --enable off
       ("00000010",'0','0','1',"10","00001001"), --outputs the loaded value '00001001'
       ("00000010",'0','1','1',"10","00000100"), --15 ns successfully shifts right and fills in '0'
       ("00000010",'1','0','0',"10","00000100"), --enable off
       ("00000010",'1','1','0',"10","00000100"), --enable off	
       ("00000010",'1','0','1',"10","00000100"), --outputs the loaded value '00000100'
       ("00000010",'1','1','1',"10","10000010"), --successfully shifts right and fills in '1'
       ("00001101",'1','0','0',"11","10000010"), -- 20 ns enable off
       ("00001101",'1','1','0',"11","10000010"), --enable off
       ("00001101",'1','0','1',"11","10000010"), --outputs the loaded value '00001010'
       ("00001101",'1','1','1',"11","00001101"), --loads '00001101' when the clock rises and enable = '1'
       ("00001101",'0','0','0',"01","00001101"), --enable off
       ("00001101",'0','1','0',"01","00001101"), --25 ns enable off
       ("00001101",'0','0','1',"01","00001101"), --outputs the loaded value '00001101'
       ("00001101",'0','1','1',"01","00011010"), --successfully shifts left and fills in '0'
       ("00001101",'1','0','0',"01","00011010"), --enable off
       ("00001101",'1','1','0',"01","00011010"), --enable off
       ("00001101",'1','0','1',"01","00011010"), --30 ns outputs the loaded value '00001010'
       ("00001101",'1','1','1',"01","00110101"), --successfully shifts left and fills in '1'
       ("00001101",'0','0','0',"10","00110101"), --enable off
       ("00001101",'0','1','0',"10","00110101"), --enable off
       ("00001101",'0','0','1',"10","00110101"), --outputs the loaded value '00000101'
       ("00001101",'0','1','1',"10","00011010"), --35 ns successfully shifts right and fills in '0'
       ("00001101",'1','0','0',"10","00011010"), --enable off
       ("00001101",'1','1','0',"10","00011010"), --enable off
       ("00001101",'1','0','1',"10","00011010"), --outputs the loaded value '00000010'
       ("00001101",'1','1','1',"10","10001101")  --successfully shifts right and fills in '1'
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
