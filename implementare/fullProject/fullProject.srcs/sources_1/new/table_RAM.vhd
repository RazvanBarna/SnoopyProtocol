library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity table_RAM is
  Port (data_in_fromCC : in std_logic_vector(67 downto 0); 
        data_out_toCC ,data_in_fromCC_debug: out std_logic_vector(67 downto 0);
        original_line,other_line : out std_logic_vector(67 downto 0);
        out_withState: out std_logic_vector(67 downto 0);
        search_state : in std_logic_vector(65 downto 0);
        wb_fromCC,modify_state,read_table : in std_logic;
        wb_ToCC,done ,done_read: out std_logic;
        clk : in std_logic );
end table_RAM;

architecture Behavioral of table_RAM is

type matrix is array(0 to 127) of std_logic_vector(67 downto 0);
signal M : Matrix :=(
        0 => "0"&"0" &"11"& "0000" &X"9877" & "10" & "000100" & "0000" & X"08888111",
        1 => "1"&"0" &"10"& "0000" &X"9877" & "10" & "000100" & "0000" &X"00CCCCCC", -- celalalt care share uieste si ar deveni invalid 
        others =>(others =>'0'));

signal data_out_aux : std_logic_vector( 67 downto 0) :=(others =>'0');
signal wb_to_aux : std_logic := '0';
signal done_aux : std_logic :='0';
signal found : std_logic :='0';
signal original_line_aux , other_line_aux : std_logic_vector(67 downto 0) :=(others =>'0');

begin

process(clk)
variable index : integer range 0 to 127 := 0;
variable found_v : std_logic := '0';
begin
    if rising_edge(clk) then 
        found_v := '0';
        done_read<='0';
          for i in 0 to 127 loop
               if M(i)(67) =search_state(65)and read_table = '1' and M(i)(63 downto 32) = search_state(63 downto 32) and (search_state /= "000000000000000000000000000000000000000000000000000000000000000000000000") then
                  index := i;
                  found_v := '1';
              exit;
             end if;
             end loop;
             if found_v = '1' then 
                done_read<='1';
                out_withState<= search_state(65 downto 64) & M(index)(65 downto 32) & search_state(31 downto 0);
            end if;
            end if;

end process;
     
    modify_process: process(clk)
        variable index_line_original : integer range 0 to 127 := 0;
        variable index_line_other : integer range 0 to 127 := 0;
                    begin

                        if rising_edge(clk) then 
                            wb_to_aux<='0';
                            done_aux<='0';
                                    for i in 0 to 127 loop
                                     if M(i)(67) =(not data_in_fromCC(67)) and M(i)(63 downto 32) = data_in_fromCC(63 downto 32) then
                                        index_line_other := i;
                                        exit;
                                    end if;
                                end loop;
                                                
                                    for i in 0 to 127 loop
                                        if M(i)(67) = data_in_fromCC(67) and M(i)(63 downto 32) = data_in_fromCC(63 downto 32) then
                                            index_line_original := i;
                                            exit;
                                        end if;
                                    end loop;
                                    
                            if modify_state = '1' and data_in_fromCC /= X"00000000000000000" then 
                                done_aux<= '1';
                                if wb_fromCC = '1'then 
                                    M(index_line_original) <=data_in_fromCC(67 downto 66)  & "00" & data_in_fromCC(63 downto 32) & M(index_line_other)(31 downto 0) ; -- S
                                    M(index_line_other)(65 downto 64) <= "00"; -- S pe celallt care era M
                                    data_out_aux<= data_in_fromCC(67 downto 66)  & "00" & data_in_fromCC(63 downto 32) & M(index_line_other)(31 downto 0) ;
                                    wb_to_aux<='1';
                                    original_line_aux <= data_in_fromCC(67 downto 66)  & "00" & data_in_fromCC(63 downto 32) & M(index_line_other)(31 downto 0) ;
                                    other_line_aux <= M(index_line_other)(67 downto 66) & "00" & M(index_line_other)(63 downto 0);
                                 else 
                                    wb_to_aux<='0';
                                    if data_in_fromCC(66) = '1' then --scrie d
                                        M(index_line_other)(65 downto 64) <= "11"; -- fac invalid pe celalalt
                                        M(index_line_original) <= data_in_fromCC;
                                        data_out_aux<= data_in_fromCC(67 downto 66) & "10" & data_in_fromCC(63 downto 0) ;
                                        original_line_aux <= data_in_fromCC(67 downto 66) & "10" & data_in_fromCC(63 downto 0) ;
                                        other_line_aux<= M(index_line_other)(67 downto 66) & "11" & M(index_line_other)(63 downto 0);
                                        else --citire
                                          M(index_line_other)(65 downto 64) <= "00"; 
                                          M(index_line_original)(65 downto 64) <= "00";
                                          data_out_aux<= M(index_line_original)(67 downto 66) & "00" &M(index_line_original)(63 downto 0) ;
                                          original_line_aux<= M(index_line_original)(67 downto 66) & "00" &M(index_line_original)(63 downto 0) ;
                                          other_line_aux<= M(index_line_other)(67 downto 66) & "00" & M(index_line_other)(63 downto 0);
                                          
                                    end if;
                                end if;
                                end if;
                                end if;
                                
                    end process;
       
done <= done_aux;
wb_ToCC <= wb_to_aux;
data_out_toCC <= data_out_aux;
data_in_fromCC_debug <= data_in_fromCC;
original_line<= original_line_aux;
other_line<= other_line_aux;

end Behavioral;