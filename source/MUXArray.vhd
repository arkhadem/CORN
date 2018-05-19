--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY MUXArray IS
	PORT(
		D: IN InputWeightType;
		DecodedAddresses: IN DecodedSelectorsType;
		Q: OUT InputWeightType
	);
END ENTITY;

ARCHITECTURE GateLevel_TriState OF MUXArray IS
BEGIN
	MULTIPLEXERS: for mux_index in (N - 1) downto 0 generate
	begin
		MULTIPLEXER: ENTITY WORK.MUXNto1(GateLevel_TriState) port map(
			D => D,
			DecodedAddress => DecodedAddresses(mux_index),
			Q => Q(mux_index)
		);
	end generate;
END GateLevel_TriState;
