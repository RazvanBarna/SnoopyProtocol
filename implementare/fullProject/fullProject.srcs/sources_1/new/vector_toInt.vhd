library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vector_toInt is
 Port (
   vector : in std_logic_vector(5 downto 0);
   int    : out integer
 );
end vector_toInt;

architecture Behavioral of vector_toInt is
begin
   int <= to_integer(unsigned(vector));
end Behavioral;
