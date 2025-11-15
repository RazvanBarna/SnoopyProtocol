library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Rom is
    Port(clk,btn: in std_logic;
        catozi: out std_logic_vector(6 downto 0);
        anozi: out std_logic_vector(3 downto 0));
end entity;