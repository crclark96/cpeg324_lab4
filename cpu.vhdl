-------------------------------------------------------------------------------
-- Title      : cpu
-- Project    : 
-------------------------------------------------------------------------------
-- File       : cpu.vhdl
-- Author     : Collin Clark  <collinclark@Collins-MacBook-Pro.local>
-- Company    : 
-- Created    : 2018-04-24
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
         enable_write  : out std_logic;
         mux_in        : out std_logic;
         add_sub       : out std_logic;
         enable_output : out std_logic;
         load          : out std_logic;
         offset        : out std_logic;
         compare       : out std_logic
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

  component adder_8_bit
    port(a     : in  std_logic_vector(7 downto 0);
         b     : in  std_logic_vector(7 downto 0);
         sub   : in  std_logic;
         s     : out std_logic_vector(7 downto 0);
         over  : out std_logic;
         under : out std_logic
         );
  end component;


  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal mux_in, load, add_sub, enable_write, offset,
    enable_output, skip, compare : std_logic;

  signal r1, r2, d, r1_alu, r2_alu, r1_dsp, r2_dsp : std_logic_vector(1 downto 0);

  signal w, v1, v2, imm_8, alu_out : std_logic_vector(7 downto 0);

  signal reg_en, skip_en, print_en : std_logic;

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
                                    compare       => compare
                                    );

  reg_file0 : reg_file port map(r1     => r1,
                                r2     => r2,
                                d      => d,
                                w      => w,
                                clk    => clk,
                                enable => reg_en,
                                v1     => v1,
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

  print_module0 : print_module port map(input  => v1,
                                        enable => print_en,
                                        clk    => clk,
                                        output => O
                                        );

  mux_0 : mux_2_1 generic map(N => 1)
    port map(in0    => r1_alu,
             in1    => r1_dsp,
             switch => mux_in,
             output => r1
             );

  mux_1 : mux_2_1 generic map(N => 1)
    port map(in0    => r2_alu,
             in1    => r2_dsp,
             switch => mux_in,
             output => r2
             );

  mux_2 : mux_2_1 generic map(N => 7)
    port map(in0    => alu_out,
             in1    => imm_8,
             switch => load,
             output => w
             );

  alu0 : adder_8_bit port map(a   => v1,
                              b   => v2,
                              sub => add_sub,
                              s   => alu_out
                              );

  mux_3 : mux_2_1 generic map(N => 3)
    port map(in0    => "0001",
             in1    => "0010",
             switch => offset,
             output => skip_amount
             );

  reg_en <= enable_write and not skip;
  skip_en <= (not(alu_out(7) or
                  alu_out(6) or
                  alu_out(5) or
                  alu_out(4) or
                  alu_out(3) or
                  alu_out(2) or
                  alu_out(1) or
                  alu_out(0)) and compare) and not skip;

  print_en <= enable_output and not skip;

  imm_4 <= I(3 downto 0);

  r1_alu <= I(3 downto 2);
  r2_alu <= I(1 downto 0);

  r1_dsp <= I(4 downto 3);
  r2_dsp <= I(2 downto 1);

  d <= I(5 downto 4);
  
end architecture str;

-------------------------------------------------------------------------------
