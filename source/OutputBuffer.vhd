--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY OutputBuffer IS
	PORT(
		Clk, Rst, En: IN STD_LOGIC;
		D: IN InputWeightType;
		Q: OUT InputWeightType
	);
END ENTITY;


--ARCHITECTURE 1: Gate Level
ARCHITECTURE GateLevel OF OutputBuffer IS
BEGIN
	WEIGHTREGISTERS: for index in (N - 1) downto 0 generate
	begin
		WEIGHTREGISTER: ENTITY WORK.WeightReg(GateLevel) port map(Clk => Clk, Rst => Rst, En => En, D => D(index), Q => Q(index));
	end generate;
END GateLevel;

--ARCHITECTURE 1: Behavioral
ARCHITECTURE Behavioral OF OutputBuffer IS
BEGIN
	process(Clk)
	begin
		if(Rst = '1') then
			Q <= (others=>(others=>'0'));
		elsif(Clk'event and Clk = '1') then
			if(En = '1') then
				Q <= D;
			end if;	
		end if;
	end process;
END Behavioral;
