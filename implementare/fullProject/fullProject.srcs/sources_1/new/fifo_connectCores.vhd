    
    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use IEEE.NUMERIC_STD.ALL;
    
    
    
    entity fifo_connectCores is
      Port (
            rd, wr, wr_inc, rd_inc, rst, clk : in std_logic;
            data_in   : in std_logic_vector(67 downto 0);
            full, empty,new_fifo : out std_logic;
            data_out : out std_logic_vector(67 downto 0);
            wr_ptr_out,rd_ptr_out : out std_logic_vector(4 downto 0)
             );
    end fifo_connectCores;
    
    architecture Behavioral of fifo_connectCores is
    
        signal wr_ptr, rd_ptr : std_logic_vector(4 downto 0) := (others => '0'); -- 32 , 2 la 5
        signal decode_out : std_logic_vector(31 downto 0) := (others => '0');
        signal count_aux : integer := 0; 
        constant max_size : integer := 32;
        
        type matrix is array(0 to 63) of std_logic_vector(67 downto 0);
        signal M : matrix := (others => (others => '0'));
    
    component fifo_component_2ids is
      Port (wr, decode_out,clk,rst: in std_logic;
            data_in : in std_logic_vector(67 downto 0);
            fifo_out: out std_logic_vector(67 downto 0));
    end component;
        
        component decoder_5to32 is
        Port (
            wr_ptr     : in  std_logic_vector(4 downto 0);
            decode_out : out std_logic_vector(31 downto 0)
        );
    end component;
    
    --signal found : std_logic :='0';
    signal empty_aux : std_logic :='0';
    
    begin
    
    
--    search_for_duplicate: process(data_in,M)
--    begin
--       -- found <= '0'; 
--        for i in 0 to 31 loop
--            if M(i) = data_in and (not (data_in = X"00000000000000000" )) then
--                out_test <= M(i);
--               -- found <= '1';
--                exit;
--            end if;
--        end loop;
--    end process;
    
    
     write_pointer: process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    wr_ptr <= (others => '0');
                elsif wr_inc = '1' and count_aux < max_size then -- and  found = '0'
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
    
        gen_fifos2: for i in 0 to 31 generate
        fifo_inst1: fifo_component_2ids
            port map(
                wr        => wr,
                rst       => rst,
                clk       => clk,
                data_in =>  data_in,
                fifo_out => M(i),
                decode_out => decode_out(i)
            );
        end generate gen_fifos2;
        
read_proc: process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            data_out <= (others => '0');
        elsif rd_inc = '1'and rd = '1' and count_aux > 0 then
            data_out <= M(to_integer(unsigned(rd_ptr)));
            new_fifo <='1'; 
        else
            new_fifo <='0';
            data_out <= (others => 'Z');  -- sau (others=>'0') dacă nu vrei tri-state
        end if;
    end if;
end process;
    
        empty_aux <= '1' when count_aux = 0 else '0';
        empty <= empty_aux;
        full  <= '1' when count_aux = MAX_SIZE else '0';
        wr_ptr_out <= wr_ptr;
        rd_ptr_out <= rd_ptr;
    
    end Behavioral;
