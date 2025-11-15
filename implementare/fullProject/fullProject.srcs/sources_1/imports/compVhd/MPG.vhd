
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( btn,sw : in STD_LOGIC;
           clk : in STD_LOGIC;
           num_out : out std_logic_vector(7 downto 0));
end MPG;

architecture Behavioral of MPG is

signal cnt_int : STD_LOGIC_VECTOR(17 downto 0) := (others => '0');
signal Q1, Q2, Q3 : STD_LOGIC;
signal enable: std_logic :='0';
signal num_aux: std_logic_vector(2 downto 0) :=(others =>'0');

begin

    enable <= Q2 and (not Q3);

    process(clk)
    begin
        if clk='1' and clk'event then
            cnt_int <= cnt_int + 1;
        end if;
    end process;

    process(clk)
    begin
        if clk'event and clk='1' then
            if cnt_int(17 downto 0) = "111111111111111111" then
                Q1 <= btn;
            end if;
        end if;
    end process;

    process(clk)
    begin
        if clk'event and clk='1' then
            Q2 <= Q1;
            Q3 <= Q2;
        end if;
    end process;
    
    process(clk)
    variable nr: std_logic_vector(2 downto 0) :=(others =>'0');
    begin
    if rising_edge(clk) then 
        if enable='1' then 
            if sw='0' then nr:=nr+1;
            else nr:=nr-1;
            end if;
            end if;
            end if;
            num_aux<=nr;
            end process;
            
     process(num_aux)
     begin 
     case num_aux is 
            when "000" => num_out<="00000001";
            when "001" => num_out<="00000010";
            when "010" => num_out<="00000100";
            when "011" => num_out<="00001000";
            when "100" => num_out<="00010000";
            when "101" => num_out<="00100000";
            when "110" => num_out<="01000000";
            when others =>num_out<="10000000";
            end case;
            end process;
            
end Behavioral;