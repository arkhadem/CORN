--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
	-- CC indicates number of Clock Cycles to calculate net
	-- I indicates number of Integer digits of weight
	-- M indicates number of Mantissa digits of weight
	-- K indicates number of Inputs
	-- N indicates number of Nuerons in a core
	-- LOGK indicates logarithm base 2 of K
PACKAGE NewTypes IS
	CONSTANT I: INTEGER := 6;
	CONSTANT M: INTEGER := 10;
	CONSTANT K: INTEGER := 16;
	CONSTANT N: INTEGER := 8;
	CONSTANT LOGK: INTEGER := 4;
	TYPE DecodedAddressType IS ARRAY ((K - 1) DOWNTO 0) OF STD_LOGIC;
	TYPE DecodedSelectorType IS ARRAY ((N - 1) DOWNTO 0) OF STD_LOGIC;
	TYPE WeightType IS ARRAY((I + M - 1) DOWNTO 0) OF STD_LOGIC;
	TYPE DecodedSelectorsType IS ARRAY((N - 1) DOWNTO 0) OF DecodedSelectorType;
	TYPE NeuronWeightsType IS ARRAY((K - 1) DOWNTO 0) OF WeightType;
	TYPE InputWeightType IS ARRAY((N - 1) DOWNTO 0) OF WeightType;
	TYPE WeightMatrixType IS ARRAY (0 to (N - 1)) OF NeuronWeightsType;
	TYPE AFInCellType IS ARRAY(0 to 127) OF STD_LOGIC_VECTOR(6 downto 0);
	TYPE AFOutCellType IS ARRAY(0 to 127) OF STD_LOGIC_VECTOR(15 downto 0);
	FUNCTION TO_Std_Logic_Vector(SIGNAL InArray: WeightType) RETURN STD_LOGIC_VECTOR;
	FUNCTION TO_Weight(SIGNAL InArray: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0)) RETURN WeightType;
END NewTypes;

PACKAGE BODY NewTypes IS
	FUNCTION TO_Std_Logic_Vector(SIGNAL InArray: WeightType) RETURN STD_LOGIC_VECTOR IS
		VARIABLE OutArray : STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0);
	BEGIN
		for i in InArray'range loop
			OutArray(i) := InArray(i);
		end loop;
		return OutArray;
	END TO_Std_Logic_Vector;

	FUNCTION TO_Weight(SIGNAL InArray: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0)) RETURN WeightType IS
		VARIABLE OutArray : WeightType;
	BEGIN
		for i in InArray'range loop
			OutArray(i) := InArray(i);
		end loop;
		return OutArray;
	END TO_Weight;
END NewTypes;
