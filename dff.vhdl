-------------------------------------------------------------------------------
-- Title      : dff
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dff.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-155-167.host.udel.edu>
-- Company    : 
-- Created    : 2018-03-12
-- Last update: 2018-03-12
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-12  1.0      collinclark     Created
-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity dff is
  port
    (
      clk : in std_logic;               -- clock

      rst : in std_logic;               -- reset
      pre : in std_logic;               -- preload
      ce  : in std_logic;               -- (clk) enable

      d : in std_logic;                 -- value

      q : out std_logic                 -- output
      );
end entity dff;

architecture Behavioral of dff is
begin
  process (clk) is
  begin
    if rising_edge(clk) then
      if (rst = '1') then
        q <= '0';
      elsif (pre = '1') then
        q <= '1';
      elsif (ce = '1') then
        q <= d;
      end if;
    end if;
  end process;
end architecture Behavioral;

