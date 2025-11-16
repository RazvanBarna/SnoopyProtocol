
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_main is
--  Port ( );
end tb_main;

architecture Behavioral of tb_main is

component main is
    Port(
         clk,btnRst: in std_logic;
         send_data_to_CCback,line_toMain_debug: out std_logic_vector(63 downto 0);
         out_toMuxCore0_debug,out_toMuxCore1_debug : out std_logic_vector(65 downto 0);
         line_mem_debug0, line_mem_debug1 : out std_logic_vector(65 downto 0);
         wr_ptr_out,rd_ptr_out : out std_logic_vector(4 downto 0);
         data_fromTable_debug,data_in_fromCC_debug : out std_logic_vector(67 downto 0);
         full,empty,wb_0,write_enMain_aux,wb_table_degbug : out std_logic
         );


end component;

signal clk,btnRst,full,empty,wb0,write_enMain_aux,wb_table_degbug : std_logic :='0';
signal send_data_to_CCback,line_toMain_debug:  std_logic_vector(63 downto 0) :=(others =>'0');
signal out_toMuxCore0_debug,out_toMuxCore1_debug,line_mem_debug0, line_mem_debug1 :  std_logic_vector(65 downto 0):=(others =>'0');
signal wr_ptr_out,rd_ptr_out :  std_logic_vector(4 downto 0):=(others =>'0');
signal data_fromTable_debug,data_in_fromCC_debug :  std_logic_vector(67 downto 0):=(others =>'0');

begin

C: main port map(
                clk => clk,btnRst => btnRst,
                full => full,empty => empty,
                out_toMuxCore0_debug =>out_toMuxCore0_debug,out_toMuxCore1_debug => out_toMuxCore1_debug,
                line_mem_debug0 => line_mem_debug0, line_mem_debug1 => line_mem_debug1,
                wr_ptr_out => wr_ptr_out,rd_ptr_out => rd_ptr_out,
                write_enMain_aux=>write_enMain_aux,
                data_in_fromCC_debug=> data_in_fromCC_debug,
                wb_table_degbug=> wb_table_degbug,
                line_toMain_debug => line_toMain_debug,
                send_data_to_CCback => send_data_to_CCback,
                wb_0=>wb0,
                data_fromTable_debug => data_fromTable_debug);
                
                
                
clk_process: process
            begin
            clk <='0';
            wait for 10 ns;
            clk <='1';
            wait for 10 ns;   
            end process;
            
            
test_process: process
              begin
              --testez doar un core care citeste ceva si initial in mem e M(il fac S), core 0 face, citire , scriere , simple , de un core , merg
              wait for 60 ns;
              
              end process;


end Behavioral;
