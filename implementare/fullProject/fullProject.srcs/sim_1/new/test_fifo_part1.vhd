library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_test_fifo_mux_cores is
end tb_test_fifo_mux_cores;

architecture Behavioral of tb_test_fifo_mux_cores is
    -- Semnale pentru conectare la DUT
    signal clk, btnRst, wb, rd, wr, wr_inc, rd_inc : std_logic := '0';
    signal data_fromCC0, data_fromCC1, debug0, debug1, line_debug0, line_debug1 : std_logic_vector(65 downto 0) := (others => '0');
    signal line_indexCc0, line_indexCc1 : std_logic_vector(5 downto 0) := (others => '0');
    signal data_out, out_test : std_logic_vector(73 downto 0);
    signal empty, full : std_logic;
    
    -- Semnal pentru oprirea simulării

    component test_fifo_mux_cores is
        Port (clk, btnRst, wb, rd, wr, wr_inc, rd_inc : in std_logic;
              data_fromCC0, data_fromCC1 : in std_logic_vector(65 downto 0);
              line_indexCc0, line_indexCc1 : in std_logic_vector(5 downto 0);
              data_out, out_test : out std_logic_vector(73 downto 0);
              debug0, debug1, line_debug0, line_debug1 : out std_logic_vector(65 downto 0);
              empty, full : out std_logic);
    end component;

begin
    -- Instantiere DUT
    DUT: test_fifo_mux_cores 
        port map(
            clk => clk,
            btnRst => btnRst,
            out_test => out_test,
            wb => wb,
            rd => rd,
            wr => wr,
            wr_inc => wr_inc,
            line_debug0 => line_debug0,
            line_debug1 => line_debug1,
            debug0 => debug0,
            debug1 => debug1,
            rd_inc => rd_inc,
            data_fromCC0 => data_fromCC0,
            data_fromCC1 => data_fromCC1,
            line_indexCc0 => line_indexCc0,
            line_indexCc1 => line_indexCc1,
            data_out => data_out,
            empty => empty,
            full => full
        );


  clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
    -- Stimuli: scrieri/citiri și WB
    stim_proc: process
    begin

        
--        -- Reset DUT
--        btnRst <= '1';
--        wait for 30 ns;
--        btnRst <= '0';
--        wait for 20 ns;

        -- Scriere FIFO Core0
        data_fromCC0 <= "00" & x"0000000000000040";
        line_indexCc0 <= "000001";
        wr_inc <= '1';
        wr <= '1';
        wait for 10 ns;
        wr_inc <= '0';
        wr <= '0';
        wait for 20 ns;

        -- Scriere FIFO Core1
        data_fromCC1 <= "00" & x"00000000000000A0";
        line_indexCc1 <= "000010";
        wr_inc <= '1';
        wr <= '1';
        wait for 10 ns;
        wr_inc <= '0';
        wr <= '0';
        wait for 20 ns;

        -- Citire FIFO (prima citire)
        rd <= '1';
        rd_inc <= '1';
        wait for 10 ns;
        rd <= '0';
        rd_inc <= '0';
        wait for 20 ns;
        
        -- Citire FIFO (a doua citire)
        rd <= '1';
        rd_inc <= '1';
        wait for 10 ns;
        rd <= '0';
        rd_inc <= '0';
        wait for 20 ns;

        -- WB Core0
        wb <= '1';
        data_fromCC0 <= "00" & x"00000000000000FF";
        line_indexCc0 <= "000001";
        wait for 10 ns;
        wb <= '0';
        wait for 20 ns;

        -- WB Core1
        wb <= '1';
        data_fromCC1 <= "00" & x"00000000000000EE";
        line_indexCc1 <= "000010";
        wait for 10 ns;
        wb <= '0';
        wait for 30 ns;

    end process;

end Behavioral;