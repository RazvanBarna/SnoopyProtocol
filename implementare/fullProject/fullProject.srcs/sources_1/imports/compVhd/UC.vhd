
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity UC is
  Port (instr: in std_logic_vector(5 downto 0);
        regDst,extOp,aluSrc,branch,jump,bgtz,bne,memWrite,memToReg, regWrite: out std_logic;
        readWriteCC,lw_swInstr : out std_logic;
        aluOp : out std_logic_vector(1 downto 0));
end UC;

architecture Behavioral of UC is

begin
process(instr)
begin
regDst<='0';extOp<='0';aluSrc<='0';branch<='0';jump<='0';
lw_swInstr<='0';
bgtz<='0';bne<='0';memWrite<='0';memToReg<='0';regWrite<='0';aluOp<="00"; readWriteCC <='0';
case instr is 
    when "000000" => 
            regDst<='1';regWrite<='1';
            aluOp<="11";--R -- cod
    when "100000" => 
            extop<='1';aluSrc<='1';regWrite<='1';--addi
            aluOp<="10";
    when "100001" => 
            lw_swInstr<='1';
            readWriteCC <='0';
            extop<='1';aluSrc<='1';regWrite<='1';memToReg<='1';--Lw
            aluOp<="10";--cod +
    when "100010"  =>
            lw_swInstr<='1';
            readWriteCC <='1';
            extop<='1';aluSrc<='1';memWrite<='1';--sw
            aluOp<="10";
    when "100100"  =>
            extop<='1';branch<='1';--beq
            aluOp<="01";   --cod -    
    when "100101"  =>
            extop<='1';bgtz<='1';--bgtz
            aluOp<="01";   --cod - 
    when "100110"  =>
            extop<='1';bne<='1';--bne
            aluOp<="01";   --cod - 
    when "111110"  =>
            jump<='1';--jump
            aluOp<="XX"; -- cod jump
    when others => 
            regDst<='0';extOp<='0';aluSrc<='0';branch<='0';jump<='0';
            bgtz<='0';bne<='0';memWrite<='0';memToReg<='0';regWrite<='0';aluOp<="00";   
            readWriteCC <='0';
          end case;      

end process;


end Behavioral;
