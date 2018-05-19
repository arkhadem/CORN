--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY CORNDesign IS
	PORT(
		Clk, Rst, En: IN STD_LOGIC;
		InputReady: IN STD_LOGIC;
		Inputs: IN WeightType;
		Done: OUT STD_LOGIC;
		Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8: OUT WeightType
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF CORNDesign IS
	SIGNAL InputLd, WeightEn, AFEn, WRTEn, AccLd, CountEn, InputBufferEn, OutputLd, CountDone: STD_LOGIC;
	SIGNAL Q: InputWeightType;
BEGIN
	CORNDATAPATH: ENTITY WORK.DataPath(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		WeightEn => WeightEn,
		AFEn => AFEn,
		WRTEn => WRTEn,
		AccLd => AccLd,
		CountEn => CountEn,
		InputBufferEn => InputBufferEn,
		OutputLd => OutputLd,
		Inputs => Inputs,
		InputBufferWriteEn => InputLd,
		CountDone => CountDone,
		Q => Q
	);
	CORNCONTROLLER: ENTITY WORK.Controller(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => En,
		InputReady => InputReady,
		WeightEn => WeightEn,
		AFEn => AFEn,
		WRTEn => WRTEn,
		AccLd => AccLd,
		CountEn => CountEn,
		InputBufferEn => InputBufferEn,
		OutputLd => OutputLd,
		InputBufferWriteEn => InputLd,
		CountDone => CountDone,
		Done => Done
	);
	Q1 <= Q(0);
	Q2 <= Q(1);
	Q3 <= Q(2);
	Q4 <= Q(3);
	Q5 <= Q(4);
	Q6 <= Q(5);
	Q7 <= Q(6);
	Q8 <= Q(7);
END GateLevel;
