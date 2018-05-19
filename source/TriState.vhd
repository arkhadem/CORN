--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY TriState IS
	PORT(
		D, En: IN STD_LOGIC;
		Q: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: Behavioral
ARCHITECTURE Behavioral OF TriState IS
BEGIN
	Q <= D when (En = '1') else 'Z';
END Behavioral;