-------------------------------------------------------------------------------
-- Title      : controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : controller.vhdl
-- Author     : Collin Clark  <collinclark@Collins-MacBook-Pro.local>
-- Company    : 
-- Created    : 2018-04-22
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
-- 2018-04-22  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity controller is

  port (
    I             : in  std_logic_vector(7 downto 0);
    clk           : in  std_logic;
    enable_write  : out std_logic_vector(2 downto 0);
    mux_in        : out std_logic_vector(2 downto 0);
    add_sub       : out std_logic_vector(2 downto 0);
    enable_output : out std_logic_vector(2 downto 0);
    load          : out std_logic_vector(2 downto 0);
    offset        : out std_logic_vector(2 downto 0);
    compare       : out std_logic_vector(2 downto 0);
    nop           : out std_logic_vector(2 downto 0)
    );

end entity controller;

-------------------------------------------------------------------------------

architecture str of controller is
  component intermediate_reg
    generic(N : integer:=7);
    port(input : in std_logic_vector(N downto 0);
         clk : in std_logic;
         output : out std_logic_vector(N downto 0)
         );
    end component;

signal    enable_write_sig  :  std_logic_vector(2 downto 0);
signal    mux_in_sig        :  std_logic_vector(2 downto 0);
signal    add_sub_sig       :  std_logic_vector(2 downto 0);
signal    enable_output_sig :  std_logic_vector(2 downto 0);
signal    load_sig          :  std_logic_vector(2 downto 0);
signal    offset_sig        :  std_logic_vector(2 downto 0);
signal    compare_sig       :  std_logic_vector(2 downto 0);
signal    nop_sig           :  std_logic_vector(2 downto 0);
  
begin  -- architecture str

  enable_write_sig(2)  <= I(7) nand I(6);
  mux_in_sig(2)        <= I(7);
  add_sub_sig(2)       <= (not I(6)) or I(7);
  enable_output_sig(2) <= I(7) and I(6) and I(5) and not I(0);
  load_sig(2)          <= (not I(6)) and I(7);
  offset_sig(2)        <= I(0);
  compare_sig(2)       <= I(7) and I(6) and not I(5);
  nop_sig(2)           <= I(7) and I(6) and I(5) and I(0);

  INT_REGS :
  for i in 1 downto 0 generate
    INT_REGX : intermediate_reg port map(
      input(0) => enable_write_sig(i+1),
      input(1) => mux_in_sig(i+1),
      input(2) => add_sub_sig(i+1),
      input(3) => enable_output_sig(i+1),
      input(4) => load_sig(i+1),
      input(5) => offset_sig(i+1),
      input(6) => compare_sig(i+1),
      input(7) => nop_sig(i+1),
      clk => clk,
      output(0) => enable_write_sig(i),
      output(1) => mux_in_sig(i),
      output(2) => add_sub_sig(i),
      output(3) => enable_output_sig(i),
      output(4) => load_sig(i),
      output(5) => offset_sig(i),
      output(6) => compare_sig(i),
      output(7) => nop_sig(i)
      );
  end generate INT_REGS;

  enable_write <= enable_write_sig;
  mux_in <= mux_in_sig;
  add_sub <= add_sub_sig;
  enable_output <= enable_output_sig;
  load <= load_sig;
  offset <= offset_sig;
  compare <= compare_sig;
  nop <= nop_sig;

  
end architecture str;

-------------------------------------------------------------------------------
