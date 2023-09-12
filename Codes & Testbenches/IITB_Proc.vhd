library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IITB_Proc is -- entity declaration
	port 
	(
		clk, RST, start, writeF        : in std_logic;
		data, display_addr             : in std_logic_vector(15 downto 0);
		output_display                 : out std_logic_vector(15 downto 0);
		c, z                           : out std_logic;
		R0, R1, R2, R3, R4, R5, R6, R7 : out std_logic_vector(15 downto 0);
		stop_flag                      : out std_logic
	);
end entity;

architecture struct of IITB_Proc is

	component ALU -- Declaring ALU component
		port 
		(
			operation  : in std_logic;
			inp1, inp2 : in std_logic_vector(15 downto 0);
			outp       : out std_logic_vector(15 downto 0);
			c, z       : out std_logic
		);
	end component;

	component Memory -- Declaring Memory component
		port 
		(
			clock         : in std_logic;
			data          : in std_logic_vector (15 downto 0);
			write_address : in std_logic_vector(15 downto 0);
			read_address  : in std_logic_vector(15 downto 0);
			we            : in std_logic;
			q             : out std_logic_vector (15 downto 0)
		);
	end component;

	-- Memory signals
	signal mem_data, mem_write_addr, mem_read_addr, mem_display : std_logic_vector(15 downto 0);
	signal mem_writeF                                           : std_logic;

	--ALU signals
	signal alu_operation, alu_c, alu_z  : std_logic;
	signal alu_inp1, alu_inp2, alu_outp : std_logic_vector(15 downto 0);

begin
	memblock : Memory
	port map(clock => clk, data => mem_data, write_address => mem_write_addr, read_address => mem_read_addr, we => mem_writeF, q => mem_display);

	alu_unit : ALU
	port map(operation => alu_operation, inp1 => alu_inp1, inp2 => alu_inp2, outp => alu_outp, c => alu_c, z => alu_z);

	--

	process (clk, start)

	type mem is array(0 to 7) of std_logic_vector(15 downto 0);
	variable fileRegister       : mem;
	variable IR                 : std_logic_vector(15 downto 0) := "0000000000000000"; -- Instruction register
	variable PC                 : std_logic_vector(15 downto 0) := "0000000000000000"; -- Program Counter
	variable state              : integer range 0 to 40 := 0; -- Maintains state
	variable next_state         : integer range 0 to 40 := 0; -- Stores the state of the next clock cycle
	variable opcode             : std_logic_vector(3 downto 0); -- Temporarily stores the opcode read from the Instruction register
	variable instr_type         : std_logic_vector(1 downto 0); -- Temporary variable to store the last 2 bits of IR (type of ADD instruction)
	variable inp1, inp2, a_base : std_logic_vector(15 downto 0); -- inp1, inp2 : input vars to the ALU
	variable tmp1, tmp2         : std_logic_vector(2 downto 0); -- General purpose temporary variables
	variable flags              : std_logic_vector(1 downto 0) := "00"; -- Flag registers
	variable a_instrs           : integer range 0 to 8 := 0; -- Temporary variable
	variable tmp, tmp3          : std_logic_vector(15 downto 0); -- Temporary variables

