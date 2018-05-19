--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY Stage3Pipe IS
	PORT(
		Clk, Rst, PipeLineEn: IN STD_LOGIC;
		WRTOut_S3: IN DecodedSelectorsType;
		Enables_S3: IN DecodedSelectorType;
		AFEn_OutputLd_S3: IN STD_LOGIC;
		AccLd_S3: IN STD_LOGIC;
		WRTOut_S34: OUT DecodedSelectorsType;
		Enables_S34: OUT DecodedSelectorType;
		AFEn_OutputLd_S34: OUT STD_LOGIC;
		AccLd_S34: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF Stage3Pipe IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			WRTOut_S34 <= (others => (others => '0'));
			Enables_S34 <= (others => '0');
			AFEn_OutputLd_S34 <= '0';
			AccLd_S34 <= '0';
		elsif(Clk'event and Clk = '1') then
			if(PipeLineEn = '1') then
				WRTOut_S34 <= WRTOut_S3;
				Enables_S34 <= Enables_S3;
				AFEn_OutputLd_S34 <= AFEn_OutputLd_S3;
				AccLd_S34 <= AccLd_S3;
			end if;
		end if;
	end process;
END GateLevel;
