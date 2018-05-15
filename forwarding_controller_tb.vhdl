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
         v1_mux : out std_logic_vector(1 downto 0);
         v2_mux : out std_logic_vector(1 downto 0)
         );
  end component;
-- Specifies which entity is bound with the component
  signal I : std_logic_vector(7 downto 0);
  signal clk : std_logic;
  signal v1_mux, v2_mux : std_logic_vector(1 downto 0);
begin
-- Component instantiation
  fc0 : forwarding_controller port map(I => I,
                                       clk => clk,
                                       v1_mux => v1_mux,
                                       v2_mux => v2_mux
                                       );
-- This process does the real job
  process
    type pattern_type is record
-- The inputs of the demux
      I : std_logic_vector(7 downto 0);
      clk : std_logic;
-- Expected outputs of mux      
      v1_mux : std_logic_vector(1 downto 0);
      v2_mux : std_logic_vector(1 downto 0);
    end record;
-- The patterns to apply
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("10000001", '0', "UU", "UU"),  -- asm code corresponds to
                                       -- results being displayed
       ("10000001", '1', "00", "00"),  -- load $0 1     
       ("10010001", '0', "00", "00"),                   
       ("10010001", '1', "00", "00"),  -- load $1 1     
       ("10101111", '0', "00", "00"),                   
       ("10101111", '1', "00", "00"),  -- load $2 -1    
       ("10111111", '0', "00", "00"),                   
       ("10111111", '1', "00", "00"),  -- load $3 -1    
       ("10000011", '0', "00", "00"),                   
       ("10000011", '1', "00", "00"),  -- load $0 3     
       ("01010000", '0', "00", "00"),                   
       ("01010000", '1', "10", "10"),  -- add $1 $0 $0  
       ("10000100", '0', "10", "10"),                   
       ("10000100", '1', "00", "00"),  -- load $0 4     
       ("00100100", '0', "00", "00"),                   
       ("00100100", '1', "00", "10"),  -- sub $2 $1 $0  
       ("10000101", '0', "00", "10"),                   
       ("10000101", '1', "00", "00"),  -- load $0 5     
       ("11100000", '0', "00", "00"),                   
       ("11100000", '1', "10", "10"),  -- disp $0       
       ("10000110", '0', "10", "10"),                   
       ("10000110", '1', "00", "00"),  -- load $0 6     
       ("11000011", '0', "00", "00"),                   
       ("11000011", '1', "10", "00"),  -- comp $0 $1 1  
       ("11110000", '0', "10", "00"),                   
       ("11110000", '1', "00", "00"),  -- disp $2       
       ("01000101", '0', "00", "00"),                   
       ("01000101", '1', "00", "00"),  -- add $0 $1 $1  
       ("01100000", '0', "00", "00"),                   
       ("01100000", '1', "01", "01"),  -- add $2 $0 $0  
       ("01001111", '0', "01", "01"),                   
       ("01001111", '1', "00", "00"),  -- add $0 $3 $3  
       ("00111000", '0', "00", "00"),                   
       ("00111000", '1', "00", "01"),  -- sub $3 $2 $0  
       ("01000101", '0', "00", "01"),                   
       ("01000101", '1', "00", "00"),  -- add $0 $1 $1  
       ("11100000", '0', "00", "00"),                   
       ("11100000", '1', "01", "01"),  -- disp $0       
       ("01111001", '0', "01", "01"),                   
       ("01111001", '1', "00", "00"),  -- add $3 $2 $1  
       ("01001001", '0', "00", "00"),                   
       ("01001001", '1', "00", "00"),  -- add $0 $2 $1  
       ("11000111", '0', "00", "00"),                   
       ("11000111", '1', "01", "00"),  -- comp $0 $3 1  
       ("11100000", '0', "01", "00"),                   
       ("11100000", '1', "00", "00"),  -- disp $0       
       ("00000111", '0', "00", "00"),                   
       ("00000111", '1', "00", "00"),  -- sub $0 $1 $3  
       ("01100000", '0', "00", "00"),                   
       ("01100000", '1', "01", "01"),  -- add $2 $0 $0  
       ("00001101", '0', "01", "01"),                   
       ("00001101", '1', "00", "00"),  -- sub $0 $3 $1  
       ("00101100", '0', "00", "00"),                   
       ("00101100", '1', "00", "01"),  -- sub $2 $3 $0  
       ("00000101", '0', "00", "01"),                   
       ("00000101", '1', "00", "00"),  -- sub $0 $1 $1  
       ("11100000", '0', "00", "00"),                   
       ("11100000", '1', "01", "01"),  -- disp $0       
       ("00000111", '0', "01", "01"),                   
       ("00000111", '1', "00", "00"),  -- sub $0 $1 $3  
       ("00100111", '0', "00", "00"),                   
       ("00100111", '1', "00", "00"),  -- sub $2 $1 $3  
       ("11000101", '0', "00", "00"),                   
       ("11000101", '1', "00", "01"),  -- comp $0 $2 1  
       ("11100000", '0', "00", "01"),                   
       ("11100000", '1', "00", "00"),  -- disp $0       
       ("11100001", '0', "00", "00"),                   
       ("11100001", '1', "00", "00")   -- nop           
       );
    begin
-- Check each pattern    
    for n in patterns'range loop
-- Set the inputs      
      I <= patterns(n).I;
      clk <= patterns(n).clk;
-- Wait for the result      
      wait for 1 ns;
-- Check the output      
      assert v1_mux = patterns(n).v1_mux
        report "bad output value v1_mux" severity error;
      assert v2_mux = patterns(n).v2_mux
        report "bad output value v2_mux" severity error;
    end loop;
      assert false report "end of test" severity note;
-- Wait forever; this will finish the simulation
    wait;
  end process;
end behavioral;


