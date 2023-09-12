library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end Testbench;
architecture at of Testbench is
 
	component IITB_Proc is
		port 
		(
			clk, RST, start, writeF        : in std_logic;
			data, display_addr             : in std_logic_vector(15 downto 0);
			stop_flag                      : out std_logic;
			output_display                 : out std_logic_vector(15 downto 0);
			c, z                           : out std_logic;
			R0, R1, R2, R3, R4, R5, R6, R7 : out std_logic_vector(15 downto 0)
		);
	end component;

	signal clk, RST, start, writeF, c, z, stop_flag                   : std_logic;
	signal data, output, display_addr, R0, R1, R2, R3, R4, R5, R6, R7 : std_logic_vector(15 downto 0);
 
begin
	-- Instantiate the unit under test (UUT)
	dut_instance : IITB_Proc
	port map(clk => clk, start => start, data => data, RST => RST, R0 => R0, R1 => R1, R2 => R2, R3 => R3, R4 => R4, R5 => R5, R6 => R6, R7 => R7, c => c, z => z, output_display => output, display_addr => display_addr, writeF => writeF, stop_flag => stop_flag);
 
	-- Stimulus process
	stimulus : process
	begin
		clk   <= '0';
		start <= '0';
		RST   <= '0';

		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
 
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;

		clk          <= '0'; 
		writeF       <= '1';
		display_addr <= "0000000000000000";
		data         <= "0011011000000001"; -- LHI R3 1
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
 
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;

		display_addr <= "0000000000000001";
		data         <= "0100000011000001"; -- LW R0 R3 1
 
		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
 
		display_addr <= "0000000000000010";
		data         <= "0001011011000001"; -- ADI R3 R3 1

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		display_addr <= "0000000000000011";
		data         <= "0100001011000001";  -- LW R1 R3 1

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk          <= '0';
		display_addr <= "0000000000000100";
		data         <= "0001001001000001"; -- ADI R1 R1 1
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		display_addr <= "0000000000000101";
		data         <= "1100001000000010"; -- BEQ R1 R0 2

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0'; 
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		display_addr <= "0000000000000110";
		data         <= "1000101111111110"; -- JAL R5 -2

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		display_addr <= "0000000000000111";
		data         <= "0101001011000010"; -- SW R1 R3

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
 

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		--
		display_addr <= "0000000000001000";
		data         <= "1111011000000000"; -- HALT

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		--
		display_addr <= "0000000010000001";
		data         <= "0000000000000101"; -- memory[129] = 5

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
		clk <= '1';

		wait for 2 ns;
 
		display_addr <= "0000000010000010";
		data         <= "0000000000000000"; -- memory[130] = 0

		clk          <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
		clk <= '1';

		wait for 2 ns;

		-- we are done loading instructions to memory
		-- we set start signal for the processor begin execution
		start <= '1';

		clk   <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;

		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;

		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;

 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';
 
		wait for 2 ns;
		-------------------------------
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk          <= '0';
		display_addr <= "0000000010000011";
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;

		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
 
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
		clk <= '0';
 
		wait for 2 ns;
 
		clk <= '1';

		wait for 2 ns;
 
 
	end process stimulus;
end architecture at;