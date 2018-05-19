library ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE WORK.NewTypes.ALL;


ENTITY Input_Ram IS
    PORT(
        clka: IN STD_LOGIC;
        rsta: IN STD_LOGIC;
        ena: IN STD_LOGIC;
        wea: IN STD_LOGIC;
        addra: IN STD_LOGIC_VECTOR((LOGK - 1) DOWNTO 0);
        dina: IN WeightType;
        douta: OUT WeightType
    );
END Input_Ram;

ARCHITECTURE Behavioral OF Input_Ram IS
    signal RAM: NeuronWeightsType;
BEGIN
    process(clka)
    begin
        if clka'event and clka = '1' then
            if rsta = '1' then
                for i in (K - 1) downto 0 loop
                    RAM(i) <= (others => '0');
                end loop;
            elsif ena = '1' then
                if wea = '1' then
                    RAM(conv_integer(addra)) <= dina;
                end if;
                douta <= RAM(conv_integer(addra));
            end if;
        end if;
    end process;

END Behavioral;
