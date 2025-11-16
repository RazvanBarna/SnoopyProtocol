library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity Core0 is
  Port (clk,btnRst,wb,core_id_in,next_instr_core0: in std_logic; --core id e in ca sa il setez eu
        data_fromCC : in std_logic_vector(65 downto 0);
        readWriteCC,core_id_out,useCC: out std_logic;
        send_data_to_bus,debug,line_debug : out std_logic_vector(65 downto 0)        
        );
end Core0;

architecture Behavioral of Core0 is
component MPG is
    Port ( enable : out STD_LOGIC;
           btn : in STD_LOGIC;
           clk : in STD_LOGIC);
end component;

component IFetch0 is
  Port (rst,clk,en,jump, PcSrc,next_instr_core0 : in std_logic;
        jumpAddress, branchAddress: in std_logic_vector( 31 downto 0);
        instruction, pc4 : out std_logic_vector( 31 downto 0) );
end component;

component UC is
  Port (instr: in std_logic_vector(5 downto 0);
        regDst,extOp,aluSrc,branch,jump,bgtz,bne,memWrite,memToReg, regWrite: out std_logic;
        readWriteCC,lw_swInstr : out std_logic;
        aluOp : out std_logic_vector(1 downto 0));
end component;

component ID is
  Port (regWrite, en , regDst, extOp,clk: in std_logic; 
        instr : in std_logic_vector(25 downto 0);
        WD: in std_logic_vector(31 downto 0);
        RD1, RD2 , extImm: out std_logic_vector(31 downto 0);
        func : out std_logic_vector(5 downto 0);
        sa : out std_logic_vector(4 downto 0));
end component;

component Execution is
 Port (RD1,RD2,Ext_imm,PC4: in std_logic_vector(31 downto 0);
        aluSrc : in std_logic;
        sa: in std_logic_vector(4 downto 0);
        func: in std_logic_vector(5 downto 0);
        aluOp : in std_logic_vector(1 downto 0);
        gtz,zero: out std_logic;
        aluRes, bAddress: out std_logic_vector(31 downto 0));
end component;

component Mem0 is
   Port (memWrite,En,clk,wb,readWriteCC,lw_swInstr: in std_logic;
         AluRes,Rd2: in std_logic_vector(31 downto 0);
         data_fromCC : in std_logic_vector(65 downto 0);
         send_data_to_bus,line_debug : out std_logic_vector(65 downto 0) ; 
         useCC: out std_logic;
         memData,aluResOut: out std_logic_vector(31 downto 0));
end component;



signal en,jump,lw_swInstr,PcSrc,regWrite,readWriteCC_aux,regDst,extOp,aluSrc,zero,memWrite,memToReg,branch,bgtz,bne,gtz: std_logic :='0';
signal aluOp : std_logic_vector(1 downto 0) :=(others =>'0');
signal jumpAddress,branchAddress,PC4,instruction,RD1,RD2,WD,Ext_imm,aluResAux,aluResOut,memData: std_logic_vector(31 downto 0) :=(others =>'0');
signal muxOut: std_logic_vector(31 downto 0) :=(others =>'0');
signal func: std_logic_vector(5 downto 0) :=(others =>'0');
signal sa : std_logic_vector(4 downto 0) :=(others =>'0');

signal send_data_to_bus_aux :std_logic_vector(65 downto 0) :=(others =>'0');

begin
en <='1';

Fetch: IFetch0 port map(clk=>clk,next_instr_core0 => next_instr_core0, en =>en, rst=>btnRst, jump=>jump, PcSrc=>PcSrc,branchAddress=>branchAddress,jumpAddress=>jumpAddress,
        instruction => instruction, pc4 =>PC4);
        
IDComp: ID port map(en=>en,regWrite=>regWrite, instr=>instruction(25 downto 0),regDst=>regDst,extOp=>extOp,clk=>clk,WD=>WD,RD1=>RD1,
        RD2=>RD2,extImm=>Ext_imm,func=>func,sa=>sa);    
        
EXComp: Execution port map(RD1=>RD1,aluSrc=>aluSrc,RD2=>RD2,Ext_imm=>Ext_imm,func=>func,sa=>sa,aluOp=>aluOp,PC4=>PC4,zero=>zero,
        bAddress=>branchAddress,aluRes=>aluResAux,gtz=>gtz);
        
MemComp: Mem0 port map (clk=>clk,lw_swInstr => lw_swInstr,useCC => useCC,line_debug => line_debug,wb =>wb,readWriteCC=> readWriteCC_aux,data_fromCC => data_fromCC,send_data_to_bus=>send_data_to_bus_aux,RD2=>RD2,aluResOut=>aluResOut,aluRes=>aluResAux,en=>en,memWrite=>memWrite,memData=>memData);


UCComp: UC port map(regDst=>regDst,lw_swInstr => lw_swInstr,readWriteCC=> readWriteCC_aux,jump=>jump,extOp=>extOp,aluSrc=>aluSrc,branch=>branch,aluOp=>aluOp,memWrite=>memWrite,memToReg=>memToReg,
        regWrite=>regWrite,bgtz=>bgtz,bne=>bne,instr=>instruction(31 downto 26));

WD<=aluResOut when memToReg='0' else memData;
PcSrc<= (branch and zero) or (bne and (not zero) ) or (bgtz and gtz);
jumpAddress<= PC4(31 downto 28) & instruction(25 downto 0) & "00";

core_id_out <= core_id_in;
readWriteCC <= readWriteCC_aux;

debug <=send_data_to_bus_aux;
send_data_to_bus<= send_data_to_bus_aux;

end Behavioral;
