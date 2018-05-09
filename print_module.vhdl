-------------------------------------------------------------------------------
-- Title      : print_module
-- Project    : 
-------------------------------------------------------------------------------
-- File       : print_module.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-159-135.host.udel.edu>
-- Company    : 
-- Created    : 2018-04-09
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
-- 2018-04-09  1.0      collinclark	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity print_module is

  port (
    input : in std_logic_vector(7 downto 0);
    enable : in std_logic;
    clk : in std_logic;
    output : out std_logic_vector(7 downto 0)
    );

end entity print_module;

-------------------------------------------------------------------------------

architecture str of print_module is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal num : integer := 0;
begin  -- architecture str

  num <= to_integer(signed(input));
  
  process (clk)
  begin
    if rising_edge(clk) then
      if (enable = '1') then
        report "value: " & integer'image(num);
        output <= input;
      else
        output <= "00000000";
      end if;
    end if;
  end process;

  
  
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
