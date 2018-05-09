-------------------------------------------------------------------------------
-- Title      : controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : controller.vhdl
-- Author     : Collin Clark  <collinclark@Collins-MacBook-Pro.local>
-- Company    : 
-- Created    : 2018-04-22
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
-- 2018-04-22  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity controller is

  port (
    I             : in  std_logic_vector(7 downto 0);
    enable_write  : out std_logic;
    mux_in        : out std_logic;
    add_sub       : out std_logic;
    enable_output : out std_logic;
    load          : out std_logic;
    offset        : out std_logic;
    compare       : out std_logic
    );

end entity controller;

-------------------------------------------------------------------------------

architecture str of controller is


begin  -- architecture str

  enable_write  <= I(7) nand I(6);
  mux_in        <= I(7);
  add_sub       <= (not I(6)) or I(7);
  enable_output <= I(7) and I(6) and I(5);
  load          <= (not I(6)) and I(7);
  offset        <= I(0);
  compare       <= I(7) and I(6) and not I(5);

end architecture str;

-------------------------------------------------------------------------------
