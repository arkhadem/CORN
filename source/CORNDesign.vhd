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
	SIGNAL AFEn_OutputLd, WeightEn_WRTEn_AccLd, CountEn_InputBufferEn, CountDone, InputLd, PipeLineEn, S6OutputLd: STD_LOGIC;
	SIGNAL Q: InputWeightType;
BEGIN
	CORNDATAPATH: ENTITY WORK.DataPath(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		AFEn_OutputLd => AFEn_OutputLd,
		WeightEn_WRTEn_AccLd => WeightEn_WRTEn_AccLd,
		CountEn_InputBufferEn => CountEn_InputBufferEn,
		Inputs => Inputs,
		InputBufferWriteEn => InputLd,
		CountDone => CountDone,
		S6OutputLd => S6OutputLd,
		Q => Q
	);
	CORNCONTROLLER: ENTITY WORK.Controller(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => En,
		InputReady => InputReady,
		PipeLineEn => PipeLineEn,
		AFEn_OutputLd => AFEn_OutputLd,
		WeightEn_WRTEn_AccLd => WeightEn_WRTEn_AccLd,
		CountEn_InputBufferEn => CountEn_InputBufferEn,
		InputBufferWriteEn => InputLd,
		CountDone => CountDone,
		S6OutputLd => S6OutputLd,
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
