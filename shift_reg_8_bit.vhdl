-------------------------------------------------------------------------------
-- Title      : shift_reg_8_bit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : shift_reg_8_bit.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-155-167.host.udel.edu>
-- Company    : 
-- Created    : 2018-03-23
-- Last update: 2018-03-23
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-23  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity shift_reg_8_bit is

  port (
    I          : in  std_logic_vector(7 downto 0);
    sel        : in  std_logic_vector(1 downto 0);  -- 00 hold, 01 left
    I_SHIFT_IN : in  std_logic;                     -- 10 right, 11 load
    clk        : in  std_logic;
    enable     : in  std_logic;
    O          : out std_logic_vector(7 downto 0)
    );

end entity shift_reg_8_bit;

-------------------------------------------------------------------------------

architecture str of shift_reg_8_bit is
  component shift_reg
    port(I          : in  std_logic_vector (3 downto 0);
         I_SHIFT_IN : in  std_logic;
         sel        : in  std_logic_vector(1 downto 0);
         clock      : in  std_logic;
         enable     : in  std_logic;
         O          : out std_logic_vector(3 downto 0)
         );
  end component;
  
    -----------------------------------------------------------------------------
    -- Internal signal declarations
    -----------------------------------------------------------------------------

  signal I_SHIFT_0,I_SHIFT_1 : std_logic;
  signal O_0,O_1: std_logic_vector(3 downto 0);
  
begin  -- architecture str

  process (I_SHIFT_IN, O_0, O_1) is
  begin
    if (sel(1) = '1') then
	I_SHIFT_0 <= O_1(0);
	I_SHIFT_1 <= I_SHIFT_IN;
    else
	I_SHIFT_0 <= I_SHIFT_IN;
	I_SHIFT_1 <= O_0(3);
    end if;
  end process;

  reg0: shift_reg port map(
    I => I(3 downto 0),
    sel => sel,
    clock => clk,
    enable => enable,
    I_SHIFT_IN => I_SHIFT_0,
    O => O_0
    );
  reg1: shift_reg port map(
    I => I(7 downto 4),
    sel => sel,
    clock => clk,
    enable => enable,
    I_SHIFT_IN => I_SHIFT_1,
    O => O_1
    );

  O(7 downto 4) <= O_1;
  O(3 downto 0) <= O_0;
  
-----------------------------------------------------------------------------
-- Component instantiations
-----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
