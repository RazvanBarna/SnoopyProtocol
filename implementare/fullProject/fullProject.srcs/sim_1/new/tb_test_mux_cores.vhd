library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_test_mux_cores is
--  Port ( );
end tb_test_mux_cores;

architecture Behavioral of tb_test_mux_cores is

component test_fifo_mux_cores is
  Port (clk,btnRst,wb0,wb1,rd,wr,wr_inc, rd_inc: in std_logic;
        data_fromCC0, data_fromCC1 : in std_logic_vector(65 downto 0);
        data_out,out_test : out std_logic_vector(67 downto 0);
        wr_ptr,rd_ptr : out std_logic_vector(4 downto 0);
        debug0,debug1,line_debug0,line_debug1 : out std_logic_vector(65 downto 0);
        empty, full : out std_logic);
end component;

signal clk,btnRst,wb0,wb1,rd,wr,wr_inc,rd_inc,empty, full : std_logic :='0';
signal  wr_ptr,rd_ptr :  std_logic_vector(4 downto 0) :=(others =>'0') ;
signal data_fromCC0,data_fromCC1,debug0,debug1,line_debug0,line_debug1 : std_logic_vector(65 downto 0) :=(others =>'0');
signal data_out,out_test : std_logic_vector(67 downto 0);

begin

C1: test_fifo_mux_cores port map (
                    clk => clk, btnRst => btnRst, wb0 =>wb0,wb1 => wb1, rd =>rd,wr => wr, wr_inc => wr_inc , rd_inc => rd_inc,
                    empty => empty, full => full,
                    data_fromCC0 => data_fromCC0, data_fromCC1 =>data_fromCC1,
                    data_out => data_out, out_test => out_test,
                    wr_ptr=>wr_ptr,rd_ptr=>rd_ptr,
                    debug0 => debug0 , debug1 => debug1,line_debug0 => line_debug0 , line_debug1 => line_debug1
                    );
                    
 clk_process : process 
            begin
                clk <='0';
                wait for 5 ns;
                clk <='1';
                wait for 5 ns;
            end process;
            
  sim_process: process
            begin
           --primul test : core 0 citeste si e invalid si core 1 scrie si e S , sa vad ca se trimit ambele cereri
           wb0 <='1';
           wr<='1';
           wr_inc<='1';
           data_fromCC0 <= "10"& "0000" &X"9877" & "10" & "000100" & "0000" & X"02221111";
           -- al doilea scrie
           wait for 10 ns;
           wb1<='0';
           wb0<='0';
           wait for 5 ns;
           rd <='1';
           wb1<='0';
           wb0<='0';
           rd_inc <='1';
           wr_inc <='0';
           wait for 5 ns;
           
           
           
           
                 
                
--                --PROBLEMA MINORA : DACA WR PTR E FULL SE DA PESTE CAP , NU CRED CA ARE CUM IN CONTEXTUL ACTUAL
--                -- e 10 inceput in data out ca se tot concatenaza...
                
            end process;
                  


end Behavioral;
