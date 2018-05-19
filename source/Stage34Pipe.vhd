--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY Stage34Pipe IS
	PORT(
		Clk, Rst, PipeLineEn: IN STD_LOGIC;
		WRTOut_S34: IN DecodedSelectorsType;
		Enables_S34: IN DecodedSelectorType;
		OutputInputs: IN WeightType;
		OutputWeights: IN InputWeightType;
		AFEn_OutputLd_S34: IN STD_LOGIC;
		AccLd_S34: IN STD_LOGIC;
		WRTOut_S4: OUT DecodedSelectorsType;
		Enables_S4: OUT DecodedSelectorType;
		OutputInputs_S4: OUT WeightType;
		OutputWeights_S4: OUT InputWeightType;
		AFEn_OutputLd_S4: OUT STD_LOGIC;
		AccLd_S4: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF Stage34Pipe IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			WRTOut_S4 <= (others =>(others => '0'));
			Enables_S4 <= (others => '0');
			OutputInputs_S4 <= (others => '0');
			OutputWeights_S4 <= (others =>(others => '0'));
			AFEn_OutputLd_S4 <= '0';
			AccLd_S4 <= '0';
		elsif(Clk'event and Clk = '1') then
			if(PipeLineEn = '1') then
				WRTOut_S4 <= WRTOut_S34;
				Enables_S4 <= Enables_S34;
				OutputInputs_S4 <= OutputInputs;
				OutputWeights_S4 <= OutputWeights;
				AFEn_OutputLd_S4 <= AFEn_OutputLd_S34;
				AccLd_S4 <= AccLd_S34;
			end if;
		end if;
	end process;
END GateLevel;
