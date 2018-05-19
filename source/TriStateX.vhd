--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY TriStateX IS
	GENERIC(
		PORT_SIZE: INTEGER
	);
	PORT(
		D: IN STD_LOGIC_VECTOR((PORT_SIZE - 1) DOWNTO 0);
		En: IN STD_LOGIC;
		Q: OUT STD_LOGIC_VECTOR((PORT_SIZE - 1) DOWNTO 0)
	);
END ENTITY;

----ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF TriStateX IS
BEGIN
	TRISTATES: for index in (PORT_SIZE - 1) downto 0 generate
	begin
		TRISTATE: ENTITY WORK.TriState(Behavioral) port map(D => D(index), En => En, Q => Q(index));
	end generate;
END GateLevel;
