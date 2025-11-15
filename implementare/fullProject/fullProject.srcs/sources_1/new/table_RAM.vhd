

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity table_RAM is
  Port (data_in_fromCC,data_in_fromCC_other : in std_logic_vector(66 downto 0); -- le iau din CC cu stare noua 
        data_out_toCC : out std_logic_vector(66 downto 0);
        wb : out std_logic;
        type_of_action : in std_logic; --0 read , 1 write
        write,clk : in std_logic );
end table_RAM;

architecture Behavioral of table_RAM is

type matrix is array(0 to 127) of std_logic_vector(66 downto 0);
signal M : Matrix :=(others =>(others =>'0'));

signal exists: std_logic :='0';
signal data_out_aux : std_logic_vector( 66 downto 0) :=(others =>'0');
signal wr_ptr : std_logic_vector(6 downto 0) :=(others =>'0');
signal index_line_original , index_line_other: integer :=0;

begin

    search_for_line: process(data_in_fromCC,M)
    begin
        exists <= '0'; 
        for i in 0 to 127 loop
            if M(i)(66) =data_in_fromCC(66) and M(i) = data_in_fromCC then
                exists <= '1';
                index_line_original <= i;
                exit;
            end if;
        end loop;
    end process;
    
        search_for_other_line: process(data_in_fromCC,M)
    begin
        for i in 0 to 127 loop
             if M(i)(66) =data_in_fromCC_other(66) and M(i) = data_in_fromCC_other then
                index_line_other <= i;
                exit;
            end if;
        end loop;
    end process;
    
    insert_modify: process(clk)
            begin   
                if rising_edge(clk) then 
                    if exists = '0' then 
                        M(conv_integer(wr_ptr)) <= data_in_fromCC;
                        wr_ptr <= wr_ptr +1;
                    else
                        case type_of_action is
                        when '0' => 
                                --test wb,citire aici
                                if data_in_fromCC(65 downto 64) = "11" and data_in_fromCC_other(65 downto 64) = "10" then -- I si M
                                    wb <='1';
                                    M(index_line_original) <= data_in_fromCC;
                                    M(index_line_other) <= data_in_fromCC_other;
                                    data_out_aux <= (M(index_line_original)(66) xor '1') & M(index_line_original)(65 downto 0); -- schimb id u ca sa scriu in celalat
                                elsif (data_in_fromCC(65 downto 64) = "11" or data_in_fromCC(65 downto 64) = "10") and data_in_fromCC_other(65 downto 64) = "00" then
                                    M(index_line_original) <= data_in_fromCC; -- se face 00 ,trm direct la core, daca e M si citeste devine S
                                    M(index_line_other) <= data_in_fromCC_other;
                                    data_out_aux <= data_in_fromCC;
                                else data_out_aux <= data_in_fromCC;
                                end if;
                          when '1' =>
                                     --scrie 
                                    M(index_line_original) <= data_in_fromCC; 
                                    M(index_line_other) <= data_in_fromCC_other;
                                    data_out_aux <= data_in_fromCC;
                                    wb <= '0';
                                    
                    end case;                    
                    end if;
                    end if;
            
            end process;
    
    
 data_out_toCC <= data_out_aux;
   



end Behavioral;
