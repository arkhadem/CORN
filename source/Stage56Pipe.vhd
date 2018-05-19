--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY Stage56Pipe IS
	PORT(
		Clk, Rst, PipeLineEn: IN STD_LOGIC;
		AccOutputs: IN InputWeightType;
		AFEn_OutputLd_S5: IN STD_LOGIC;
		AccOutputs_S6: OUT InputWeightType;
		AFEn_OutputLd_S6: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF Stage56Pipe IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			AccOutputs_S6 <= (others =>(others => '0'));
			AFEn_OutputLd_S6 <= '0';
		elsif(Clk'event and Clk = '1') then
			if(PipeLineEn = '1') then
				AccOutputs_S6 <= AccOutputs;
				AFEn_OutputLd_S6 <= AFEn_OutputLd_S5;
			end if;
		end if;
	end process;
END GateLevel;
