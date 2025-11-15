
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ID is
  Port (regWrite, en , regDst, extOp,clk: in std_logic; 
        instr : in std_logic_vector(25 downto 0);
        WD: in std_logic_vector(31 downto 0);
        RD1, RD2 , extImm: out std_logic_vector(31 downto 0);
        func : out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0));
end ID;

architecture Behavioral of ID is
type matrix is array(0 to 31) of std_logic_vector(31 downto 0);
signal m : matrix :=(others =>(others =>'0'));
    
signal RA1 , RA2, WA : std_logic_vector(4 downto 0) :=(others =>'0');   
begin
RA1<= instr(25 downto 21);
RA2<=instr(20 downto 16);
WA<= instr(20 downto 16) when regDst ='0' else instr(15 downto 11);
extImm(15 downto 0)<=instr(15 downto 0);
extImm(31 downto 16)<=(others =>instr(15)) when extOp='1' else (others =>'0');
func<= instr(5 downto 0);
sa <= instr(10 downto 6);
RD1<=m(conv_integer(RA1));
RD2<=m(conv_integer(RA2));

process(clk)
begin
    if rising_edge(clk) then 
        if en='1' and regWrite='1' then 
            m(conv_integer(WA)) <= WD;
        end if;
        end if;
end process;


end Behavioral;
