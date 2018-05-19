--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY DataPath IS
	PORT(
		Clk, Rst: IN STD_LOGIC;
		WeightEn: IN STD_LOGIC;
		AFEn: IN STD_LOGIC;
		WRTEn: IN STD_LOGIC;
		AccLd: IN STD_LOGIC;
		CountEn: IN STD_LOGIC;
		InputBufferEn: IN STD_LOGIC;
		OutputLd: IN STD_LOGIC;
		Inputs: IN WeightType;
		InputBufferWriteEn: IN STD_LOGIC;
		CountDone: OUT STD_LOGIC;
		Q: OUT InputWeightType
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF DataPath IS
	SIGNAL OutputWeights, OutputWeights_TriStated, Inputs_TriStated, toMult: InputWeightType;
	SIGNAL OutputInputs: WeightType; --its name is confusing!
	SIGNAL WRT_Address, Weight_Address, Input_Address: STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0);
	SIGNAL MUXOutputs, MultArrayOutputs, AddArrayOutputs, AccOutputs, ActivationFunctionOutputs: InputWeightType;
	SIGNAL DecodedAddresses, DecodedAddresses_Reg: DecodedSelectorsType;
	SIGNAL Enables, AndedEnables, Enables_Reg: DecodedSelectorType;
	SIGNAL Input_Buffer_dina: STD_LOGIC_VECTOR((I + M - 1) DOWNTO 0);
BEGIN

	Address_Counter: ENTITY WORK.Counter(Behavioral) PORT MAP(
		Clk => Clk,
		Rst => Rst,
		CountEn => CountEn,
		CountDone => CountDone,
		Q_WRT => WRT_Address,
		Q_Weight => Weight_Address
	);

	Input_Buffer_Address_Maker: ENTITY WORK.MUX2to1(GateLevel_TriState)
	GENERIC MAP(
		PORT_SIZE => LOGK
	)
	PORT MAP(
		D1 => Weight_Address,
		D2 => WRT_Address,
		Selector => InputBufferWriteEn,
		Q => Input_Address
	);

	Input_Buffer : ENTITY WORK.Input_Ram(Behavioral)
	PORT MAP (
	    clka => Clk,
	    rsta => Rst,
	    ena => InputBufferEn,
	    wea => InputBufferWriteEn,
	    addra => Input_Address,
	    dina => Inputs,
	    douta => OutputInputs
	);

	NWS : ENTITY WORK.Neuron_Weights(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => AndedEnables,
		ADDR => Weight_Address,
		DATA => OutputWeights
	);

	Weight_TriStates: ENTITY WORK.WeightTriStates_Array(GateLevel) port map(
		D => OutputWeights,
		En => Enables_Reg,
		Q => OutputWeights_TriStated
	);
	Input_TriStates: ENTITY WORK.InputTriStates_Array(GateLevel) port map(
		D => OutputInputs,
		En => Enables_Reg,
		Q => Inputs_TriStated
	);
	Mult_Array: ENTITY WORK.MultArray(GateLevel) port map(
		A => Inputs_TriStated,
		B => OutputWeights_TriStated,
		Q => MultArrayOutputs
	);

	WRT_Table: ENTITY WORK.WRT(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		En => WRTEn,
		ADDR => WRT_Address,
		DATA => DecodedAddresses
	);

	Enble_Maker: ENTITY WORK.Mult_Load_Enables(Wired_OR) port map(
		D => DecodedAddresses,
		Q => Enables
	);
	Enble_Maker2: ENTITY WORK.Mult_Load_Enables(Wired_OR) port map(
		D => DecodedAddresses_Reg,
		Q => Enables_Reg
	);
	Enables_Registers: ENTITY WORK.EnableRegister(GateLevel) port map(
		Clk => Clk,
		Rst => Rst,
		D => DecodedAddresses,
		Q => DecodedAddresses_Reg
	);

	Enable_ANDS: for index in (N - 1) downto 0 generate begin
		ANDS: ENTITY WORK.AND2(GateLevel) port map(A => Enables(index), B => WeightEn, Q => AndedEnables(index));
	end generate;

	MUX_Array: ENTITY WORK.MUXArray(GateLevel_TriState) port map(
		D => MultArrayOutputs,
		DecodedAddresses => DecodedAddresses_Reg,
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
		En => AccLd,
		D => AddArrayOutputs,
		Q => AccOutputs
	);
	Activation_Function: ENTITY WORK.ActivationFunctionArray(Behavioral) port map(
		Clk => Clk,
		Rst => Rst,
		D => AccOutputs,
		AFEn => AFEn,
		Q => ActivationFunctionOutputs
	);
	Output_Buffer: ENTITY WORK.OutputBuffer(Behavioral)  port map(
		Clk => Clk,
		Rst => Rst,
		En => OutputLd,
		D => ActivationFunctionOutputs,
		Q => Q
	);
END GateLevel;
