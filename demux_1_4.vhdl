-------------------------------------------------------------------------------
-- Title      : demux_1_4
-- Project    : 
-------------------------------------------------------------------------------
-- File       : demux_1_4.vhdl
-- Author     : Zach Irons
-- Company    : 
-- Created    : 2018-04-22
-- Last update: 2018-04-30
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

entity demux_1_4 is

  generic (N : integer
           );

  port (out0    : out  std_logic_vector(N downto 0);
        out1    : out  std_logic_vector(N downto 0);
        out2    : out  std_logic_vector(N downto 0);
        out3    : out  std_logic_vector(N downto 0);
        switch : in  std_logic_vector(1 downto 0);
        input : in  std_logic_vector(N downto 0)
        );

end entity demux_1_4;

-------------------------------------------------------------------------------

architecture str of demux_1_4 is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal output : std_logic_vector(N downto 0);

begin  -- architecture str

  process (switch, input)
  begin
    
    for i in N downto 0 loop
	output(i) <= '0';
    end loop;

    case switch is
      when "00"   => 
	out0 <= input;
	out1 <= output;
	out2 <= output;
	out3 <= output;
      when "01"   => 
	out0 <= output;
	out1 <= input;
	out2 <= output;
	out3 <= output;
      when "10"   => 
	out0 <= output;
	out1 <= output;
	out2 <= input;
	out3 <= output;
      when "11"   => 
	out0 <= output;
	out1 <= output;
	out2 <= output;
	out3 <= input;
      when others =>
	out0 <= output;
	out1 <= output;
	out2 <= output;
	out3 <= output;
    end case;
  end process;
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
