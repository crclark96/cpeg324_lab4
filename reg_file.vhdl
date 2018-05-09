-------------------------------------------------------------------------------
-- Title      : reg_file
-- Project    : 
-------------------------------------------------------------------------------
-- File       : reg_file.vhdl
-- Author     : Zach Irons
-- Company    : 
-- Created    : 2018-04-22
-- Last update: 2018-04-26
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-03-23  1.0      zirons     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity reg_file is

  port (
    r1          : in  std_logic_vector(1 downto 0);
    r2          : in  std_logic_vector(1 downto 0);
    d		: in  std_logic_vector(1 downto 0);
    w		: in std_logic_vector(7 downto 0);
    clk        : in  std_logic;
    enable     : in  std_logic;
    v1          : out std_logic_vector(7 downto 0);
    v2          : out std_logic_vector(7 downto 0)
    );

end reg_file;

-------------------------------------------------------------------------------

architecture str of reg_file is
  component shift_reg_8_bit
    port(I          : in  std_logic_vector (7 downto 0);
         I_SHIFT_IN : in  std_logic;
         sel        : in  std_logic_vector(1 downto 0);
         clk      : in  std_logic;
         enable     : in  std_logic;
         O          : out std_logic_vector(7 downto 0)
         );
  end component;

  component mux_4_1
	generic (N : integer
	);
	
	port(   in0 : in std_logic_vector (N downto 0);
		in1 : in std_logic_vector (N downto 0);
		in2 : in std_logic_vector (N downto 0);
		in3 : in std_logic_vector (N downto 0);
		switch : in std_logic_vector(1 downto 0);
		output : out std_logic_vector (N downto 0)
		);
  end component;


  component demux_1_4
	generic (N : integer
	);
	
	port(   out0 : out std_logic_vector (N downto 0);
		out1 : out std_logic_vector (N downto 0);
		out2 : out std_logic_vector (N downto 0);
		out3 : out std_logic_vector (N downto 0);
		switch : in std_logic_vector(1 downto 0);
		input : in std_logic_vector (N downto 0)
		);
  end component;

    -----------------------------------------------------------------------------
    -- Internal signal declarations
    -----------------------------------------------------------------------------

  signal w_0, w_1, w_2, w_3, v_0, v_1, v_2, v_3, v1_int, v2_int: std_logic_vector(7 downto 0);
  signal sel0, sel1, sel2, sel3: std_logic_vector (1 downto 0);
  signal sel_in: std_logic_vector(1 downto 0);
  signal shift : std_logic;
  
begin  -- architecture str

  sel_in <= "11";
  shift <= '1';

  demux_sel: demux_1_4 generic map(
     N => 1)
		       port map( 
    out0 => sel0,
    out1 => sel1,
    out2 => sel2,
    out3 => sel3,
    switch => d,
    input => sel_in
  );

  demux_d: demux_1_4 generic map(
     N => 7)
		     port map( 
    out0 => w_0,
    out1 => w_1,
    out2 => w_2,
    out3 => w_3,
    switch => d,
    input => w
  );

  reg0: shift_reg_8_bit port map(
    I => w_0,
    sel => sel0,
    clk => clk,
    enable => enable,
    I_SHIFT_IN => shift,
    O => v_0
    );
  reg1: shift_reg_8_bit port map(
    I => w_1,
    sel => sel1,
    clk => clk,
    enable => enable,
    I_SHIFT_IN => shift,
    O => v_1
    );
  reg2: shift_reg_8_bit port map(
    I => w_2,
    sel => sel2,
    clk => clk,
    enable => enable,
    I_SHIFT_IN => shift,
    O => v_2
    );
  reg3: shift_reg_8_bit port map(
    I => w_3,
    sel => sel3,
    clk => clk,
    enable => enable,
    I_SHIFT_IN => shift,
    O => v_3
    );

  mux_v1: mux_4_1 generic map(
     N => 7)
	     port map( 
    in0 => v_0,
    in1 => v_1,
    in2 => v_2,
    in3 => v_3,
    switch => r1,
    output => v1_int
  );

  mux_v2: mux_4_1 generic map(
     N => 7)
	     port map( 
    in0 => v_0,
    in1 => v_1,
    in2 => v_2,
    in3 => v_3,
    switch => r2,
    output => v2_int
  );
process(v1_int) is
begin
	if v1_int = "UUUUUUUU" then
		v1 <= "00000000";
	else
		v1 <= v1_int;
	end if;
end process;

process(v2_int) is
begin
	if v2_int = "UUUUUUUU" then
		v2 <= "00000000";
	else
		v2 <= v2_int;
	end if;
end process;
-----------------------------------------------------------------------------
-- Component instantiations
-----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
