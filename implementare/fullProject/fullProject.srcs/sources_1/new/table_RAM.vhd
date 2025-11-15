

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity table_RAM is
  Port (data_in_fromCC : in std_logic_vector(66 downto 0); -- le iau din CC cu stare noua 66 e id , 65 64 stare , restu 32 tag etc , 32 data
        data_out_toCC : out std_logic_vector(66 downto 0);
        wb : out std_logic;
        type_of_action : in std_logic; --0 read , 1 write
        write,clk : in std_logic );
end table_RAM;

architecture Behavioral of table_RAM is

type matrix is array(0 to 127) of std_logic_vector(66 downto 0);
signal M : Matrix :=(others =>(others =>'0'));

--signal exists: std_logic :='0'; presupun ca exista , fac deja in TB sa existe , daca trebuie implemente
signal data_out_aux : std_logic_vector( 66 downto 0) :=(others =>'0');
signal wr_ptr : std_logic_vector(6 downto 0) :=(others =>'0');
signal data_in_from_other : std_logic_vector(66 downto 0) :=(others =>'0');
signal index_line_original , index_line_other: integer :=0;

begin

    search_for_line: process(data_in_fromCC,M)
    begin
       -- exists <= '0'; 
        for i in 0 to 127 loop
            if M(i)(66) =data_in_fromCC(66) and M(i)(63 downto 32) = data_in_fromCC(63 downto 32) then
                --exists <= '1';
                index_line_original <= i;
                exit;
            end if;
        end loop;
    end process;
    
    search_for_other_line: process(data_in_from_other,M)
    begin
        for i in 0 to 127 loop
             if M(i)(66) =(not data_in_fromCC(66)) and M(i)(63 downto 32) = data_in_fromCC(63 downto 32) then
                data_in_from_other <= M(i);
                index_line_other <= i;
                exit;
            end if;
        end loop;
    end process;
       

end Behavioral;
