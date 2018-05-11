-------------------------------------------------------------------------------
-- Title      : cpu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cpu.vhdl
-- Author     : Collin Clark  <collinclark@Collins-MacBook-Pro.local>
-- Company    : 
-- Created    : 2018-04-24
-- Last update: 2018-05-11
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-04-24  1.0      collinclark     Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity cpu is

  port (I   : in  std_logic_vector(7 downto 0);
        clk : in  std_logic;
        O   : out std_logic_vector(7 downto 0)
        );

end entity cpu;

-------------------------------------------------------------------------------

architecture str of cpu is

  component controller
    port(I             : in  std_logic_vector(7 downto 0);
         enable_write  : out std_logic_vector(2 downto 0);
         mux_in        : out std_logic_vector(2 downto 0);
         add_sub       : out std_logic_vector(2 downto 0);
         enable_output : out std_logic_vector(2 downto 0);
         load          : out std_logic_vector(2 downto 0);
         offset        : out std_logic_vector(2 downto 0);
         compare       : out std_logic_vector(2 downto 0);
         nop           : out std_logic_vector(2 downto 0);
         disp_out      : out std_logic_vector(2 downto 0)
         );
  end component;

  component reg_file
    port(r1     : in  std_logic_vector(1 downto 0);
         r2     : in  std_logic_vector(1 downto 0);
         d      : in  std_logic_vector(1 downto 0);
         w      : in  std_logic_vector(7 downto 0);
         clk    : in  std_logic;
         enable : in  std_logic;
         v1     : out std_logic_vector(7 downto 0);
         v2     : out std_logic_vector(7 downto 0)
         );
  end component;

  component sign_extend
    port(imm_4 : in  std_logic_vector(3 downto 0);
         imm_8 : out std_logic_vector(7 downto 0)
         );
  end component;

  component instruction_skip
    port(skip_amount : in  std_logic_vector(3 downto 0);
         skip_enable : in  std_logic;
         clk         : in  std_logic;
         skip        : out std_logic
         );
  end component;

  component print_module
    port(input  : in  std_logic_vector(7 downto 0);
         enable : in  std_logic;
         clk    : in  std_logic;
         output : out std_logic_vector(7 downto 0)
         );
  end component;

  component mux_2_1
    generic(N : integer);
    port(in0    : in  std_logic_vector(N downto 0);
         in1    : in  std_logic_vector(N downto 0);
         switch : in  std_logic;
         output : out std_logic_vector(N downto 0)
         );
  end component;

  component mux_4_1
    generic(N : integer);
    port(in0    : in  std_logic_vector(N downto 0);
         in1    : in  std_logic_vector(N downto 0);
         in2    : in  std_logic_vector(N downto 0);
         in3    : in  std_logic_vector(N downto 0);
         switch : in  std_logic_vector(1 downto 0);
         output : out std_logic_vector(N downto 0)
         );
  end component;

  component adder_8_bit
    port(a     : in  std_logic_vector(7 downto 0);
         b     : in  std_logic_vector(7 downto 0);
         sub   : in  std_logic;
         s     : out std_logic_vector(7 downto 0);
         over  : out std_logic;
         under : out std_logic
         );
  end component;

  component intermediate_reg
    generic(N : integer);
    port(input  : in  std_logic_vector(N downto 0);
         clk    : in  std_logic;
         output : out std_logic_vector(N downto 0)
         );
  end component;


  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal mux_in, load, add_sub, enable_write, offset,
    enable_output, compare, nop, disp_out : std_logic_vector(2 downto 0);

  signal r1_0, r1_1, r2_0, r2_1, d_0, d_1, d_2, r1_alu, r2_alu, r1_dsp, r2_dsp : std_logic_vector(1 downto 0);

  signal w, v1_0, v1_1, v2, imm_8, alu_out_0, alu_out_1, print_in : std_logic_vector(7 downto 0);

  signal reg_en, skip_en, print_en, skip, branch, not_enable_write : std_logic;

  signal imm_4, skip_amount : std_logic_vector(3 downto 0);

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  controller0 : controller port map(I             => I,
                                    enable_write  => enable_write,
                                    mux_in        => mux_in,
                                    add_sub       => add_sub,
                                    enable_output => enable_output,
                                    load          => load,
                                    offset        => offset,
                                    compare       => compare,
                                    nop           => nop,
                                    disp_out      => disp_out
                                    );

  reg_file0 : reg_file port map(r1     => r1_1,
                                r2     => r2_1,
                                d      => d_2,
                                w      => w,
                                clk    => clk,
                                enable => reg_en,
                                v1     => v1_0,
                                v2     => v2
                                );

  sign_extend0 : sign_extend port map(imm_4 => imm_4,
                                      imm_8 => imm_8
                                      );

  instruction_skip0 : instruction_skip port map(skip_amount => skip_amount,
                                                skip_enable => skip_en,
                                                clk         => clk,
                                                skip        => skip
                                                );

  print_module0 : print_module port map(input  => print_in,
                                        enable => print_en,
                                        clk    => clk,
                                        output => O
                                        );

  mux_0 : mux_2_1 generic map(N => 1)
    port map(in0    => r1_alu,
             in1    => r1_dsp,
             switch => mux_in(2),
             output => r1_0
             );

  mux_1 : mux_2_1 generic map(N => 1)
    port map(in0    => r2_alu,
             in1    => r2_dsp,
             switch => mux_in(2),
             output => r2_0
             );

  mux_2 : mux_2_1 generic map(N => 7)
    port map(in0    => alu_out_1,
             in1    => imm_8,
             switch => load(0),
             output => w
             );

  alu0 : adder_8_bit port map(a   => v1_0,
                              b   => v2,
                              sub => add_sub(1),
                              s   => alu_out_0
                              );

  mux_3 : mux_2_1 generic map(N => 3)
    port map(in0    => "0001",
             in1    => "0010",
             switch => offset(0),
             output => skip_amount
             );

  mux_4 : mux_4_1 generic map(N => 7)
    port map(in0             => alu_out_1,
             in1(0)          => branch,
             in1(7 downto 1) => "0000000",
             in2             => imm_8,
             in3             => v1_1,
             switch(0)       => disp_out(0),
             switch(1)       => not_enable_write,
             output          => print_in
             );

  inter_reg_id_ex : intermediate_reg generic map(N => 5)
    port map(input(5 downto 4) => r1_0,
             input(3 downto 2)  => r2_0,
             input(1 downto 0)   => d_0,
             clk => clk,
             output(5 downto 4) => r1_1,
             output(3 downto 2)  => r2_1,
             output(1 downto 0)   => d_1
             );

  inter_reg_ex_wb : intermediate_reg generic map(N => 17)
    port map(input(17 downto 10) => v1_0,
             input(9 downto 2) => alu_out_0,
             input(1 downto 0) => d_1,
             clk => clk,
             output(17 downto 10) => v1_1,
             output(9 downto 2) => alu_out_1,
             output(1 downto 0) => d_2
             );

  
  not_enable_write <= not enable_write(0);

  reg_en <= enable_write(0) and nop(0) and not skip;

  branch <= (not(alu_out_1(7) or
                 alu_out_1(6) or
                 alu_out_1(5) or
                 alu_out_1(4) or
                 alu_out_1(3) or
                 alu_out_1(2) or
                 alu_out_1(1) or
                 alu_out_1(0)) and compare(0));

  skip_en <= branch and not skip;

  print_en <= not skip;

  imm_4 <= I(3 downto 0);

  r1_alu <= I(3 downto 2);
  r2_alu <= I(1 downto 0);

  r1_dsp <= I(4 downto 3);
  r2_dsp <= I(2 downto 1);

  d_0 <= I(5 downto 4);

end architecture str;

-------------------------------------------------------------------------------
