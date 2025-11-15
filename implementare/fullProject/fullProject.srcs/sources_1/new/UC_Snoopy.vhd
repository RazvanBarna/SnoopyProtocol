

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(67 downto 0);
        data_toTable, data_toCore0,data_toCore1 : out std_logic_vector(67 downto 0); --67 , scriu in daca trb
        clk,wb_table: in std_logic;
        wb_Totable, wb_toCore0, wb_toCore1 : out std_logic;
        readWriteCC_toMain : out std_logic;
        data_fromTable : in std_logic_vector(67 downto 0);
        line_toMain : out std_logic_vector(63 downto 0)
        );
end UC_Snoopy;

architecture Behavioral of UC_Snoopy is

type MSI_state is (S, M , I);
signal init_state , state_core1 : MSI_STATE := I;
signal data_toCore_aux : std_logic_vector(67 downto 0) :=(others =>'0');
signal wb_aux : std_logic :='0';

begin
    
state_code: process(data_inFIFO)
            begin
                case data_inFIFO(65 downto 64) is 
                when "00" => init_state <= S;
                when "11" => init_state <= I;
                when "10" => init_state <= M;
                when others => init_state <= I;
                end case;
            end process;
    
    
FSM: process(clk)
    begin
        if rising_edge(clk) then 
            case init_state is
                when S => if data_inFIFO(66) = '0' then 
                               init_state <= S; -- citeste 
                               data_toTable<=data_inFIFO(67 downto 66) & "00" & data_inFIFO(63 downto 0);
                               --wb_aux <= '0';
                           else 
                                --scrie
                                init_state <= M;
                                wb_aux <= '0';
                            end if;
                                
                  when M =>  if data_inFIFO(66) = '0' then 
                                init_state <= M ; -- citeste tot el 
                                data_toTable <= data_inFIFO;
                                wb_aux <= '0';
                             else 
                                --scrie si el
                                init_state<=M;
                                data_toTable <=data_inFIFO(67 downto 66) & "10" & data_inFIFO(63 downto 0); -- noua valoare cu M
                                wb_aux <='0';
                              end if;
                              
                   when I =>  if data_inFIFO(66) = '0' then -- wb
                                init_state <= S;
                                wb_aux <='1';
                              else
                                init_state <= M;
                                wb_aux <='0';
                              end if;
                              
                              end case;
                              end if;
           end process;
                              
                              
write_main: process(clk)
            begin
                if rising_edge(clk) then 
                    if wb_table <='1' then 
                        readWriteCC_toMain <= '1';
                        line_toMain <= data_fromTable(63 downto 0); 
                     end if;
                     end if;
            end process;                 
                                
write_core: process(clk)
            begin
                if rising_edge(clk) then 
                    if data_fromTable(67) = '0' then 
                        data_toCore0 <= data_fromTable;
                        data_toCore1 <=(others =>'0');
                        wb_toCore0 <= '1';
                        wb_toCore1 <='0';
                    else 
                        data_toCore1 <= data_fromTable;
                        data_toCore0 <= (others =>'0');
                        wb_toCore1 <= '1';
                        wb_toCore0 <='0';
                    end if;
                    end if;
            
            end process;

wb_Totable <= wb_aux;

end Behavioral;
