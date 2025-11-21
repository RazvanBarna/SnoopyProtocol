library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_selector is
  Port (
        id_0, id_1, readWrite_type0, readWrite_type1 : in std_logic;
        data_in0, data_in1 : in std_logic_vector(63 downto 0);
        useCC0, useCC1, clk : in std_logic;
        wr_fifo : out std_logic;
        data_out_toCC : out std_logic_vector(65 downto 0)
  );
end mux_selector;

architecture Behavioral of mux_selector is
    signal turn : std_logic := '0'; 
    signal data_out_aux : std_logic_vector(65 downto 0);
    signal last_sent : std_logic_vector(65 downto 0) := (others => '0');
    signal candidate : std_logic_vector(65 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            wr_fifo <= '0';
            if useCC0 = '1' and useCC1 = '1' then
                if turn = '0' then
                    candidate <= id_0 & readWrite_type0 & data_in0;
                    turn <= '1';
                else
                    candidate <= id_1 & readWrite_type1 & data_in1;
                    turn <= '0';
                end if;
            elsif useCC0 = '1' then
                candidate <= id_0 & readWrite_type0 & data_in0;
                turn <= '1';
            elsif useCC1 = '1' then
                candidate <= id_1 & readWrite_type1 & data_in1;
                turn <= '0';
            else
                candidate <= (others => '0'); 
            end if;

            if candidate /= last_sent and candidate /= X"0000000000000000" & "00" then
                data_out_aux <= candidate;
                wr_fifo <= '1';
                last_sent <= candidate;
            end if;

        end if;
    end process;

    data_out_toCC <= data_out_aux;

end Behavioral;
