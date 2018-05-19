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
		WeightEn: OUT STD_LOGIC;
		AFEn: OUT STD_LOGIC;
		WRTEn: OUT STD_LOGIC;
		AccLd: OUT STD_LOGIC;
		CountEn: OUT STD_LOGIC;
		InputBufferEn: OUT STD_LOGIC;
		OutputLd: OUT STD_LOGIC;
		InputBufferWriteEn: OUT STD_LOGIC;
		CountDone: IN STD_LOGIC;
		Done: OUT STD_LOGIC
	);
END ENTITY;

--ARCHITECTURE 1: BEHAVIORAL
ARCHITECTURE Behavioral OF Controller IS
	TYPE StateType IS (
		WaitForReady,	--Wait For InputReady to Become 1
		AdjustInputs,	--Load Input Array
		ReadyToCalculate,	--Nothing is Doing and Everything is Getting Ready for Calculation
		Start1,	--WRT Signals are Active
		Start2,	--WRT and Weight Signals are Active
		MidCalculation,	--WRT, Weight and Calc Signals are Active
		Finish1,	--Weight and Calc Signals are Active
		Finish2,	--Calc Signals are Active
		LDOutputs,		--Calculating outputs using Activation Function Unit
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

	process(CurrentState, InputReady, CountDone) begin
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
				NextState <= Start1;

			when Start1 =>
				NextState <= Start2;

			when Start2 =>
				NextState <= MidCalculation;

			when MidCalculation =>
				if (CountDone = '1') then
					NextState <= Finish1;
				else
					NextState <= MidCalculation;
				end if;

			when Finish1 =>
				NextState <= Finish2;

			when Finish2 =>
				NextState <= LDOutputs;

			when LDOutputs =>
				NextState <= DoneFlag;

			when DoneFlag =>
				NextState <= WaitForReady;

			when others =>
				NextState <= WaitForReady;
		end case;
	end process;

	process(CurrentState) begin
		WeightEn <= '0';
		AFEn <= '0';
		WRTEn <= '0';
		AccLd <= '0';
		CountEn <= '0';
		InputBufferEn <= '0';
		OutputLd <= '0';
		InputBufferWriteEn <= '0';
		Done <= '0';
		case CurrentState is
			when AdjustInputs =>
				InputBufferWriteEn <= '1';
				CountEn <= '1';
				InputBufferEn <= '1';

			when Start1 =>
				--WRT Signals:
				CountEn <= '1';
				WRTEn <= '1';

			when Start2 =>
				--WRT Signals:
				CountEn <= '1';
				WRTEn <= '1';
				--Weight Signals:
				CountEn <= '1';
				InputBufferEn <= '1';
				WeightEn <= '1';

			when MidCalculation =>
				--WRT Signals:
				CountEn <= '1';
				WRTEn <= '1';
				--Weight Signals:
				CountEn <= '1';
				InputBufferEn <= '1';
				WeightEn <= '1';
				--Calc Signals:
				CountEn <= '1';
				AccLd <= '1';

			when Finish1 =>
				--Weight Signals:
				CountEn <= '1';
				InputBufferEn <= '1';
				WeightEn <= '1';
				--Calc Signals:
				CountEn <= '1';
				AccLd <= '1';

			when Finish2 =>
				--Calc Signals:
				CountEn <= '1';
				AccLd <= '1';

			when LDOutputs =>
				AFEn <= '1';
				OutputLd <= '1';

			when DoneFlag =>
				Done <= '1';

			when others =>
				WeightEn <= '0';
				AFEn <= '0';
				WRTEn <= '0';
				AccLd <= '0';
				CountEn <= '0';
				InputBufferEn <= '0';
				OutputLd <= '0';
				InputBufferWriteEn <= '0';
				Done <= '0';

		end case;
	end process;

END Behavioral;
