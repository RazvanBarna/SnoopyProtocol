library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_test_mux_cores is
--  Port ( );
end tb_test_mux_cores;

architecture Behavioral of tb_test_mux_cores is

component test_fifo_mux_cores is
  Port (clk,btnRst,rd_andInc,next_instr_core0,next_instr_core1: in std_logic;
        data_out,out_test : out std_logic_vector(67 downto 0);
        wr_ptr,rd_ptr : out std_logic_vector(4 downto 0);
        debug0_outCore,debug1_outCOre,line_debug0_mem,line_debug1_mem : out std_logic_vector(65 downto 0);
        empty, full,new_fifo : out std_logic);
end component;

signal clk,btnRst,rd_andInc,empty, full,next_instr_core0,next_instr_core1 : std_logic :='0';
signal  wr_ptr,rd_ptr :  std_logic_vector(4 downto 0) :=(others =>'0') ;
signal debug0_outCore,debug1_outCore,line_debug0_mem,line_debug1_mem : std_logic_vector(65 downto 0) :=(others =>'0');
signal data_out,out_test : std_logic_vector(67 downto 0);

begin

C1: test_fifo_mux_cores port map (
                    clk => clk, btnRst => btnRst, rd_andInc =>rd_andInc,
                    next_instr_core0 => next_instr_core0, next_instr_core1 => next_instr_core1,
                    empty => empty, full => full,
                    data_out => data_out, out_test => out_test,
                    wr_ptr=>wr_ptr,rd_ptr=>rd_ptr,
                    debug0_outCore => debug0_outCore , debug1_outCore => debug1_outCore,line_debug0_mem => line_debug0_mem , line_debug1_mem => line_debug1_mem
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
           --primul test :core 0 citeste , al doilea face altcv
--           wb0 <='0';
--           rd<='0';
--           rd_inc <='0';
--           wr<='1';
--           wr_inc<='1';
--           data_fromCC0 <= "10"& "0000" &X"9877" & "10" & "000100" & "0000" & X"02221111";
--           -- al doilea scrie
--           wait for 10 ns;
--           wr<='0';
--           wr_inc <='0';
--           rd<='1';
--           rd_inc <='1';
--           wait for 10 ns; --citesc instructiunea

-- primul scrie , al doilea citeste
           next_instr_core0 <= '0';
           next_instr_core1 <= '0';
           rd_andInc<='0'; 
           wait for 20 ns;
           next_instr_core0 <= '0';
           next_instr_core1 <= '0';
           next_instr_core0 <= '1';
           next_instr_core1 <= '1';
           wait for 20 ns;
           next_instr_core0 <= '0';
           next_instr_core1 <= '0';
           rd_andInc<='1'; 
           wait for 40 ns;
           
          -- wait for 30 ns;
           --next_instr_core0 <= '1';
           --next_instr_core1 <= '1';
--           next_instr_core0 <= '0';
--           next_instr_core1 <= '0';
--           wr<='0';
--           wr_inc <='0';
--           rd<='1';
--           rd_inc <='1';
--           wait for 30  ns;
--           next_instr_core0 <= '0';
--           next_instr_core1 <= '1';
--           wait for 30 ns;
--           next_instr_core0 <= '0';
--           next_instr_core1 <= '0';
--           rd_andInc<='1'; 
           --wait for 40 ns;
--           rd<='0';
--           rd_inc <='0';
--           next_instr_core0 <= '1';
--           next_instr_core1 <= '1';
--           wr<='1';
--           wr_inc <='1';
--           wait for 10 ns;
           
           
           
           
--           wb1<='0';
--           wb0<='0';
--           wait for 5 ns;
--           rd <='1';
--           wb1<='0';
--           wb0<='0';
--           rd_inc <='1';
--           wr_inc <='0';
--           wait for 5 ns;
           
           
           
           
                 
                
--                --PROBLEMA MINORA : DACA WR PTR E FULL SE DA PESTE CAP , NU CRED CA ARE CUM IN CONTEXTUL ACTUAL
--                -- e 10 inceput in data out ca se tot concatenaza...
                
            end process;
                  


end Behavioral;
