library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MainMem is
end tb_MainMem;

architecture Behavioral of tb_MainMem is

    -- Signals for DUT
    signal clk_tb        : std_logic := '0';
    signal reset_tb      : std_logic := '0';
    signal wr_en_tb      : std_logic := '0';
    signal dataIn_tb     : std_logic_vector(63 downto 0) := (others=>'0');
    signal instr_type_tb : std_logic_vector(1 downto 0) := "00";
    signal cache_id_tb   : std_logic := '0';
    signal cache_id_out_tb : std_logic;
    signal send_data_to_bus_tb : std_logic_vector(63 downto 0);

    -- Component
    component MainMem
      Port (dataIn : in std_logic_vector(63 downto 0);
            cache_id : in std_logic;
            instr_type : in std_logic_vector(1 downto 0);
            clk,reset,wr_en : in std_logic;
            cache_id_out : out std_logic;
            send_data_to_bus: out std_logic_vector(63 downto 0));
    end component;

    -- Helper signals
    constant tag_val     : std_logic_vector(21 downto 0) := std_logic_vector(to_unsigned(16#12345#,22));
    constant index_val   : std_logic_vector(5 downto 0)  := "000011";  -- example index
    constant offset_val  : std_logic_vector(3 downto 0)  := "0000";    -- offset 0
    constant data_val    : std_logic_vector(31 downto 0) := x"DEADBEEF"; -- initial write
    constant wb_data_val : std_logic_vector(31 downto 0) := x"C0FFEE00"; -- WB write-back

begin

    -- Instantiate DUT
    uut: MainMem
        port map (
            dataIn => dataIn_tb,
            cache_id => cache_id_tb,
            instr_type => instr_type_tb,
            clk => clk_tb,
            reset => reset_tb,
            wr_en => wr_en_tb,
            cache_id_out => cache_id_out_tb,
            send_data_to_bus => send_data_to_bus_tb
        );

    -- Clock generation (10 ns period)
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for 5 ns;
            clk_tb <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        -- Reset
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 10 ns;

        -- WRITE initial data to offset 0
        dataIn_tb <= tag_val & index_val & offset_val & data_val;
        instr_type_tb <= "01";  -- write
        wr_en_tb <= '1';
        cache_id_tb <= '0';
        wait for 10 ns;
        wr_en_tb <= '0';

        -- READ same offset to verify
        instr_type_tb <= "00";  -- read
        dataIn_tb <= tag_val & index_val & offset_val & x"00000000"; -- data ignored for read
        wait for 10 ns;

        -- WRITE-BACK a different value to same offset
        instr_type_tb <= "10"; -- WB
        cache_id_tb <= '1';
        wr_en_tb <= '1';
        dataIn_tb <= tag_val & index_val & offset_val & wb_data_val;
        wait for 10 ns;
        wr_en_tb <= '0';

        -- READ again to verify WB
        instr_type_tb <= "00"; -- read
        dataIn_tb <= tag_val & index_val & offset_val & x"00000000"; 
        wait for 10 ns;

        wait; -- stop simulation
    end process;

end Behavioral;
