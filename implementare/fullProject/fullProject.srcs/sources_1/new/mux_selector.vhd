

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_selector is
  Port (id_0, id_1,readWrite_type0,readWrite_type1 : in std_logic;
        data_in0,data_in1: in std_logic_vector(65 downto 0);
        useCC0,clk, useCC1 : in std_logic;
        wr_fifo: out std_logic;
        data_out_toCC: out std_logic_vector(67 downto 0));
end mux_selector;

architecture Behavioral of mux_selector is

signal data_total_aux0, data_total_aux1 : std_logic_vector(67 downto 0);
signal turn : std_logic := '0';   -- round robin state

signal sel : std_logic;  -- cine este selectat final

begin

data_total_aux0 <= id_0 & readWrite_type0 & data_in0;
data_total_aux1 <= id_1 & readWrite_type1 & data_in1;

process(clk)
begin
    if rising_edge(clk) then
            if useCC0 = '1' and useCC1 = '1' then
                turn <= not turn;
            else
                turn <= turn;
        end if;
            if (useCC0 = '1' or useCC1 = '1') then
            wr_fifo <= '1';
        else
            wr_fifo <= '0';
        end if;
    end if;
end process;


sel <= '0' when (useCC0='1' and useCC1='0') else     -- doar 0
        '1' when (useCC1='1' and useCC0='0') else     -- doar 1
        turn when (useCC0='1' and useCC1='1') else    -- ambele 
        '0';                                          -- nimeni

data_out_toCC <= data_total_aux0 when sel='0' else data_total_aux1;

end Behavioral;
