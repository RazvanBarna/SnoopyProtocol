library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity main is
    Port(
         clk,btnRst: in std_logic;
         send_data_to_CCback: out std_logic_vector(63 downto 0);
         out_toMuxCore0_debug,out_toMuxCore1_debug : out std_logic_vector(65 downto 0);
         line_mem_debug0, line_mem_debug1 : out std_logic_vector(65 downto 0);
         wr_ptr_out,rd_ptr_out : out std_logic_vector(4 downto 0);
         data_fromTable_debug : out std_logic_vector(67 downto 0);
         full,empty : out std_logic
         );


end entity;




architecture arhi_main of main is 

component Core0 is
  Port (clk,btnRst,wb,core_id_in,next_instr_core0: in std_logic;
        data_fromCC : in std_logic_vector(65 downto 0);
        readWriteCC,core_id_out,useCC: out std_logic;
        send_data_to_bus,debug,line_debug : out std_logic_vector(65 downto 0)        
        );
end component;

component Core1 is
  Port (clk,btnRst,wb,core_id_in,next_instr_core1: in std_logic; --core id e in ca sa il setez eu
        data_fromCC : in std_logic_vector(65 downto 0);
        readWriteCC,core_id_out,useCC: out std_logic;
        send_data_to_bus,debug,line_debug : out std_logic_vector(65 downto 0)        
        );
end component;


component mux_selector is
  Port (id_0, id_1,readWrite_type0,readWrite_type1 : in std_logic;
        data_in0,data_in1: in std_logic_vector(65 downto 0);
        useCC0,clk, useCC1 : in std_logic;
        wr_fifo: out std_logic;
        data_out_toCC: out std_logic_vector(67 downto 0));
end component;

component fifo_connectCores is
      Port (
            rd, wr, wr_inc, rd_inc, rst, clk : in std_logic;
            data_in   : in std_logic_vector(67 downto 0);
            full, empty,new_fifo : out std_logic;
            data_out : out std_logic_vector(67 downto 0);
            wr_ptr_out,rd_ptr_out : out std_logic_vector(4 downto 0)
             );
end component;

component UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(67 downto 0);
        data_toCore0,data_toCore1,data_fromTable_debug : out std_logic_vector(67 downto 0); --67 , scriu in daca trb ; id 1 bit , read/write type 1 bit , state 2 biti , tag 22 , index 6 , offset 4 , data 32 biti
        clk,new_fifo: in std_logic;
        wb_toCore0, wb_toCore1 : out std_logic;
        write_enMain,next_instr_core0, next_instr_core1,rd_fifo : out std_logic;
        line_toMain : out std_logic_vector(63 downto 0)
        );
end component;

component MainMem is
  Port (dataIn : in std_logic_vector(63 downto 0);
        write_enMain : in std_logic;
        clk : in std_logic;
        send_data_to_CCback: out std_logic_vector(63 downto 0));
end component;

signal wb0,wb1,next_instr_core0,next_instr_core1,readWriteCC0, readWriteCC1,core_id0_out,core_id1_out,useCC0,useCC1,new_fifo,wr_fifo,rd_fifo,write_enMain : std_logic :='0';
signal data_fromCC0,data_fromCC1,data_out_toCC, data_out_toCC_fromFIFO : std_logic_vector(67 downto 0) := (others =>'0');
signal send_data_to_bus0, send_data_to_bus1 : std_logic_vector(65 downto 0) :=(others =>'0');
signal data_toMain : std_logic_vector(63 downto 0) :=(others =>'0');

begin

Core_0: Core0 port map(
                        clk =>clk,
                        btnRst => btnRst,
                        wb => wb0,
                        core_id_in => '0',
                        next_instr_core0 => next_instr_core0,
                        data_fromCC =>data_fromCC0(65 downto 0),
                        readWriteCC => readWriteCC0,
                        core_id_out => core_id0_out,
                        useCC => useCC0,
                        send_data_to_bus => send_data_to_bus0,
                        debug =>out_toMuxCore0_debug,
                        line_debug =>line_mem_debug0 ) ;
                        
Core_1: Core1 port map(
                        clk =>clk,
                        btnRst => btnRst,
                        wb => wb1,
                        core_id_in => '1',
                        next_instr_core1 => next_instr_core1,
                        data_fromCC =>data_fromCC1(65 downto 0),
                        readWriteCC => readWriteCC1,
                        core_id_out => core_id0_out,
                        useCC => useCC1,
                        send_data_to_bus => send_data_to_bus1,
                        debug =>out_toMuxCore1_debug,
                        line_debug =>line_mem_debug1 ) ;
                        
                        
switch_mux : mux_selector port map(
                                   clk => clk,
                                   id_0 =>core_id0_out,
                                   id_1 =>core_id1_out,
                                   readWrite_type0 => readWriteCC0,
                                   readWrite_type1 => readWriteCC1,
                                   data_in0 =>send_data_to_bus0,
                                   data_in1 => send_data_to_bus1,
                                   useCC0 => useCC0,
                                   useCC1 => useCC1,
                                   wr_fifo => wr_fifo,
                                   data_out_toCC => data_out_toCC
                                    );
                                    
fifo_connect_mux_cc: fifo_connectCores port map(
                                                clk => clk,
                                                rd => rd_fifo,
                                                wr => wr_fifo,
                                                wr_inc => wr_fifo,
                                                rd_inc => rd_fifo,
                                                rst => btnRst,
                                                data_in =>data_out_toCC,
                                                full => full,
                                                empty => empty,
                                                new_fifo => new_fifo,
                                                data_out => data_out_toCC_fromFIFO,
                                                wr_ptr_out => wr_ptr_out,
                                                rd_ptr_out => rd_ptr_out
                                                 );

snoopy_cc : UC_Snoopy port map(
                                data_inFIFO => data_out_toCC_fromFIFO,
                                data_toCore0 =>data_fromCC0 ,
                                data_toCore1 => data_fromCC1,
                                data_fromTable_debug => data_fromTable_debug,
                                clk => clk,new_fifo => new_fifo,
                                wb_toCore0 => wb0,
                                wb_toCore1 => wb1,
                                write_enMain => write_enMain,
                                next_instr_core0 =>next_instr_core0,
                                next_instr_core1 => next_instr_core1,
                                rd_fifo => rd_fifo,
                                line_toMain => data_toMain
                               );

MainMem_C: MainMem port map(
                            dataIn => data_toMain,
                            write_enMain => write_enMain,
                            clk => clk,
                            send_data_to_CCback => send_data_to_CCback
                            );
                            
                            
end architecture;
