library ieee;
use ieee.std_logic_1164.all;


entity sign_extend is
	
	port(	imm_4: in std_logic_vector (3 downto 0);
		imm_8: out std_logic_vector (7 downto 0)
	);

end entity sign_extend;

architecture behav of sign_extend is

begin

	process (imm_4) is
	begin
          imm_8(0) <= imm_4(0);
          imm_8(1) <= imm_4(1);
          imm_8(2) <= imm_4(2);

          for i in 3 to 7 loop
            imm_8(i) <= imm_4(3);
          end loop;
	end process;


end behav;
	
