
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_main is
--  Port ( );
end tb_main;

architecture Behavioral of tb_main is

component main is
    Port(
         clk,btnRst,start: in std_logic;
         send_data_to_CCback: out std_logic_vector(63 downto 0);
         data_in_fifo_debug : out std_logic_vector(65 downto 0);
         out_toMuxCore0_debug,out_toMuxCore1_debug : out std_logic_vector(63 downto 0);
         line_mem_debug0, line_mem_debug1 : out std_logic_vector(63 downto 0);
         wr_ptr_out,rd_ptr_out : out std_logic_vector(4 downto 0);
         data_inFIFOFromTable_debug : out std_logic_vector(67 downto 0);
         data_fromTable_debug,data_in_fromCC_debug : out std_logic_vector(67 downto 0);
         original_line_debug, other_line_debug : out std_logic_vector(67 downto 0);
         full,empty,DONE,modify_state_out : out std_logic
         );
end component;

signal clk,btnRst,full,empty,start,DONE,modify_state_out : std_logic :='0';
signal send_data_to_CCback:  std_logic_vector(63 downto 0) :=(others =>'0');
signal out_toMuxCore0_debug,out_toMuxCore1_debug,line_mem_debug0, line_mem_debug1 :  std_logic_vector(63 downto 0):=(others =>'0');
signal wr_ptr_out,rd_ptr_out :  std_logic_vector(4 downto 0):=(others =>'0');
signal data_in_fifo_debug : std_logic_vector(65 downto 0) :=(others =>'0');
signal data_fromTable_debug,data_in_fromCC_debug,original_line_debug, other_line_debug,data_inFIFOFromTable_debug :  std_logic_vector(67 downto 0):=(others =>'0');

begin

C: main port map(
                clk => clk,btnRst => btnRst,
                start=>start,
                DONE=> DONE,
                modify_state_out=>modify_state_out,
                full => full,empty => empty,
                out_toMuxCore0_debug =>out_toMuxCore0_debug,out_toMuxCore1_debug => out_toMuxCore1_debug,
                line_mem_debug0 => line_mem_debug0, line_mem_debug1 => line_mem_debug1,
                original_line_debug=>original_line_debug,
                data_inFIFOFromTable_debug=>data_inFIFOFromTable_debug,
                other_line_debug=>other_line_debug,
                wr_ptr_out => wr_ptr_out,rd_ptr_out => rd_ptr_out,
                data_in_fromCC_debug=> data_in_fromCC_debug,
                data_in_fifo_debug=>data_in_fifo_debug,
                send_data_to_CCback => send_data_to_CCback,
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
              start <='0';
              wait for 90 ns;
              start <='0';
              wait for 20 ns;
              start <='0';
              wait for 200 ns;
              
              
              end process;


end Behavioral;
