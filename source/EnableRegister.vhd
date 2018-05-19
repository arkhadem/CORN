--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY EnableRegister IS
	PORT(
		Clk, Rst: IN STD_LOGIC;
		D: IN DecodedSelectorsType;
		Q: OUT DecodedSelectorsType
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF EnableRegister IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			Q <= (others => (others => '0'));
		elsif(Clk'event and Clk = '1') then
			Q <= D;
		end if;
	end process;
END GateLevel;
