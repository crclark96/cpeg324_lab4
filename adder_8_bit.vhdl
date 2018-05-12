library ieee;
use ieee.std_logic_1164.all;

entity adder_8_bit is

  port(a     : in  std_logic_vector(7 downto 0);
       b     : in  std_logic_vector(7 downto 0);
       sub   : in  std_logic;
       s     : out std_logic_vector(7 downto 0);
       over  : out std_logic;
       under : out std_logic
       );

end entity adder_8_bit;

architecture behav of adder_8_bit is

  component full_adder

    port(a    : in  std_logic;
         b    : in  std_logic;
         cin  : in  std_logic;
         sum  : out std_logic;
         cout : out std_logic
         );

  end component;

  signal newb0, newb1, newb2, newb3, newb4, newb5, newb6, newb7, c1, c2, c3, c4, c5, c6, c7, c8, sig_bit : std_logic;

begin

  newb0 <= b(0) xor sub;
  newb1 <= b(1) xor sub;
  newb2 <= b(2) xor sub;
  newb3 <= b(3) xor sub;
  newb4 <= b(4) xor sub;
  newb5 <= b(5) xor sub;
  newb6 <= b(6) xor sub;
  newb7 <= b(7) xor sub;

  fa0 : full_adder port map(a    => a(0),
                            b    => newb0,
                            cin  => sub,
                            sum  => s(0),
                            cout => c1);

  fa1 : full_adder port map(a    => a(1),
                            b    => newb1,
                            cin  => c1,
                            sum  => s(1),
                            cout => c2);

  fa2 : full_adder port map(a    => a(2),
                            b    => newb2,
                            cin  => c2,
                            sum  => s(2),
                            cout => c3);

  fa3 : full_adder port map(a    => a(3),
                            b    => newb3,
                            cin  => c3,
                            sum  => s(3),
                            cout => c4);

  fa4 : full_adder port map(a    => a(4),
                            b    => newb4,
                            cin  => c4,
                            sum  => s(4),
                            cout => c5);

  fa5 : full_adder port map(a    => a(5),
                            b    => newb5,
                            cin  => c5,
                            sum  => s(5),
                            cout => c6);

  fa6 : full_adder port map(a    => a(6),
                            b    => newb6,
                            cin  => c6,
                            sum  => s(6),
                            cout => c7);

  fa7 : full_adder port map(a    => a(7),
                            b    => newb7,
                            cin  => c7,
                            sum  => sig_bit,
                            cout => c8);

  under <= (not sig_bit and c8 and a(7) and newb7);
  over  <= (not a(7) and not b(7)) and sig_bit;
  s(7)  <= sig_bit;

end behav;

