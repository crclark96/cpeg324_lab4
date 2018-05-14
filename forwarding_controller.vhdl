-------------------------------------------------------------------------------
-- Title      : forwarding_controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : forwarding_controller.vhdl
-- Author     : Collin Clark  <collinclark@wifi-roaming-128-4-61-116.host.udel.edu>
-- Company    : 
-- Created    : 2018-05-12
-- Last update: 2018-05-14
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-05-12  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity forwarding_controller is

  port (I                : in  std_logic_vector(7 downto 0);
        clk              : in  std_logic;
        v1_mux           : out std_logic_vector(1 downto 0);
        v2_mux           : out std_logic_vector(1 downto 0)
        );

end entity forwarding_controller;

-------------------------------------------------------------------------------

architecture str of forwarding_controller is

  component comparator_2_bit
    port(a : in  std_logic_vector(1 downto 0);
         b : in  std_logic_vector(1 downto 0);
         s : out std_logic
         );
  end component;

  component intermediate_reg is
    generic(N : integer);
    port(input  : in  std_logic_vector(N downto 0);
         clk    :     std_logic;
         output : out std_logic_vector(N downto 0)
         );
  end component;

  component mux_2_1 is
    generic(N : integer);
    port(in0    : in  std_logic_vector(N downto 0);
         in1    : in  std_logic_vector(N downto 0);
         switch : in  std_logic;
         output : out std_logic_vector(N downto 0)
         );
  end component;


  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal I2_ex, I1_ex, I2_wb                  : std_logic_vector(7 downto 0);
  signal I1_r1, I1_r2                         : std_logic_vector(1 downto 0);
  signal wb_out, ex_out_0, ex_out_1, ex_out_2 : std_logic;
  signal do_forwarding, same_r1, same_r2, load_not_add_sub : std_logic;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  inter_reg0 : intermediate_reg generic map(N => 7)
    port map(input  => I,
             clk    => clk,
             output => I2_ex
             );

  inter_reg1 : intermediate_reg generic map(N => 15)
    port map(input(15 downto 8)  => I,
             input(7 downto 0)   => I2_ex,
             clk                 => clk,
             output(15 downto 8) => I1_ex,
             output(7 downto 0)  => I2_wb
             );

  comp0 : comparator_2_bit port map(a => I2_wb(5 downto 4),
                                    b => I1_r1,
                                    s => same_r1
                                    );

  comp1 : comparator_2_bit port map(a => I2_wb(5 downto 4),
                                    b => I1_r2,
                                    s => same_r2
                                    );

  mux0 : mux_2_1 generic map(N => 1)
    port map(in0    => I1_ex(3 downto 2),
             in1    => I1_ex(4 downto 3),
             switch => I1_ex(7),
             output => I1_r1
             );

  mux1 : mux_2_1 generic map(N => 1)
    port map(in0    => I1_ex(1 downto 0),
             in1    => I1_ex(2 downto 1),
             switch => I1_ex(7),
             output => I1_r2
             );

  wb_out           <= I2_wb(7) nand I2_wb(6);
  ex_out_0         <= I1_ex(7) and not I1_ex(6);
  ex_out_1         <= I1_ex(7) and I1_ex(6) and I1_ex(5) and I1_ex(0);
  ex_out_2         <= ex_out_0 nor ex_out_1;
  do_forwarding    <= wb_out and ex_out_2;
  load_not_add_sub <= I2_wb(7);

  v1_mux(1) <= do_forwarding and load_not_add_sub and same_r1;
  v1_mux(0) <= do_forwarding and (not load_not_add_sub) and same_r1;

  v2_mux(1) <= do_forwarding and load_not_add_sub and same_r2;
  v2_mux(0) <= do_forwarding and (not load_not_add_sub) and same_r2;
  

end architecture str;

-------------------------------------------------------------------------------
