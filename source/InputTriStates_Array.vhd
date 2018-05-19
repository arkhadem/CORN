--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY InputTriStates_Array IS
	PORT(
		D: IN WeightType;
		En: IN DecodedSelectorType;
		Q: OUT InputWeightType
	);
END ENTITY;

----ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF InputTriStates_Array IS
BEGIN
	TRISTATES: for index in (N - 1) downto 0 generate
	begin
		TRISTATE: ENTITY WORK.TriStateIM(GateLevel) port map(D => D, En => En(index), Q => Q(index));
	end generate;
END GateLevel;
