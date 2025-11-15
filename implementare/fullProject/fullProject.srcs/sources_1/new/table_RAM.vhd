library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity table_RAM is
  Port (data_in_fromCC : in std_logic_vector(67 downto 0); 
        data_out_toCC : out std_logic_vector(67 downto 0);
        wb_fromCC : in std_logic;
        wb_ToCC : out std_logic;
        clk : in std_logic );
end table_RAM;

architecture Behavioral of table_RAM is

type matrix is array(0 to 127) of std_logic_vector(67 downto 0);
signal M : Matrix :=(
        0 => "0"&"0" &"00"& "0000" &X"1001" & "00" & "000010" & "0001" & X"08888111",
        others =>(others =>'0'));

signal data_out_aux : std_logic_vector( 67 downto 0) :=(others =>'0');
signal wb_to_aux : std_logic := '0';

begin
     
    modify_process: process(clk)
        variable index_line_original : integer range 0 to 127 := 0;
        variable index_line_other : integer range 0 to 127 := 0;
                    begin

                        if rising_edge(clk) then 
                            wb_to_aux<='0';
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
                                    
                            if wb_fromCC = '1' then 
                                M(index_line_original) <= data_in_fromCC(67 downto 32) & M(index_line_other)(31 downto 0) ; -- S
                                M(index_line_other)(65 downto 64) <= "00"; -- S pe celallt care era M
                                data_out_aux<= data_in_fromCC(67 downto 32) & M(index_line_other)(31 downto 0);
                                wb_to_aux<='1';
                             else 
                                wb_to_aux<='0';
                                if data_in_fromCC(66) = '1' then --scrie d
                                    M(index_line_other)(65 downto 64) <= "11"; -- fac invalid pe celalalt
                                    M(index_line_original) <= data_in_fromCC;
                                    data_out_aux<= data_in_fromCC(67 downto 66) & "10" & data_in_fromCC(63 downto 0) ;
                                    else --citire
                                      M(index_line_other)(65 downto 64) <= "00"; 
                                      data_out_aux<= M(index_line_original)(67 downto 66) & "00" &M(index_line_original)(63 downto 0) ;
                                    end if;
                                end if;
                                end if;
                                
                    end process;
       
wb_ToCC <= wb_to_aux;
data_out_toCC <= data_out_aux;

end Behavioral;
