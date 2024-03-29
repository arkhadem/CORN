--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


--ENTITY
ENTITY AND2 IS
	PORT(
		A, B: IN STD_LOGIC;
		Q: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: Behavioral
ARCHITECTURE GateLevel OF AND2 IS
BEGIN
	Q <= A AND B;
END GateLevel;