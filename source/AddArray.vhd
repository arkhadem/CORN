--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY AddArray IS
	PORT(
		A, B: IN InputWeightType;
		Q: OUT InputWeightType
	);
END ENTITY;

--ARCHITECTURE 1: Gate Level
ARCHITECTURE GateLevel OF AddArray IS
BEGIN
	ADDERS: for index in (N - 1) downto 0 generate
	begin
		ADDER: ENTITY WORK.Adder(Behavioral) port map(A => A(index), B => B(index), Q => Q(index));
	end generate;
END GateLevel;
