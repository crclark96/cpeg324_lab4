-------------------------------------------------------------------------------
-- Title      : print_module
-- Project    : 
-------------------------------------------------------------------------------
-- File       : print_module.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-159-135.host.udel.edu>
-- Company    : 
-- Created    : 2018-04-09
-- Last update: 2018-05-15
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-04-09  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity print_module is

  port (
    input  : in  std_logic_vector(7 downto 0);
    enable : in  std_logic;
    nop    : in  std_logic;
    clk    : in  std_logic;
    output : out std_logic_vector(7 downto 0)
    );

end entity print_module;

-------------------------------------------------------------------------------

architecture str of print_module is

  component intermediate_reg
    generic(N : integer);
    port(input  : in  std_logic_vector(N downto 0);
         clk    : in  std_logic;
         output : out std_logic_vector(N downto 0)
         );
  end component;

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal num     : integer := 0;
  signal nop_sig : std_logic;
begin  -- architecture str

  inter_reg0 : intermediate_reg generic map(N => 1)
    port map(input(1)  => nop,
             input(0) => '0',
             clk    => clk,
             output(1) => nop_sig
             );

  num <= to_integer(signed(input));

  process (clk)
  begin
    if rising_edge(clk) then
      if (enable = '1') then
        if (nop_sig = '1') then
          report "nop";
          output <= "00000000";
        else
          report "value: " & integer'image(num);
          output <= input;
        end if;
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
