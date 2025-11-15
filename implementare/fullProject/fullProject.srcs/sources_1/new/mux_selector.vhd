

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mux_selector is
  Port (id_0, id_1,readWrite_type0,readWrite_type1 : in std_logic;
        data_in0,data_in1: in std_logic_vector(65 downto 0);
        useCC0, useCC1 : in std_logic;
        data_out_toCC: out std_logic_vector(67 downto 0));
end mux_selector;

architecture Behavioral of mux_selector is

signal data_total_aux0,data_total_aux1 : std_logic_vector(67 downto 0) :=(others =>'0');
signal search_data0, search_data_1 : std_logic_vector(67 downto 0) :=(others =>'0');

begin

data_total_aux0<= id_0 & readWrite_type0 &  data_in0;
data_total_aux1<= id_1 & readWrite_type1 &  data_in1;

data_out_toCC <= data_total_aux0 when useCC0='1' else
                  data_total_aux1 when useCC1='1' else
                  (others=>'0');

end Behavioral;
