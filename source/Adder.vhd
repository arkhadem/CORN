--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.all;
USE WORK.NewTypes.ALL;


--ENTITY
ENTITY Adder IS
	PORT(
		A, B: IN WeightType;
		Q: OUT WeightType
	);
END ENTITY;

--ARCHITECTURE 1: Gate Level
ARCHITECTURE Behavioral OF Adder IS
	SIGNAL ATMP, BTMP: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0);
	SIGNAL QTMP: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0);
BEGIN
	ATMP <= TO_Std_Logic_Vector(A);
	BTMP <= TO_Std_Logic_Vector(B);
	Q <= TO_Weight(QTMP);
	QTMP <= ATMP + BTMP;
END Behavioral;