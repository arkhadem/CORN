--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY MUX2to1 IS
	GENERIC(
		PORT_SIZE: INTEGER
	);
	PORT(
		D1, D2: IN STD_LOGIC_VECTOR((PORT_SIZE - 1) DOWNTO 0);
		Selector: IN STD_LOGIC;
		Q: OUT STD_LOGIC_VECTOR((PORT_SIZE - 1) DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE GateLevel_TriState OF MUX2to1 IS
	SIGNAL TriStateOut: InputWeightType;
	SIGNAL Selector_Bar: STD_LOGIC;
BEGIN
	Selector_Bar <= NOT(Selector);
	TRISTATE_DECODER1: ENTITY WORK.TriStateX(GateLevel)
	generic map(PORT_SIZE => PORT_SIZE)
	port map(D => D1, En => Selector_Bar, Q => Q);
	TRISTATE_DECODER2: ENTITY WORK.TriStateX(GateLevel)
	generic map(PORT_SIZE => PORT_SIZE)
	port map(D => D2, En => Selector, Q => Q);
END GateLevel_TriState;
