--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY TriStateIM IS
	PORT(
		D: IN WeightType;
		En: IN STD_LOGIC;
		Q: OUT WeightType
	);
END ENTITY;

----ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF TriStateIM IS
BEGIN
	TRISTATES: for index in (I + M - 1) downto 0 generate
	begin
		TRISTATE: ENTITY WORK.TriState(Behavioral) port map(D => D(index), En => En, Q => Q(index));
	end generate;
END GateLevel;
