library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

USE WORK.NewTypes.ALL;

ENTITY ActivationFunctionArray IS
	port(
		Clk: IN STD_LOGIC;
		Rst: IN STD_LOGIC;
		D: IN InputWeightType;
		AFEn: IN STD_LOGIC;
		Q: OUT InputWeightType
	);
END ActivationFunctionArray;

ARCHITECTURE Behavioral OF ActivationFunctionArray IS
BEGIN
	ACTIVATIONFUNCTIONS: for index in (N - 1) downto 0 generate
	begin
		ACTIVATIONFUNCTION: ENTITY WORK.ActivationFunction(Behavioral) port map(
			Clk => Clk,
			Rst => Rst,
			D => D(index),
			AFEn => AFEn,
			Q => Q(index)
		);
	end generate;
END Behavioral;
