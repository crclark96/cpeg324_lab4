library ieee;
use ieee.std_logic_1164.all;

entity shift_reg is
  port(I          : in  std_logic_vector (3 downto 0);
       I_SHIFT_IN : in  std_logic;
       sel        : in  std_logic_vector(1 downto 0);  -- 00:hold; 01: shift left; 10: shift right; 11: load
       clock      : in  std_logic;  -- positive level triggering in problem 3
       enable     : in  std_logic;  -- 0: don't do anything; 1: shift_reg is enabled
       O          : out std_logic_vector(3 downto 0)
       );
end shift_reg;

architecture behav of shift_reg is
  component mux_4_1
    generic(N : integer := 3
            );
    port(in0    : in  std_logic_vector (N downto 0);
         in1    : in  std_logic_vector (N downto 0);
         in2    : in  std_logic_vector (N downto 0);
         in3    : in  std_logic_vector (N downto 0);
         switch : in  std_logic_vector (1 downto 0);
         output : out std_logic_vector (N downto 0)
         );
  end component;

  component dff
    port(clk : in  std_logic;
         rst : in  std_logic;
         pre : in  std_logic;
         ce  : in  std_logic;
         d   : in  std_logic;
         q   : out std_logic
         );
  end component;


  signal hold, l_shf, r_shf, tmp, res : std_logic_vector (3 downto 0);

begin

  l_shf(0) <= I_SHIFT_IN;
  l_shf(1) <= hold(0);
  l_shf(2) <= hold(1);
  l_shf(3) <= hold(2);

  r_shf(0) <= hold(1);
  r_shf(1) <= hold(2);
  r_shf(2) <= hold(3);
  r_shf(3) <= I_SHIFT_IN;

  process (tmp, enable) is
  begin
    for i in 0 to 3 loop
      res(i) <= enable and tmp(i);
    end loop;
  end process;

  DFFS :
  for i in 0 to 3 generate
    DFFX : dff port map
      (clock, '0', '0', enable, res(i), hold(i));
  end generate DFFS;

  mux0 : mux_4_1 port map(switch => sel,
                          in0    => hold,
                          in1    => l_shf,
                          in2    => r_shf,
                          in3    => I,
                          output => tmp);

  O <= hold;
end behav;

