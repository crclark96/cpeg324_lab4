-------------------------------------------------------------------------------
-- Title      : instruction_skip
-- Project    : 
-------------------------------------------------------------------------------
-- File       : instruction_skip.vhdl
-- Author     : Collin Clark  <collinclark@Collins-MacBook-Pro.local>
-- Company    : 
-- Created    : 2018-04-22
-- Last update: 2018-04-24
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-04-22  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity instruction_skip is

  port (
    skip_amount : in  std_logic_vector(3 downto 0);
    skip_enable : in  std_logic;
    clk         : in  std_logic;
    skip        : out std_logic
    );

end entity instruction_skip;

-------------------------------------------------------------------------------

architecture str of instruction_skip is

  component shift_reg
    port(I          : in  std_logic_vector (3 downto 0);
         I_SHIFT_IN : in  std_logic;
         sel        : in  std_logic_vector(1 downto 0);  -- 00:hold; 01: shift left; 10: shift right; 11: load
         clock      : in  std_logic;  -- positive level triggering in problem 3
         enable     : in  std_logic;  -- 0: don't do anything; 1: shift_reg is enabled
         O          : out std_logic_vector(3 downto 0)
         );
  end component;

  signal reg_value : std_logic_vector(3 downto 0);

begin  -- architecture str

  shift_reg0 : shift_reg port map(I          => skip_amount,
                                  I_SHIFT_IN => '0',
                                  sel(1)     => '1',
                                  sel(0)     => skip_enable,
                                  clock      => clk,
                                  enable     => '1',
                                  O          => reg_value);

  process(reg_value) is
  begin
    if((reg_value(0) or reg_value(1) or reg_value(2) or reg_value(3)) = 'U') then
      skip <= '0';
    else
      skip <= reg_value(0) or reg_value(1) or reg_value(2) or reg_value(3);
    end if;
  end process;

end architecture str;

-------------------------------------------------------------------------------
