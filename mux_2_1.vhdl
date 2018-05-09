-------------------------------------------------------------------------------
-- Title      : mux_2_1
-- Project    : 
-------------------------------------------------------------------------------
-- File       : mux_2_1.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-155-167.host.udel.edu>
-- Company    : 
-- Created    : 2018-03-11
-- Last update: 2018-04-25
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

entity mux_2_1 is

  generic (N : integer
           );

  port (in0    : in  std_logic_vector(N downto 0);
        in1    : in  std_logic_vector(N downto 0);
        switch : in  std_logic;
        output : out std_logic_vector(N downto 0)
        );

end entity mux_2_1;

-------------------------------------------------------------------------------

architecture str of mux_2_1 is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  process (switch, in0, in1)
  begin
    case switch is
      when '0'   => output <= in0;
      when '1'   => output <= in1;
      when others => output <= in0;
    end case;
  end process;
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
