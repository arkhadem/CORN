--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY Stage45Pipe IS
	PORT(
		Clk, Rst, PipeLineEn: IN STD_LOGIC;
		WRTOut_S4: IN DecodedSelectorsType;
		MultArrayOutputs: IN InputWeightType;
		AFEn_OutputLd_S4: IN STD_LOGIC;
		AccLd_S4: IN STD_LOGIC;
		WRTOut_S5: OUT DecodedSelectorsType;
		MultArrayOutputs_S5: OUT InputWeightType;
		AFEn_OutputLd_S5: OUT STD_LOGIC;
		AccLd_S5: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF Stage45Pipe IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			WRTOut_S5 <=  (others =>(others => '0'));
			MultArrayOutputs_S5 <=  (others =>(others => '0'));
			AFEn_OutputLd_S5 <= '0';
			AccLd_S5 <= '0';
		elsif(Clk'event and Clk = '1') then
			if(PipeLineEn = '1') then
				WRTOut_S5 <= WRTOut_S4;
				MultArrayOutputs_S5 <= MultArrayOutputs;
				AFEn_OutputLd_S5 <= AFEn_OutputLd_S4;
				AccLd_S5 <= AccLd_S4;
			end if;
		end if;
	end process;
END GateLevel;
