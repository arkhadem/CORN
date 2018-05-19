--LIBRARIES
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.all;
USE WORK.NewTypes.ALL;


--ENTITY
ENTITY Counter IS
	PORT(
		Clk, Rst, CountEn: IN STD_LOGIC;
		CountDone: OUT STD_LOGIC;
		Q_WRT, Q_Weight: OUT STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0)
	);
END ENTITY;

--ARCHITECTURE 1: Behavioral
ARCHITECTURE Behavioral OF Counter IS
	SIGNAL Counter_Encoded, Counter_Encoded_1: STD_LOGIC_VECTOR(LOGK DOWNTO 0);
BEGIN
	process(Clk) begin
		if(Clk'event and Clk = '1') then
			if(Rst = '1') then
				Counter_Encoded <= (others => '0');
			else
				if(CountEn = '1') then
					Counter_Encoded <= Counter_Encoded + 1;
				else
					Counter_Encoded <= (others => '0');
				end if;
			end if;
		end if;
	end process;
	Q_WRT <= Counter_Encoded((LOGK - 1) downto 0);
	Counter_Encoded_1 <= Counter_Encoded - '1';
	Q_Weight <= Counter_Encoded_1((LOGK - 1) downto 0);
	CountDone <= '1' when (Counter_Encoded = K - 1) else '0';
END Behavioral;
