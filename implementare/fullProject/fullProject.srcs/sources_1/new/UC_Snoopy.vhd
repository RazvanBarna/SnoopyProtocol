

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(73 downto 0);
        data_toTable : out std_logic_vector(66 downto 0); --67 , scriu in daca trb
        write,clk: out std_logic;
        wb : out std_logic;
        readWriteCC_toMain : out std_logic;
        data_fromTable : in std_logic_vector(63 downto 0);
        line_toMain : out std_logic_vector(63 downto 0);
        wb_line : out std_logic_vector(65 downto 0)
        );
end UC_Snoopy;

architecture Behavioral of UC_Snoopy is

type MSI_state is (S, M , I);
signal state_core0 , state_core1 : MSI_STATE := I;
signal variable_from_otherCore : std_logic_vector(65 downto 0) :=(others =>'0');

begin





end Behavioral;
