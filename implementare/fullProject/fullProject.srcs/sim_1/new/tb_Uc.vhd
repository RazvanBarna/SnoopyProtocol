
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_Uc is
--  Port ( );
end tb_Uc;

architecture Behavioral of tb_Uc is
component UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(67 downto 0);
        data_toCore0,data_toCore1,data_fromTable_debug : out std_logic_vector(67 downto 0); --67 , scriu in daca trb ; id 1 bit , read/write type 1 bit , state 2 biti , tag 22 , index 6 , offset 4 , data 32 biti
        clk,new_fifo: in std_logic;
        wb_toCore0, wb_toCore1,wb_table_debug,wb_TOtable_debug : out std_logic;
        readWriteCC_toMain : out std_logic;
        line_toMain : out std_logic_vector(63 downto 0)
        );
end component;

signal readWriteCC_toMain,new_fifo,wb_table_debug,wb_TOtable_debug,wb_toCore0, wb_toCore1,clk : std_logic :='0';
signal data_toCore0,data_toCore1,data_fromTable_debug,data_inFIFO : std_logic_vector(67 downto 0) :=(others =>'0');
signal line_toMain: std_logic_vector(63 downto 0 ) :=(others =>'0');

begin

C1: UC_Snoopy port map(
            readWriteCC_toMain => readWriteCC_toMain,
            new_fifo=> new_fifo,
            wb_table_debug => wb_table_debug,
            wb_TOtable_debug => wb_TOtable_debug,
            wb_toCore0=> wb_toCore0,
             wb_toCore1=> wb_toCore1,
             clk => clk,line_toMain=> line_toMain,
             data_toCore0 => data_toCore0,
             data_toCore1 => data_toCore1,
             data_fromTable_debug => data_fromTable_debug,
             data_inFIFO => data_inFIFO );


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
