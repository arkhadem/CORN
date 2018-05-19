--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY Mult_Load_Enables IS
	PORT(
		D: IN DecodedSelectorsType;
		Q: OUT DecodedSelectorType
	);
END ENTITY;

ARCHITECTURE Wired_OR OF Mult_Load_Enables IS
BEGIN
	En_Finder: for index in (N - 1) downto 0 generate begin
		Q(index) <= D(index)(index);
	end generate En_Finder;
END Wired_OR;
