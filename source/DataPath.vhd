--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY DataPath IS
	PORT(
		Clk, Rst: IN STD_LOGIC;
		PipeLineEn: IN STD_LOGIC;
		AFEn_OutputLd: IN STD_LOGIC;
		WeightEn_WRTEn_AccLd: IN STD_LOGIC;
		CountEn_InputBufferEn: IN STD_LOGIC;
		Inputs: IN WeightType;
		InputBufferWriteEn: IN STD_LOGIC;
		CountDone: OUT STD_LOGIC;
		S6OutputLd: OUT STD_LOGIC;
		Q: OUT InputWeightType
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF DataPath IS
	SIGNAL OutputWeights, OutputWeights_S4, OutputWeights_TriStated, Inputs_TriStated, toMult: InputWeightType;
	SIGNAL OutputInputs, OutputInputs_S4: WeightType; --its name is confusing!
	SIGNAL Address, Address_S1, Address_S2, Address_S3, Input_Address: STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0);
	SIGNAL MUXOutputs, MultArrayOutputs, MultArrayOutputs_S5, AddArrayOutputs, AccOutputs, AccOutputs_S6, ActivationFunctionOutputs: InputWeightType;
	SIGNAL WRTOut_S1, WRTOut_S2, WRTOut_S3, WRTOut_S34, WRTOut_S4, WRTOut_S5: DecodedSelectorsType;
	SIGNAL Enables, Enables_S3, Enables_S34, Enables_S4, AndedEnables, AndedEnables_S3: DecodedSelectorType;
	SIGNAL Input_Buffer_dina: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0);

	--Control Signals
	SIGNAL WeightEn_AccLd_S1, AFEn_OutputLd_S1, InputBufferEn_S1: STD_LOGIC;
	SIGNAL WeightEn_AccLd_S2, AFEn_OutputLd_S2, InputBufferEn_S2: STD_LOGIC;
	SIGNAL AFEn_OutputLd_S3, AccLd_S3, InputBufferEn_S3: STD_LOGIC;
	SIGNAL AFEn_OutputLd_S34, AccLd_S34: STD_LOGIC;
	SIGNAL AFEn_OutputLd_S4, AccLd_S4: STD_LOGIC;
	SIGNAL AFEn_OutputLd_S5, AccLd_S5: STD_LOGIC;
	SIGNAL AFEn_OutputLd_S6: STD_LOGIC;
	SIGNAL ORTMP: STD_LOGIC;
