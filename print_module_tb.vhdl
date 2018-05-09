-------------------------------------------------------------------------------
-- Title      : print_module_tb
-- Project    : 
-------------------------------------------------------------------------------
-- File       : print_module_tb.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-153-139.host.udel.edu>
-- Company    : 
-- Created    : 2018-04-15
-- Last update: 2018-04-28
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-04-15  1.0      collinclark	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity print_module_tb is

end entity print_module_tb;

-------------------------------------------------------------------------------

architecture str of print_module_tb is
  component print_module
    port(input : in std_logic_vector (7 downto 0);
         enable: in std_logic;
         clk : in std_logic;
	 output: out std_logic_vector (7 downto 0)
         );
  end component;
  
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal en,clk : std_logic;
  signal inp : std_logic_vector (7 downto 0);
  signal output : std_logic_vector (7 downto 0);
  
begin  -- architecture str
  print_mod : print_module port map(enable => en,
                                    input => inp,
                                    clk => clk,
				    output => output);

  process
    type pattern_type is record
      inp : std_logic_vector (7 downto 0);
      en,clk : std_logic;
      output : std_logic_vector (7 downto 0);
    end record;

    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      (("00000000", '0', '0', "UUUUUUUU"),
       ("00000000", '0', '1', "00000000"),
       ("00000000", '0', '0', "00000000"),
       ("00000000", '1', '1', "00000000"),
       ("00000000", '1', '0', "00000000"),
       ("00000001", '0', '1', "00000000"),
       ("00000001", '0', '0', "00000000"),
       ("00000001", '1', '1', "00000001"),
       ("00000001", '1', '0', "00000001"),
       ("00000010", '0', '1', "00000000"),
       ("00000010", '0', '0', "00000000"),
       ("00000010", '1', '1', "00000010"),
       ("00000010", '1', '0', "00000010"),
       ("11111111", '0', '1', "00000000"),
       ("11111111", '0', '0', "00000000"),
       ("11111111", '1', '1', "11111111"),
       ("11111111", '1', '0', "11111111"),
       ("11111110", '0', '1', "00000000"),
       ("11111110", '0', '0', "00000000"),
       ("11111110", '1', '1', "11111110"),
       ("11111110", '1', '0', "11111110"));
  begin
    for n in patterns'range loop
      inp <= patterns(n).inp;
      en <= patterns(n).en;
      clk <= patterns(n).clk;
      wait for 1 ns;
      assert output = patterns(n).output
        report "bad output value" severity error;
    end loop;
    wait;
  end process;

end architecture str;

-------------------------------------------------------------------------------
