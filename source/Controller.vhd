--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.NewTypes.ALL;


--ENTITY
ENTITY Controller IS
	PORT(
		Clk: IN STD_LOGIC;
		Rst: IN STD_LOGIC;
		En: IN STD_LOGIC;
		InputReady: IN STD_LOGIC;
		PipeLineEn: OUT STD_LOGIC;
		AFEn_OutputLd: OUT STD_LOGIC;
		WeightEn_WRTEn_AccLd: OUT STD_LOGIC;
		CountEn_InputBufferEn: OUT STD_LOGIC;
		InputBufferWriteEn: OUT STD_LOGIC;
		CountDone: IN STD_LOGIC;
		S6OutputLd: IN STD_LOGIC;
		Done: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: BEHAVIORAL
ARCHITECTURE Behavioral OF Controller IS
	TYPE StateType IS (
		WaitForReady,	--Wait For InputReady to Become 1
		AdjustInputs,	--Load Input Array
		ReadyToCalculate,	--Nothing is Doing and Everything is Getting Ready for Calculation
		Calculation,	--All Signals are Active
		LDOutputs,		--Calculating outputs using Activation Function Unit
		WaitForFinish,	--Wait for Pipeline to Finish
		DoneFlag		--Done Flag should become 1 for 1 cycle
	);
	SIGNAL CurrentState, NextState: StateType;
BEGIN
	process(Clk) begin
		if(Rst = '1') then
			CurrentState <= WaitForReady;
		elsif(Clk'event and Clk = '1') then
			if(En = '1') then
				CurrentState <= NextState;
			end if;
		end if;
	end process;

	process(CurrentState, InputReady, CountDone, S6OutputLd) begin
		case CurrentState is
			when WaitForReady =>
				if (InputReady = '1') then
					NextState <= AdjustInputs;
				else
					NextState <= WaitForReady;
				end if;

			when AdjustInputs =>
				if (CountDone = '1') then
					NextState <= ReadyToCalculate;
				else
					NextState <= AdjustInputs;
				end if;

			when ReadyToCalculate =>
				NextState <= Calculation;

			when Calculation =>
				if (CountDone = '1') then
					NextState <= LDOutputs;
				else
					NextState <= Calculation;
				end if;

			when LDOutputs =>
				NextState <= WaitForFinish;

			when WaitForFinish =>
				if (S6OutputLd = '1') then
					NextState <= DoneFlag;
				else
					NextState <= WaitForFinish;
				end if;

			when DoneFlag =>
				NextState <= WaitForReady;

			when others =>
				NextState <= WaitForReady;
		end case;
	end process;

	process(CurrentState) begin
		AFEn_OutputLd <= '0';
		WeightEn_WRTEn_AccLd <= '0';
		CountEn_InputBufferEn <= '0';
		InputBufferWriteEn <= '0';
		Done <= '0';
		PipeLineEn <= '0';
		case CurrentState is
			when AdjustInputs =>
				InputBufferWriteEn <= '1';
				CountEn_InputBufferEn <= '1';

			when Calculation =>
				CountEn_InputBufferEn <= '1';
				--WRT Signals:
				WeightEn_WRTEn_AccLd <= '1';
				--Weight Signals:
				--Calc Signals:
				--Pipeline Enables
				PipeLineEn <= '1';

			when LDOutputs =>
				AFEn_OutputLd <= '1';
				PipeLineEn <= '1';

			when WaitForFinish =>
				PipeLineEn <= '1';

			when DoneFlag =>
				Done <= '1';

			when others =>
				PipeLineEn <= '0';
				AFEn_OutputLd <= '0';
				WeightEn_WRTEn_AccLd <= '0';
				CountEn_InputBufferEn <= '0';
				InputBufferWriteEn <= '0';
				Done <= '0';

		end case;
	end process;

END Behavioral;