BEGIN


	--Stage 1
	Address_Counter: ENTITY WORK.Counter(Behavioral) PORT MAP(
		Clk => Clk,
		Rst => Rst,
		CountEn => CountEn_InputBufferEn,
		CountDone => CountDone,
		Q => Address
	);

	WRT_Table: ENTITY WORK.WRT(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => WeightEn_WRTEn_AccLd,
		ADDR => Address,
		DATA => WRTOut_S1
	);
	--Pipe for Synchronization
	S1Pipe: ENTITY WORK.Stage1Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		Address => Address,
		WeightEn_AccLd => WeightEn_WRTEn_AccLd,
		AFEn_OutputLd => AFEn_OutputLd,
		InputBufferEn => CountEn_InputBufferEn,
		Address_S1 => Address_S1,
		WeightEn_AccLd_S1 => WeightEn_AccLd_S1,
		AFEn_OutputLd_S1 => AFEn_OutputLd_S1,
		InputBufferEn_S1 => InputBufferEn_S1
	);

	--Stage 1 - 2 Pipe
	S12Pipe: ENTITY WORK.Stage12Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		Address_S1 => Address_S1,
		WRTOut_S1 => WRTOut_S1,
		WeightEn_AccLd_S1 => WeightEn_AccLd_S1,
		AFEn_OutputLd_S1 => AFEn_OutputLd_S1,
		InputBufferEn_S1 => InputBufferEn_S1,
		Address_S2 => Address_S2,
		WRTOut_S2 => WRTOut_S2,
		WeightEn_AccLd_S2 => WeightEn_AccLd_S2,
		AFEn_OutputLd_S2 => AFEn_OutputLd_S2,
		InputBufferEn_S2 => InputBufferEn_S2
	);

	--Stage 2
	Enble_Maker: ENTITY WORK.Mult_Load_Enables(Wired_OR) port map(
		D => WRTOut_S2,
		Q => Enables
	);

	Enable_ANDS: for index in (N - 1) downto 0 generate begin
		ANDS: ENTITY WORK.AND2(GateLevel) port map(A => Enables(index), B => WeightEn_AccLd_S2, Q => AndedEnables(index));
	end generate;

	--Stage 2 - 3 Pipe
	S23Pipe: ENTITY WORK.Stage23Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		Address_S2 => Address_S2,
		WRTOut_S2 => WRTOut_S2,
		Enables => Enables,
		AndedEnables => AndedEnables,
		AFEn_OutputLd_S2 => AFEn_OutputLd_S2,
		AccLd_S2 => WeightEn_AccLd_S2,
		InputBufferEn_S2 => InputBufferEn_S2,
		Address_S3 => Address_S3,
		WRTOut_S3 => WRTOut_S3,
		Enables_S3 => Enables_S3,
		AndedEnables_S3 => AndedEnables_S3,
		AFEn_OutputLd_S3 => AFEn_OutputLd_S3,
		AccLd_S3 => AccLd_S3,
		InputBufferEn_S3 => InputBufferEn_S3
	);

	--State 3
	Input_Buffer_Address_Maker: ENTITY WORK.MUX2to1(GateLevel_TriState)
	GENERIC MAP(
		PORT_SIZE => LOGK
	)
	PORT MAP(
		D1 => Address_S3,
		D2 => Address,
		Selector => InputBufferWriteEn,
		Q => Input_Address
	);
	ORTMP <= InputBufferEn_S3 or CountEn_InputBufferEn;
	Input_Buffer : ENTITY WORK.Input_Ram(Behavioral)
	PORT MAP (
	    clka => Clk,
	    rsta => Rst,
	    ena => ORTMP,
	    wea => InputBufferWriteEn,
	    addra => Input_Address,
	    dina => Inputs,
	    douta => OutputInputs
	);

	NWS : ENTITY WORK.Neuron_Weights(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => AndedEnables_S3,
		ADDR => Address_S3,
		DATA => OutputWeights
	);
	--Stage 3 Pipe for Synchronization
	S3Pipe: ENTITY WORK.Stage3Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		WRTOut_S3 => WRTOut_S3,
		Enables_S3 => Enables_S3,
		AFEn_OutputLd_S3 => AFEn_OutputLd_S3,
		AccLd_S3 => AccLd_S3,
		WRTOut_S34 => WRTOut_S34,
		Enables_S34 => Enables_S34,
		AFEn_OutputLd_S34 => AFEn_OutputLd_S34,
		AccLd_S34 => AccLd_S34
	);

	--Stage 3 - 4 Pipe
	S34Pipe: ENTITY WORK.Stage34Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		WRTOut_S34 => WRTOut_S34,
		Enables_S34 => Enables_S34,
		OutputInputs => OutputInputs,
		OutputWeights => OutputWeights,
		AFEn_OutputLd_S34 => AFEn_OutputLd_S34,
		AccLd_S34 => AccLd_S34,
		WRTOut_S4 => WRTOut_S4,
		Enables_S4 => Enables_S4,
		OutputInputs_S4 => OutputInputs_S4,
		OutputWeights_S4 => OutputWeights_S4,
		AFEn_OutputLd_S4 => AFEn_OutputLd_S4,
		AccLd_S4 => AccLd_S4
	);

	--Stage 4
	Weight_TriStates: ENTITY WORK.WeightTriStates_Array(GateLevel) port map(
		D => OutputWeights_S4,
		En => Enables_S4,
		Q => OutputWeights_TriStated
	);

	Input_TriStates: ENTITY WORK.InputTriStates_Array(GateLevel) port map(
		D => OutputInputs_S4,
		En => Enables_S4,
		Q => Inputs_TriStated
	);

	Mult_Array: ENTITY WORK.MultArray(GateLevel) port map(
		A => Inputs_TriStated,
		B => OutputWeights_TriStated,
		Q => MultArrayOutputs
	);

	--Stage 4 - 5 Pipe
	S45Pipe: ENTITY WORK.Stage45Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		WRTOut_S4 => WRTOut_S4,
		MultArrayOutputs => MultArrayOutputs,
		AFEn_OutputLd_S4 => AFEn_OutputLd_S4,
		AccLd_S4 => AccLd_S4,
		WRTOut_S5 => WRTOut_S5,
		MultArrayOutputs_S5 => MultArrayOutputs_S5,
		AFEn_OutputLd_S5 => AFEn_OutputLd_S5,
		AccLd_S5 => AccLd_S5
	);

	--Stage 5
	MUX_Array: ENTITY WORK.MUXArray(GateLevel_TriState) port map(
		D => MultArrayOutputs_S5,
		DecodedAddresses => WRTOut_S5,
		Q => MUXOutputs
	);

	Add_Array: ENTITY WORK.AddArray(GateLevel) port map(
		A => MUXOutputs,
		B => AccOutputs,
		Q => AddArrayOutputs
	);
	Acc_Reg: ENTITY WORK.OutputBuffer(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => AccLd_S5,
		D => AddArrayOutputs,
		Q => AccOutputs
	);

	--Stage 5 - 6 Pipe
	S56Pipe: ENTITY WORK.Stage56Pipe(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		PipeLineEn => PipeLineEn,
		AccOutputs => AccOutputs,
		AFEn_OutputLd_S5 => AFEn_OutputLd_S5,
		AccOutputs_S6 => AccOutputs_S6,
		AFEn_OutputLd_S6 => AFEn_OutputLd_S6
	);

	--Stage 6
	Activation_Function: ENTITY WORK.ActivationFunctionArray(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		D => AccOutputs_S6,
		AFEn => AFEn_OutputLd_S6,
		Q => ActivationFunctionOutputs
	);
	Output_Buffer: ENTITY WORK.OutputBuffer(Behavioral)  port map(
		Clk => Clk,
		Rst => Rst,
		En => AFEn_OutputLd_S6,
		D => ActivationFunctionOutputs,
		Q => Q
	);
	S6OutputLd <= AFEn_OutputLd_S6;
END GateLevel;
