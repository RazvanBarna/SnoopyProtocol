library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity main is



end entity;




architecture arhi_main of main is 
component Core is
  Port (clk,btnRst,btnEn,catoziSel: in std_logic;
        catozi: out std_logic_vector(6 downto 0);
        anozi: out std_logic_vector(3 downto 0);
        led : out std_logic_vector(11 downto 0);
        swSel : in std_logic_vector(2 downto 0));
end component;

begin






end architecture;