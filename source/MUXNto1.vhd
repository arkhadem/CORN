--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY MUXNto1 IS
	PORT(
		D: IN InputWeightType;
		DecodedAddress: IN DecodedSelectorType;
		Q: OUT WeightType
	);
END ENTITY;

ARCHITECTURE GateLevel_TriState OF MUXNto1 IS
	SIGNAL TriStateOut: InputWeightType;
BEGIN
	TRISTATE_DECODERS_2: for weight_index in (N - 1) downto 0 generate
	begin
		TRISTATE_DECODER: ENTITY WORK.TriStateIM(GateLevel) port map(D => D(weight_index), En => DecodedAddress(weight_index), Q => TriStateOut(weight_index));
	end generate;
	WIRE_OR_2: for weight_index in (N - 1) downto 0 generate
	begin
		Q <= TriStateOut(weight_index);
	end generate;
END GateLevel_TriState;
