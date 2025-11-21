    
    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.std_logic_unsigned.all;
    
    entity RomInstructions0 is
      Port (clk : in std_logic ;
            counter : in std_logic_vector(4 downto 0);
            digits : out std_logic_vector(31 downto 0));
    end RomInstructions0;
    
    architecture Behavioral of RomInstructions0 is
    type matrix is array(0 to 31 ) of std_logic_vector(31 downto 0);
    signal m : matrix :=(
       B"100000_00011_00011_0000000000001111",-- pun in reg 3 15
        --B"100001_00000_00011_0000000000000000", -- pun in reg 3 15
        B"100010_00000_00011_0000000000000000", -- scriu ce e in reg 3 la adr 0
        --B"100001_00000_00011_0000000000000000",
         --B"100010_00000_00011_0000000000000000",
        --  lw $3, A_addr($0) add $1, $0, $0  (init contor bucla)   **0x0000 0801**
        --B"100010_00000_00010_0000000000000000", -- add $7, $0, $0  (init contor nr pozitive) **0x0000 3801**
--        B"100000_00000_00100_0000000000001010", -- addi $4, $0, 10 (nr iteratii) **0x8004 000A**
--        B"000000_00000_00000_00010_00000_000001", -- add $2, $0, $0 (init index memorie) **0x0000 1001**
--        B"000000_00000_00000_00101_00000_000001", -- add $5, $0, $0 (init suma) **0x0000 2801**
        
--        B"100100_00001_00100_0000000000001011", -- beq $1, $4, end_loop **0x9024 000B** -- sare 11 instr
--        B"100001_00010_00011_0000000000000000", -- lw $3, A_addr($2) **0x8443 0000** adresa 0 de inceput
--        B"000000_00011_00000_00110_00000_001111", -- slt $6, $3, $0 **0x0060 301F**
--        B"100110_00110_00000_0000000000000010", -- bne $6, $0, is_negative **0x98C0 0002**
--        B"100000_00011_00011_0000000000001111", -- addi $7, $7, 1 **0x80E7 0001**
--        B"111110_00000000000000000000001101", -- j continue_loop **0xF800 000D**
        
--        B"000000_00000_00011_00011_00000_000011", -- sub $3, $0, $3 **0x0003 1803**
--        B"100010_00010_00011_0000000000000000", -- sw $3, A_addr($2) **0x8843 0000**
        
--        B"000000_00101_00011_00101_00000_000001", -- add $5, $5, $3 **0x00A3 2801**
--        B"100000_00010_00010_0000000000000100", -- addi $2, $2, 4 **0x8042 0004**
--        B"100000_00001_00001_0000000000000001", -- addi $1, $1, 1 **0x8821 0001**
--        B"111110_00000000000000000000000101", -- j begin_loop **0xFC00 0005**
        
--        B"100010_00000_00101_0000000000001010", -- sw $5, sum_addr **0x8805 000A** la adresa 10
--        B"100010_00000_00111_0000000000001011", -- sw $7, sum_nrPozitiveAddr **0x8807 000B** 11 -- 5
        
        others => (others => '0'));
    
    
    
    begin
                
     digits<= m(conv_integer(counter));         
    
    end Behavioral;
