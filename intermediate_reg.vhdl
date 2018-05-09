-------------------------------------------------------------------------------
-- Title      : intermediate_reg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : intermediate_reg.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-154-240.host.udel.edu>
-- Company    : 
-- Created    : 2018-05-09
-- Last update: 2018-05-09
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-05-09  1.0      collinclark	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity intermediate_reg is

  generic (N : integer
    );

  port (input : in std_logic_vector(N downto 0);
        clk   : in std_logic;
        output: out std_logic_vector(N downto 0)
    );

end entity intermediate_reg;

-------------------------------------------------------------------------------

architecture str of intermediate_reg is
  component dff
    port(clk : in std_logic;
         rst : in std_logic;
         pre : in std_logic;
         ce : in std_logic;
         d : in std_logic;
         q : out std_logic
         );
    end component;
  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  DFFS :
  for i in 0 to N generate
    DFFX : dff port map(
      clk, '0', '0', '1', input(i), output(i));
  end generate DFFS;
      
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