begin
	-- Giving output to the file registers and flags
	R0 <= fileRegister(0);
	R1 <= fileRegister(1);
	R2 <= fileRegister(2);
	R3 <= fileRegister(3);
	R4 <= fileRegister(4);
	R5 <= fileRegister(5);
	R6 <= fileRegister(6);
	R7 <= fileRegister(7);

	c  <= flags(0);
	z  <= flags(1);
	
	-- Write into memory on the rising edge of clock and when start is 0
	if (start = '0' and rising_edge(clk)) then

		stop_flag      <= '0';

		mem_writeF     <= writeF;
		mem_write_addr <= display_addr;
		mem_data       <= data;

	-- When start becomes 1, start execution
	
	elsif (start = '1' and rising_edge(clk)) then

		if (state = 0) then -- Read from the memory address stored in the PC

			mem_read_addr <= PC;
			next_state := 37;
 
		elsif (state = 37) then  -- Store the instruction in the IR
			IR         := mem_display;
			next_state := 1;

		elsif (state = 1) then -- opcode specific commands and states

			opcode     := IR(15 downto 12);
			instr_type := IR(1 downto 0);

			if (opcode = "1111") then -- If opcode is 1111, then stop (HLT)
				stop_flag  <= '1';
				mem_writeF <= '0';
				next_state := 21;
				PC         := "0000000000000000";

			elsif (opcode = "0000") then -- ADD

				if (instr_type = "00") then
					next_state := 2;
 
				elsif (instr_type = "10") then
 
					if (flags(0) = '0') then
						next_state := 19;
					elsif (flags(0) = '1') then
						next_state := 2;
					end if;

				elsif (instr_type = "01") then
					if (flags(1) = '0') then
						next_state := 19;
					elsif (flags(1) = '1') then
						next_state := 2;
					end if;
				end if;
				-- 
			elsif (opcode = "0010") then -- NAND

				if (instr_type = "00") then
					next_state := 12;
 
				elsif (instr_type = "10") then
 
					if (flags(0) = '0') then
						next_state := 19;
					elsif (flags(0) = '1') then
						next_state := 12;
					end if;

				elsif (instr_type = "01") then
					if (flags(1) = '0') then
						next_state := 19;
					elsif (flags(1) = '1') then
						next_state := 12;
					end if;
				end if;
				--
			elsif (opcode = "0001") then -- ADI
				inp1(5 downto 0)  := IR(5 downto 0);
				inp1(15 downto 6) := IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & IR(5) & IR(5);
				inp2              := fileRegister(to_integer(unsigned(IR(11 downto 9))));
 
				alu_operation <= '1';
				alu_inp1      <= inp1;
				alu_inp2      <= inp2;
				next_state := 4;

			elsif (opcode = "0011") then -- LHI

				fileRegister(to_integer(unsigned(IR(11 downto 9)))) := IR(8 downto 0) & "0000000";
				next_state                                          := 19;
 
			elsif (opcode = "1001") then -- JLR
				tmp                                                 := PC;
				tmp3                                                := "0000000000000001";
				PC                                                  := std_logic_vector((unsigned(fileRegister(to_integer(unsigned(IR(8 downto 6)))))) - unsigned(tmp3));
				fileRegister(to_integer(unsigned(IR(11 downto 9)))) := tmp;
				next_state                                          := 19;

			elsif (opcode = "0100") then -- LW
				alu_inp1      <= "0000000000" & IR(5 downto 0);
				alu_inp2      <= fileRegister(to_integer(unsigned(IR(8 downto 6))));
				alu_operation <= '1';
				inp1 := alu_outp;

				mem_read_addr <= inp1;

				next_state := 36;
				-- 
			elsif (opcode = "0110") then -- LA
				a_base     := fileRegister(to_integer(unsigned(IR(11 downto 9))));
				next_state := 14;
 
			elsif (opcode = "0111") then -- RA
				a_base     := fileRegister(to_integer(unsigned(IR(11 downto 9))));
				next_state := 17;
 
				--
			elsif (opcode = "1100") then -- BEQ
				inp1       := fileRegister(to_integer(unsigned(IR(11 downto 9))));
				inp2       := fileRegister(to_integer(unsigned(IR(8 downto 6))));
				next_state := 28;
 
			elsif (opcode = "1000") then -- JAL
				fileRegister(to_integer(unsigned(IR(11 downto 9)))) := PC;
				next_state                                          := 29;
			elsif (opcode = "0101") then -- SW
				alu_inp1      <= "0000000000" & IR(5 downto 0);
				alu_inp2      <= fileRegister(to_integer(unsigned(IR(8 downto 6))));
				alu_operation <= '1';

				next_state := 35;

			end if;
