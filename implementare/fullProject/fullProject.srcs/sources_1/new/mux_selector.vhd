library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_selector is
  Port (id_0, id_1,readWrite_type0,readWrite_type1 : in std_logic;
        data_in0,data_in1: in std_logic_vector(63 downto 0);
        useCC0,clk, useCC1 : in std_logic;
        wr_fifo: out std_logic;
        data_out_toCC: out std_logic_vector(65 downto 0));
end mux_selector;

architecture Behavioral of mux_selector is
    signal data_total_aux0, data_total_aux1, data_out_toCC_aux : std_logic_vector(65 downto 0);
    signal turn : std_logic := '0';  
    signal sel : std_logic;  
    
    -- Signals for edge detection
    signal useCC0_prev, useCC1_prev : std_logic := '0';
    signal useCC0_pulse, useCC1_pulse : std_logic := '0';
    
begin
    data_total_aux0 <= id_0 & readWrite_type0 & data_in0;
    data_total_aux1 <= id_1 & readWrite_type1 & data_in1;
    
    process(clk)
    begin
        if rising_edge(clk) then
            useCC0_pulse <= useCC0 and (not useCC0_prev);
            useCC1_pulse <= useCC1 and (not useCC1_prev);
            
            useCC0_prev <= useCC0;
            useCC1_prev <= useCC1;
            
            if useCC0_pulse = '1' and useCC1_pulse = '1' then
                turn <= not turn;
            end if;
            
            if (useCC0_pulse = '1' or useCC1_pulse = '1') then
                wr_fifo <= '1';
            else
                wr_fifo <= '0';
            end if;
        end if;
    end process;
    
   
    sel <= '0' when (useCC0_pulse='1' and useCC1_pulse='0') else 
           '1' when (useCC1_pulse='1' and useCC0_pulse='0') else  
           turn when (useCC0_pulse='1' and useCC1_pulse='1') else 
           '0';                                                     
    
    data_out_toCC_aux <= data_total_aux0 when sel='0' else data_total_aux1;
    data_out_toCC <= data_out_toCC_aux;
    
end Behavioral;