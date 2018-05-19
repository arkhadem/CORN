--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY MultArray IS
	PORT(
		A: IN InputWeightType;
		B: IN InputWeightType;
		Q: OUT InputWeightType
	);
END ENTITY;

--ARCHITECTURE 1: Gate Level
ARCHITECTURE GateLevel OF MultArray IS
BEGIN
	MULTIPLIERS: for index in (N - 1) downto 0 generate
	begin
		MULTIPLIER: ENTITY WORK.Multiplier(Behavioral) port map(A => A(index), B => B(index), Q => Q(index));
	end generate;
END GateLevel;
