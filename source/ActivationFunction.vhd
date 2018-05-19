library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

USE WORK.NewTypes.ALL;

ENTITY ActivationFunction IS
	port(
		Clk: IN STD_LOGIC;
		Rst: IN STD_LOGIC;
		D: IN WeightType;
		AFEn: IN STD_LOGIC;
		Q: OUT WeightType
	);
END ActivationFunction;

ARCHITECTURE Behavioral OF ActivationFunction IS
	SIGNAL YCell: AFOutCellType;
begin
	process(Clk)
	begin
		if(Clk'event and Clk = '1') then
			if(Rst = '1') then
				YCell <= (
                    "0000000000000000",
                    "0000000000000001",
                    "0000000000000011",
                    "0000000000000101",
                    "0000000000000111",
                    "0000000000001001",
                    "0000000000001011",
                    "0000000000001101",
                    "0000000000001111",
                    "0000000000010001",
                    "0000000000010011",
                    "0000000000010101",
                    "0000000000010110",
                    "0000000000011000",
                    "0000000000011010",
                    "0000000000011011",
                    "0000000000011101",
                    "0000000000011111",
                    "0000000000100000",
                    "0000000000100010",
                    "0000000000100011",
                    "0000000000100100",
                    "0000000000100110",
                    "0000000000100111",
                    "0000000000101000",
                    "0000000000101001",
                    "0000000000101010",
                    "0000000000101100",
                    "0000000000101101",
                    "0000000000101110",
                    "0000000000101110",
                    "0000000000101111",
                    "0000000000110000",
                    "0000000000110001",
                    "0000000000110010",
                    "0000000000110011",
                    "0000000000110011",
                    "0000000000110100",
                    "0000000000110101",
                    "0000000000110101",
                    "0000000000110110",
                    "0000000000110110",
                    "0000000000110111",
                    "0000000000110111",
                    "0000000000111000",
                    "0000000000111000",
                    "0000000000111001",
                    "0000000000111001",
                    "0000000000111001",
                    "0000000000111010",
                    "0000000000111010",
                    "0000000000111010",
                    "0000000000111011",
                    "0000000000111011",
                    "0000000000111011",
                    "0000000000111100",
                    "0000000000111100",
                    "0000000000111100",
                    "0000000000111100",
                    "0000000000111100",
                    "0000000000111101",
                    "0000000000111101",
                    "0000000000111101",
                    "0000000000111101",
                    "0000000000111101",
                    "0000000000111101",
                    "0000000000111101",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111110",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111",
                    "0000000000111111"
        		);
			end if;
		end if;
	end process;

	process(AFEn, D)
		variable intemp, outtemp: std_logic_vector(15 downto 0);
	begin
		if(AFEn = '1')then
			intemp := "0000000000000000";			if(D(I + M - 1) = '1') then				intemp := not(TO_Std_Logic_Vector(D)) + '1';			else				intemp := TO_Std_Logic_Vector(D);
			end if;
			if(intemp >= "0001000000000000") then
				if(D(I + M - 1) = '1') then
					Q <= "1111100000000000";
				else
					Q <= "0000010000000000";
				end if;
			else
				if(D(I + M - 1) = '1') then
					outtemp := not(YCell(conv_integer(intemp(11 downto 5)))) + "1";
				else
					outtemp := YCell(conv_integer(intemp(11 downto 5)));
				end if;
				for counter in 0 to 15 loop
					Q(counter) <= outtemp(counter);
				end loop;
			end if;
		end if;
	end process;
END Behavioral;