----

		elsif (state = 2) then
			inp1 := fileRegister(to_integer(unsigned(IR(11 downto 9))));
			inp2 := fileRegister(to_integer(unsigned(IR(8 downto 6))));

			alu_operation <= '1';
			alu_inp1      <= inp1;
			alu_inp2      <= inp2;

			next_state := 3;
 
		elsif (state = 36) then
 
			mem_read_addr <= alu_outp;
 
			next_state := 5;

		elsif (state = 3) then

			fileRegister(to_integer(unsigned(IR(5 downto 3)))) := alu_outp;
			flags(0)                                           := alu_c;
			flags(1)                                           := alu_z;

			next_state                                         := 19;

		elsif (state = 4) then

			fileRegister(to_integer(unsigned(IR(8 downto 6)))) := alu_outp;
			flags(0)                                           := alu_c;
			flags(1)                                           := alu_z;

			next_state                                         := 19;

		elsif (state = 5) then

			fileRegister(to_integer(unsigned(IR(11 downto 9)))) := mem_display;

			if (mem_display = "0000000000000000") then
				flags(1) := '1';
			else
				flags(1) := '0';
			end if;

			next_state := 19;
 
			--
		elsif (state = 12) then
			inp1 := fileRegister(to_integer(unsigned(IR(11 downto 9))));
			inp2 := fileRegister(to_integer(unsigned(IR(8 downto 6))));

			alu_operation <= '0';
			alu_inp1      <= inp1;
			alu_inp2      <= inp2;

			next_state := 13;

		elsif (state = 13) then

			fileRegister(to_integer(unsigned(IR(5 downto 3)))) := alu_outp;
			flags(0)                                           := alu_c;
			flags(1)                                           := alu_z;

			next_state                                         := 19;

		elsif (state = 14) then
			if (a_instrs = 8) then
				a_instrs   := 0;
				next_state := 19;
			else
				inp1 := a_base;
				inp2 := std_logic_vector(to_unsigned(a_instrs, 16));
 
				alu_operation <= '1';
				alu_inp1      <= inp1;
				alu_inp2      <= inp2;

				next_state := 15;
			end if;
			--
		elsif (state = 15) then

			mem_read_addr <= alu_outp;
 
			next_state := 16;
 
		elsif (state = 16) then
			fileRegister(a_instrs) := mem_display;

			a_instrs               := a_instrs + 1;
			next_state             := 14;
 
			---
		elsif (state = 17) then
			if (a_instrs = 8) then
				a_instrs   := 0;
				next_state := 19;
			else
				inp1 := a_base;
				inp2 := std_logic_vector(to_unsigned(a_instrs, 16));
 
				alu_operation <= '1';
				alu_inp1      <= inp1;
				alu_inp2      <= inp2;

				next_state := 18;
			end if;
			--
		elsif (state = 18) then

			mem_write_addr <= alu_outp;
			mem_data       <= fileRegister(a_instrs);
			mem_writeF     <= '1';
 
			next_state := 20;
 
		elsif (state = 20) then
 
			mem_writeF <= '0';

			a_instrs   := a_instrs + 1;
			next_state := 17;
			---
 
		elsif (state = 19) then -- State where the PC is icremented
			PC         := std_logic_vector(unsigned(PC) + 1);
			next_state := 39;
 
		elsif (state = 21) then
			mem_read_addr <= display_addr;
			next_state := 22;
 
		elsif (state = 22) then
			output_display <= mem_display;
			next_state := 21;

		elsif (state = 28) then
			if (inp1 = inp2) then
				PC := std_logic_vector(signed(PC) + to_integer(signed(IR(5 downto 0))) - 1);
			end if;
			next_state := 19;
 
		elsif (state = 29) then
			PC         := std_logic_vector(signed(PC) + to_integer(signed(IR(8 downto 0))) - 1);
			next_state := 19;
 
 
		elsif (state = 35) then
 

			mem_writeF     <= '1';
			mem_write_addr <= alu_outp;
			mem_data       <= fileRegister(to_integer(unsigned(IR(11 downto 9))));
 
			next_state := 40;
 
		elsif (state = 40) then
 
			mem_writeF <= '0';
			next_state := 19;
 
		elsif (state = 39) then -- Redundant state; just to have a clock cycle in between
 
			next_state := 0;
		end if; --endif for state and start = 0

	end if; --endif for start = 1
	

	if (rising_edge(clk)) then

		if (RST = '1') then -- Whenever RST is 1, reset the variables state, next_state, PC and flags.
			state      := 0;
			next_state := 0;
			PC         := "0000000000000000";
			flags(0)   := '0';
			flags(1)   := '1';
		else
			state := next_state; -- Make state = next_state
		end if;
	end if;

end process;

end struct;