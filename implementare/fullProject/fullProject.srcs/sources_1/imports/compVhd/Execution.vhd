library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity Execution is
 Port (RD1,RD2,Ext_imm,PC4: in std_logic_vector(31 downto 0);
        aluSrc : in std_logic;
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector(5 downto 0);
        aluOp : in std_logic_vector(1 downto 0);
        gtz,zero: out std_logic;
        aluRes, bAddress: out std_logic_vector(31 downto 0));
end Execution;

architecture Behavioral of Execution is
signal aluCtrl : std_logic_vector(2 downto 0) := (others =>'0');
signal in2, imm_Branch,aluOut: std_logic_vector(31 downto 0) := (others =>'0');
signal zeroAux: std_logic  :='0';

begin
process(aluOp,func)
begin
case aluOp is 
    when "11" => 
        case func is
            when "000001" => aluCtrl <="001";--add
            when "000011" => aluCtrl <="010";--sub   
            when "000100" => aluCtrl <="011";--sll
            when "000101" => aluCtrl <="100";--slr  
            when "000110" => aluCtrl <="101";--and
            when "000111" => aluCtrl <="110";--or
            when "001000" => aluCtrl <="000";--xor
            when "001111" => aluCtrl <="111";--slt
            when others => aluCtrl <= "XXX";
            end case;
     when "10" => aluCtrl <="001"; --lw,sw,addi
     when "01" => aluCtrl <="010";--branch uri
     when others => aluCtrl<="XXX"; --jump
end case;       
end process;

in2<=RD2 when aluSrc='0' else Ext_imm;
imm_Branch <=Ext_imm(29 downto 0) & "00";
bAddress<= imm_Branch + PC4;

process(aluCtrl,in2, sa, aluCtrl)
begin
    case aluCtrl is 
        when "001" => aluOut <= RD1 + in2;
        when "010" => aluOut <=RD1 - in2;
        when "011" => aluOut <= to_stdlogicvector(to_bitvector(in2) sll conv_integer(sa));
        when "100" => aluOut <= to_stdlogicvector(to_bitvector(in2) srl conv_integer(sa));
        when "101" => aluOut <= RD1 and in2;
        when "110" => aluOut <= RD1 or in2;
        when "000" => aluOut <= RD1 xor in2;
        when "111" =>  if signed(RD1) < signed(in2) then aluOut<= X"00000001"; else aluOut<=X"00000000";end if;
        when others =>aluOut<=(others =>'X');
end case;
end process;

zeroAux<='1' when aluOut=X"00000000" else '0';
zero<=zeroAux;
aluRes<=aluOut;
gtz<= (not aluOut(31)) and (not zeroAux); 







end Behavioral;
