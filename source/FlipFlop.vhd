--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


--ENTITY
ENTITY FlipFlop IS
	PORT(
		Clk, Rst, En: IN STD_LOGIC;
		D: IN STD_LOGIC;
		Q: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: Behavioral
ARCHITECTURE Behavioral OF FlipFlop IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			Q <= '0';
		elsif(Clk'event and Clk = '1') then
			if(En = '1') then
				Q <= D;
			end if;	
		end if;
	end process;
END Behavioral;