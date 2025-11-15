library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity IFetch1 is
  Port (rst,clk,en,jump, PcSrc : in std_logic;
        jumpAddress, branchAddress: in std_logic_vector( 31 downto 0);
        instruction, pc4 : out std_logic_vector( 31 downto 0) );
end IFetch1;

architecture Behavioral of IFetch1 is
signal outPC,D,outMux1 ,outSumPc4 : std_logic_vector(31 downto 0) :=(others =>'0');

    component RomInstructions1 is
      Port (clk : in std_logic ;
            counter : in std_logic_vector(4 downto 0);
            digits : out std_logic_vector(31 downto 0));
    end component;

begin
process(clk,rst)
begin
    if rst='1' then 
        outPC<= (others =>'0');
     elsif rising_edge(clk) then 
        if en ='1' then 
            outPC <= D;
            end if;
            end if;
            end process;
            
 outSumPc4<= outPC + X"00000004";  
 pc4<=outSumPc4;
 outMux1 <=branchAddress when PcSrc='1' else outSumPc4;
 D <= jumpAddress when jump='1' else outMux1;
 
 C1: RomInstructions1 port map (clk=>clk, counter => outPC(6 downto 2),digits=> instruction);
   


end Behavioral;
