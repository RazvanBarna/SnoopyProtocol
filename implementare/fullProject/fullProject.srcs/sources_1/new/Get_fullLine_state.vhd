
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Get_fullLine_state is
  Port (clk,en : in std_logic;
        data_in : in std_logic_vector(65 downto 0);
        data_fromTable : in std_logic_vector(67 downto 0);
        data_toTable,DATA_FROMCC_TOTABLE_GET : out std_logic_vector(65 downto 0);
        data_out: out std_logic_vector(67 downto 0); 
            done_get,read_table : out std_logic;       
        done_read_table : in std_logic );
end Get_fullLine_state;

architecture Behavioral of Get_fullLine_state is

signal data_toTable_aux : std_logic_vector(65 downto 0) :=(others =>'0');
begin

DATA_FROMCC_TOTABLE_GET <= data_toTable_aux;
process(clk)
begin
  if rising_edge(clk) then
    read_table<='0';
    if en = '1' then
      data_toTable_aux <= data_in;  
      data_toTable <= data_in;
      read_table<='1';
    else
      data_toTable <= (others => '0');
    end if;
  end if;
end process;

process(clk)
begin
    if rising_edge(clk) then 
        done_get <='0';
        if done_read_table = '1' then
            data_out <= data_fromTable;
            done_get <='1';
        end if;
        end if;
end process;


end Behavioral;
