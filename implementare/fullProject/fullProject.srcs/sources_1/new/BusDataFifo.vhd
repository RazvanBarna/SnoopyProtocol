    
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
    
    
 entity BusDataFifo is
  Port (rd, wr, wr_inc, rd_inc, rst, clk : in std_logic;
        data_in  : in std_logic_vector(63 downto 0);
        cache_id : in std_logic;
        full, empty : out std_logic;
        instruction_type_in : in std_logic_vector(1 downto 0);
        instruction_type_out : out std_logic_vector(1 downto 0);
        data_out : out std_logic_vector(63 downto 0);
        cache_id_out : out std_logic); -- salvare id 
end BusDataFifo;
    
architecture Behavioral of BusDataFifo is
    signal wr_ptr, rd_ptr : std_logic_vector(4 downto 0) := (others => '0'); -- 32 , 2 la 5
    signal decode_out, cache_id_aux : std_logic_vector(31 downto 0) := (others => '0');
    signal count_aux : integer := 0; 
    constant max_size : integer := 32;
    
    type matrix is array(0 to 31) of std_logic_vector(63 downto 0);
    signal M : matrix := (others => (others => '0'));

    component fifo_component is
      Port (wr, decode_out,clk,rst: in std_logic;
            data_in : in std_logic_vector(63 downto 0);
            cache_id : in std_logic;
            cache_id_out : out std_logic;
            fifo_out: out std_logic_vector(63 downto 0));
    end component;

    
    component decoder_5to32 is
    Port (
        wr_ptr     : in  STD_LOGIC_VECTOR(4 downto 0);
        decode_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end component;
    
    begin
    
    write_pointer: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                wr_ptr <= (others => '0');
            elsif wr_inc = '1' and count_aux < max_size then
                wr_ptr <= std_logic_vector(unsigned(wr_ptr) + 1);
            end if;
        end if;
    end process;    
    
    read_pointer: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                rd_ptr <= (others => '0');
            elsif rd_inc = '1' and count_aux > 0 then
                rd_ptr <= std_logic_vector(unsigned(rd_ptr) + 1);
            end if;
        end if;
    end process;
    
    counter_proc: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count_aux <= 0;
            else
                if wr_inc = '1' and count_aux < max_size then
                    count_aux <= count_aux + 1;
                elsif rd_inc = '1' and count_aux > 0 then
                    count_aux <= count_aux - 1;
        end if;
        end if;
        end if;
    end process;
    
    C1: decoder_5to32 port map(wr_ptr => wr_ptr,decode_out =>decode_out);
    
    gen_fifos: for i in 0 to 31 generate
    fifo_inst: fifo_component
        port map(
            wr        => wr,
            rst       => rst,
            clk       => clk,
            data_in   => data_in,
            fifo_out  => M(i),
            cache_id => cache_id,
            cache_id_out => cache_id_aux(i),
            decode_out => decode_out(i)
        );
    end generate gen_fifos;

    mux: process(M, rd_ptr, rd)
    begin
        if rd = '1' then
            data_out <= M(to_integer(unsigned(rd_ptr)));
            cache_id_out <= cache_id_aux(to_integer(unsigned(rd_ptr)));
        else
            data_out <= (others => 'Z');
        end if;
    end process;
    
    empty <= '1' when count_aux = 0 else '0';
    full  <= '1' when count_aux = MAX_SIZE else '0';
    instruction_type_out <= instruction_type_in;
    
  
    end Behavioral;
