

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_component is
  Port (wr, decode_out,clk,rst: in std_logic;
        data_in : in std_logic_vector(63 downto 0);
        cache_id : in std_logic;
        cache_id_out : out std_logic;
        fifo_out: out std_logic_vector(63 downto 0));
end fifo_component;

architecture Behavioral of fifo_component is
signal fifo_aux : std_logic_vector(63 downto 0) :=(others => '0');

begin

process(clk)
begin
    if rising_edge(clk) then 
        if rst = '1' then
            fifo_aux <= (others => '0');
        elsif (wr = '1' and decode_out = '1') then
            fifo_aux <= data_in;
        end if;
    end if;    
end process;

fifo_out <= fifo_aux;
cache_id_out <= cache_id;


end Behavioral;
