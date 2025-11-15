
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_UC_Mem is
--  Port ( );
end tb_UC_Mem;

architecture Behavioral of tb_UC_Mem is

component test_UC_mem is
  Port (
         data_inFIFO : in std_logic_vector(67 downto 0);
         data_toCore0,data_toCore1,data_fromTable_debug : out std_logic_vector(67 downto 0);
         clk,new_fifo: in std_logic;
         wb_toCore0, wb_toCore1,wb_table_debug,wb_TOtable_debug : out std_logic;
         send_data_to_CCback: out std_logic_vector(63 downto 0)
         );
end component;

signal data_inFIFO,data_toCore0,data_toCore1,data_fromTable_debug :  std_logic_vector(67 downto 0) :=(others =>'0');
signal send_data_to_CCback: std_logic_vector(63 downto 0 ) :=(others =>'0');
signal wb_toCore0, wb_toCore1,wb_table_debug,wb_TOtable_debug,clk,new_fifo :std_logic := '0';

begin

C1: test_UC_mem port map(
                         data_inFIFO => data_inFIFO,
                         data_toCore0 => data_toCore0,
                         data_toCore1 => data_toCore1,
                         data_fromTable_debug => data_fromTable_debug,
                         clk => clk,
                         new_fifo => new_fifo,
                         wb_toCore0 => wb_toCore0,
                         wb_toCore1 => wb_toCore1,
                         wb_table_debug => wb_table_debug,
                         wb_TOtable_debug => wb_TOtable_debug,
                         send_data_to_CCback => send_data_to_CCback ); 
                         
clk_process: process 
     begin
     clk <='1';
     wait for 10 ns;
     clk <='0';
     wait for 10 ns;
     end process;
     
     
test_process: process
              begin
              
              data_inFIFO <= "0"&"0" &"00"& "0000" &X"1001" & "00" & "000010" & "0001" & X"08888111"; -- citeste SS , ar trb sa fie data to core 
              new_fifo<='1';
              wait for 20 ns;
              new_fifo <= '0';
              wait for 60 ns;
              
              new_fifo <= '1';
              data_inFIFO <= "0"&"1" &"00"& "0000" &X"1001" & "00" & "000010" & "0001" & X"38822111"; -- scrie si initial e S , deci ar trb M 
              wait for 20 ns;
              new_fifo <= '0';
              wait for 60 ns;
              
              new_fifo <= '1';
              data_inFIFO <= "0"&"0" &"11"& "0000" &X"1001" & "00" & "000010" & "0001" & X"00AAA111";
              wait for 20 ns;
              new_fifo <= '0';
              wait for 60 ns;
              
              
              end process;


end Behavioral;
