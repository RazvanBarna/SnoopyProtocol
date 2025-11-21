library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Mem0 is
   Port (memWrite,En,clk,wb,readWriteCC,lw_swInstr: in std_logic;
         AluRes,Rd2: in std_logic_vector(31 downto 0);
         data_fromCC : in std_logic_vector(63 downto 0);
         send_data_to_bus,line_debug : out std_logic_vector(63 downto 0) ; 
         useCC: out std_logic;
         memData,aluResOut: out std_logic_vector(31 downto 0));
end Mem0;


architecture Behavioral of Mem0 is
signal line_indexCc, address, address_aux : integer range 0 to 63 := 0;
signal found : std_logic :='0';
type matrix is array(0 to 63) of std_logic_vector(63 downto 0);
signal m : matrix := (
    -- Date de la adresa 12 la 21 (10 elemente semnate)
    0 => "0000" &X"9877" & "00" & "000100" & "0000" & X"0AAAAAAA", --  +5   (pozitiv) stare tag index offset data
    1 => "0000" &X"1001" & "10" & "000010" & "0001" & X"08888111", --  -3   (negativ)
--    2 => x"00000007", --  +7   (pozitiv)
--    3 => x"FFFFFFF8", --  -8   (negativ)
--    4 => "10" & x"00000020" & "0100" & "0000" & x"DEADBE", -- +12   (pozitiv)
--    5 => x"FFFFFFFF", --  -1   (negativ)
--    6 => x"00000004", --  +4   (pozitiv)
--    7 => x"FFFFFFFA", --  -6   (negativ)
--    8 => x"FFFFFFFE", --  -2   (negativ)
--    9 => x"0000000A", -- +10   (pozitiv)
--    -- Restul memoriei rămâne 0, suma 58 003A ,5 pozitive
    others => (others => '0'));


signal alu_res_aux : std_logic_vector(5 downto 0);

signal ucc_aux : std_logic :='0';
begin

alu_res_aux <= aluRes(7 downto 2);

address_aux <= to_integer(unsigned(AluRes(7 downto 2))) mod 64;


find_line: process(clk) -- caut daca nu e 0 ceea ce primesc
        begin 
        if rising_edge(clk) then
            if wb = '1' then 
             for i in 0 to 63 loop
            if m(i) = data_fromCC(63 downto 32) and (not (data_fromCC = X"0000000000000000")) then
                line_indexCc <= i;
                exit;
            end if;
        end loop;
        end if;
        end if;
        end process;
        
aluResOut<=AluRes;

address <= address_aux when wb = '0' else line_indexCc;

--ce iese din memorie in f de actiune
--memData<=m(address)(31 downto 0);
 
useCC <= ucc_aux;

process(clk)
begin   
    if rising_edge(clk) then 
        line_debug <= m(address);
        ucc_aux <= '0';
        
        if wb = '1' then
            m(address) <= data_fromCC;
            memData <= data_fromCC(31 downto 0);

        elsif en = '1' and readWriteCC = '1' and memWrite='1' and lw_swInstr='1' then
            -- write to CC only for lw/sw
            ucc_aux <= '1';
            send_data_to_bus <= m(address)(63 downto 32) & Rd2;
            m(address)(31 downto 0) <= Rd2;
            memData <= Rd2;

        elsif en = '1' and readWriteCC = '0' and lw_swInstr='1' then
            -- read from CC only for lw/sw
            ucc_aux <= '1';
            send_data_to_bus <= m(address);
            memData <= m(address)(31 downto 0);

        end if;
    end if;
end process;

 
end Behavioral;
