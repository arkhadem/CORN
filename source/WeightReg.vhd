--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY WeightReg IS
	PORT(
		Clk, Rst, En: IN STD_LOGIC;
		D: IN WeightType;
		Q: OUT WeightType
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF WeightReg IS
BEGIN
	REGS: for index in (I + M - 1) downto 0 generate
	begin
		REG: ENTITY WORK.FlipFlop(Behavioral) port map(Clk => Clk, Rst => Rst, En => En, D => D(index), Q => Q(index));
	end generate;
END GateLevel;
