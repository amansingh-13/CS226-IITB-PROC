library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Memory is
	port 
	(
		clock         : in std_logic;
		data          : in std_logic_vector (15 downto 0);
		write_address : in std_logic_vector(15 downto 0);
		read_address  : in std_logic_vector(15 downto 0);
		we            : in std_logic;
		q             : out std_logic_vector (15 downto 0)
	);
end Memory;
architecture rtl of Memory is
	type mem is array(0 to 256) of std_logic_vector(15 downto 0);
	signal ram_block : mem;
begin
	process (clock, we, ram_block)
	begin
		if (falling_edge(clock) and we = '1') then
			ram_block(to_integer(unsigned(write_address))) <= data;
		end if;
		q <= ram_block(to_integer(unsigned(read_address)));
	end process;
end rtl;