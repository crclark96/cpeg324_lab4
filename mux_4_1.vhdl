-------------------------------------------------------------------------------
-- Title      : mux_4_1
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mux_4_1.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-155-167.host.udel.edu>
-- Company    : 
-- Created    : 2018-03-11
-- Last update: 2018-03-16
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-11  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity mux_4_1 is

  generic (N : integer
           );

  port (in0    : in  std_logic_vector(N downto 0);
        in1    : in  std_logic_vector(N downto 0);
        in2    : in  std_logic_vector(N downto 0);
        in3    : in  std_logic_vector(N downto 0);
        switch : in  std_logic_vector(1 downto 0);
        output : out std_logic_vector(N downto 0)
        );

end entity mux_4_1;

-------------------------------------------------------------------------------

architecture str of mux_4_1 is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  process (switch, in0, in1, in2, in3)
  begin
    case switch is
      when "00"   => output <= in0;
      when "01"   => output <= in1;
      when "10"   => output <= in2;
      when "11"   => output <= in3;
      when others => output <= in0;
    end case;
  end process;
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
