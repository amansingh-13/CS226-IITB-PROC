LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity ALU is
   port(
		operation  : in  std_logic;
		inp1, inp2 : in  std_logic_vector(15 downto 0);
		outp       : out std_logic_vector(15 downto 0);
		c, z       : out std_logic
	);
end entity;

architecture arch of ALU is
	signal  big_outp : std_logic_vector(16 downto 0);
begin	
	process (operation, inp1, inp2, big_outp)
	begin
		-- addition
		if (operation = '1') then 
			 big_outp <= std_logic_vector(unsigned("0" & inp1) + unsigned("0" & inp2));
			 c    <= big_outp(16);
			 outp <= big_outp(15 downto 0);
		-- nand
		else
			 c    <= '0';
			 outp <= inp1 nand inp2;
		end if;
		
		-- set zero flag output
		if (big_outp(15 downto 0) = "0000000000000000") then
			z <= '1';
		else
			z <= '0';
		end if;
	end process;
end architecture;

