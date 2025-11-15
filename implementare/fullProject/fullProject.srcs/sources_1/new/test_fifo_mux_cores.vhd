
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_fifo_mux_cores is
  Port (clk,btnRst,wb0,wb1,rd,wr,wr_inc, rd_inc: in std_logic;
        data_fromCC0, data_fromCC1 : in std_logic_vector(65 downto 0);
        data_out,out_test : out std_logic_vector(67 downto 0);
        wr_ptr,rd_ptr : out std_logic_vector(4 downto 0);
        debug0,debug1,line_debug0,line_debug1 : out std_logic_vector(65 downto 0);
        empty, full : out std_logic);
end entity;

architecture Behavioral of test_fifo_mux_cores is

component Core1 is
  Port (clk,btnRst,wb,core_id_in: in std_logic; --core id e in ca sa il setez eu
        data_fromCC : in std_logic_vector(65 downto 0);
        readWriteCC,core_id_out,useCC: out std_logic;
        send_data_to_bus,debug,line_debug : out std_logic_vector(65 downto 0)        
        );
end  component;

component Core0 is
  Port (clk,btnRst,wb,core_id_in: in std_logic; --core id e in ca sa il setez eu
        data_fromCC : in std_logic_vector(65 downto 0);
        readWriteCC,core_id_out,useCC: out std_logic;
        send_data_to_bus,debug,line_debug : out std_logic_vector(65 downto 0)        
        );
end component;

component mux_selector is
  Port (id_0, id_1,readWrite_type0,readWrite_type1 : in std_logic;
        data_in0,data_in1: in std_logic_vector(65 downto 0);
        useCC0,useCC1 : in std_logic;
        data_out_toCC: out std_logic_vector(67 downto 0));
end component;

    
    component fifo_connectCores is
      Port (
            rd, wr, wr_inc, rd_inc, rst, clk : in std_logic;
            data_in   : in std_logic_vector(67 downto 0);
            full, empty : out std_logic;
            data_out : out std_logic_vector(67 downto 0);
            wr_ptr_out,rd_ptr_out : out std_logic_vector(4 downto 0);
            out_test :out std_logic_vector(67 downto 0)
             );
    end component;


signal out_mux : std_logic_vector(67 downto 0) :=(others =>'0');
signal send_data_to_bus0,send_data_to_bus1 : std_logic_vector(65 downto 0) :=(others =>'0');
signal line_index0,line_index1: std_logic_vector(5 downto 0) :=(others =>'0');
signal core_id_out0,core_id_out1,readWriteCC0,readWriteCC1,useCC0,useCC1 : std_logic :='0';
begin

C0: Core0 port map(
            clk =>clk,
            core_id_in => '0',
            btnRst => btnRst,
            wb =>wb0,
            line_debug => line_debug0,
            data_fromCC => data_fromCC0,
            readWriteCC => readWriteCC0,
            core_id_out => core_id_out0,
            useCC => useCC0,
            debug => debug0,
            send_data_to_bus => send_data_to_bus0);
            
C1: Core1 port map(
            clk =>clk,
            core_id_in => '1',
            btnRst => btnRst,
            wb =>wb1,
            line_debug => line_debug1,
            data_fromCC => data_fromCC1,
            readWriteCC => readWriteCC1,
            core_id_out => core_id_out1,
            useCC => useCC1,
            debug => debug1,
            send_data_to_bus => send_data_to_bus1);
            
 Mux: mux_selector port map(
                id_0 =>core_id_out0 , 
                id_1 =>core_id_out1,
                readWrite_type0 =>readWriteCC0,
                readWrite_type1=> readWriteCC1,
                data_in0 => send_data_to_bus0,
                data_in1 => send_data_to_bus1,
                useCC0 => useCC0,
                useCC1 => useCC1, 
                data_out_toCC => out_mux );

fifo : fifo_connectCores port map(
            rd =>rd,
            wr => wr,
            wr_inc => wr_inc,
            rd_inc => rd_inc,
            rst => btnRst,
            clk =>clk,
            wr_ptr_out => wr_ptr,
            rd_ptr_out => rd_ptr,
            data_in => out_mux,
            full => full,
            out_test => out_test,
            empty => empty,
            data_out=> data_out );

end Behavioral;
