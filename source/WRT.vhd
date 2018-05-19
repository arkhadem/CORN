library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE WORK.NewTypes.ALL;

ENTITY WRT IS
    PORT(
        Clk : IN STD_LOGIC;
		Rst : IN STD_LOGIC;
        En : IN STD_LOGIC;
        ADDR : IN  STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0);
        DATA : out DecodedSelectorsType
    );
END WRT;

architecture Behavioral of WRT is
    type rom_type is array ((K - 1) downto 0) of DecodedSelectorType;
    type array_rom_type is array (0 to (N - 1)) of rom_type;
    SIGNAL ROM: array_rom_type;
    SIGNAL rdata: DecodedSelectorsType;
begin
    process (Clk)
    begin
        if (Clk'event and Clk = '1') then
            if (Rst = '1') then
				ROM <= (
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001"),
					("00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001", "00000001")
				);
	    	end if;
		end if;
    end process;
    SINKS: for index in (N - 1) downto 0 generate
	begin
		SINK: rdata(index) <= ROM(index)(conv_integer(ADDR));
	end generate;

    process (Clk)
    begin
        if (Clk'event and Clk = '1') then
            if (En = '1') then
                for index in (N - 1) downto 0 loop
                    DATA(index) <= rdata(index);
                end loop;
            end if;
        end if;
    end process;

end Behavioral;
