
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_UC_mem is
  Port (
         data_inFIFO : in std_logic_vector(67 downto 0);
         data_toCore0,data_toCore1,data_fromTable_debug : out std_logic_vector(67 downto 0);
         clk,new_fifo: in std_logic;
         wb_toCore0, wb_toCore1,wb_table_debug,wb_TOtable_debug : out std_logic;
         send_data_to_CCback: out std_logic_vector(63 downto 0)
         );
end test_UC_mem;

architecture Behavioral of test_UC_mem is

component MainMem is
  Port (dataIn : in std_logic_vector(63 downto 0);
        write_enMain : in std_logic;
        clk : in std_logic;
        send_data_to_CCback: out std_logic_vector(63 downto 0));
end component;


component UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(67 downto 0);
        data_toCore0,data_toCore1,data_fromTable_debug : out std_logic_vector(67 downto 0); --67 , scriu in daca trb ; id 1 bit , read/write type 1 bit , state 2 biti , tag 22 , index 6 , offset 4 , data 32 biti
        clk,new_fifo: in std_logic;
        wb_toCore0, wb_toCore1,wb_table_debug,wb_TOtable_debug : out std_logic;
        write_enMain : out std_logic;
        line_toMain : out std_logic_vector(63 downto 0)
        );
end component;

signal write_enMain_aux : std_logic :='0';
signal line_toMain :  std_logic_vector(63 downto 0);

begin

C1: UC_Snoopy port map(
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
                    write_enMain => write_enMain_aux,
                    line_toMain => line_toMain);
                    
C2: MainMem port map(
                    dataIn =>line_toMain,
                    clk => clk,
                    write_enMain => write_enMain_aux,
                    send_data_to_CCback => send_data_to_CCback );

end Behavioral;
