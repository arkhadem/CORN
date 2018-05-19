--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;

--ENTITY
ENTITY Stage1Pipe IS
	PORT(
		Clk, Rst, PipeLineEn: IN STD_LOGIC;
		Address: IN STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0);
		WeightEn_AccLd: IN STD_LOGIC;
		AFEn_OutputLd: IN STD_LOGIC;
		InputBufferEn: IN STD_LOGIC;
		Address_S1: OUT STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0);
		WeightEn_AccLd_S1: OUT STD_LOGIC;
		AFEn_OutputLd_S1: OUT STD_LOGIC;
		InputBufferEn_S1: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: GateLevel
ARCHITECTURE GateLevel OF Stage1Pipe IS
BEGIN
	process(Clk, Rst)
	begin
		if(Rst = '1') then
			Address_S1 <= (others => '0');
			WeightEn_AccLd_S1 <= '0';
			AFEn_OutputLd_S1 <= '0';
			InputBufferEn_S1 <= '0';
		elsif(Clk'event and Clk = '1') then
			if(PipeLineEn = '1') then
				Address_S1 <= Address;
				WeightEn_AccLd_S1 <= WeightEn_AccLd;
				AFEn_OutputLd_S1 <= AFEn_OutputLd;
				InputBufferEn_S1 <= InputBufferEn;
			end if;
		end if;
	end process;
END GateLevel;
