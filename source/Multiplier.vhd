--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.all;
USE WORK.NewTypes.ALL;


--ENTITY
ENTITY Multiplier IS
	PORT(
		A, B: IN WeightType;
		Q: OUT WeightType
	);
END ENTITY;

--ARCHITECTURE 1: Gate Level
ARCHITECTURE Behavioral OF Multiplier IS
	SIGNAL ATMP, BTMP: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0);
	SIGNAL QTMP: STD_LOGIC_VECTOR((2*I + 2*M - 1) DOWNTO 0);
	ATTRIBUTE multstyle: STRING;
    ATTRIBUTE multstyle OF Behavioral: ARCHITECTURE is "dsp"; 
BEGIN
	ATMP <= TO_Std_Logic_Vector(A);
	BTMP <= TO_Std_Logic_Vector(B);
	Q <= TO_Weight(QTMP((I + 2 * M - 1) downto M));
	QTMP <= ATMP * BTMP;
END Behavioral;