library ieee;
use ieee.std_logic_1164.all;


entity full_adder is
	
	port(	a: in std_logic;
		b: in std_logic;
		cin: in std_logic;
		sum: out std_logic;
		cout: out std_logic
	);

end entity full_adder;

architecture behav of full_adder is

	signal t0, t1, t2: std_logic;

begin

	t0 <= a xor b;
	t1 <= t0 and cin;
	t2 <= a and b;
	sum <= t0 xor cin;
	cout <= t1 or t2;

end behav;
	
