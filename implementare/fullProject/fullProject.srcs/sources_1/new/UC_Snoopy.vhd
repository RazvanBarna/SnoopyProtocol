
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(67 downto 0);
        data_toCore0,data_toCore1,data_fromTable_debug,data_in_fromCC_debug : out std_logic_vector(67 downto 0); --67 , scriu in daca trb ; id 1 bit , read/write type 1 bit , state 2 biti , tag 22 , index 6 , offset 4 , data 32 biti
        clk,new_fifo: in std_logic;
        wb_toCore0, wb_toCore1,wb_table_degbug : out std_logic;
        write_enMain,next_instr_core0, next_instr_core1,rd_fifo  : out std_logic;
        line_toMain : out std_logic_vector(63 downto 0)
        );
end UC_Snoopy;

architecture Behavioral of UC_Snoopy is

type MSI_state is (S, M , I);
signal next_state , current_state : MSI_STATE ;
signal data_toCore_aux,data_in_fromCC_debug_aux : std_logic_vector(67 downto 0) :=(others =>'0');
signal wb_aux,wb_table,done_aux : std_logic :='0';
signal data_toTable,data_fromTable : std_logic_vector(67 downto 0) :=(others =>'0');

component table_RAM is
  Port (data_in_fromCC : in std_logic_vector(67 downto 0); 
        data_out_toCC,data_in_fromCC_debug : out std_logic_vector(67 downto 0);
        wb_fromCC : in std_logic;
        wb_ToCC,done : out std_logic;
        clk : in std_logic );
end component;

begin

next_instr_core0 <= '1' when done_aux ='1' and data_inFIFO(67) = '0' else '0';
next_instr_core1 <= '1' when done_aux ='1' and data_inFIFO(67) = '1' else '0';
rd_fifo <= done_aux;

C: table_RAM port map(
                     clk => clk,
                     data_in_fromCC => data_toTable,
                     wb_fromCC =>wb_aux,
                     wb_ToCC => wb_table,
                     data_in_fromCC_debug  => data_in_fromCC_debug_aux,
                     done => done_aux,
                     data_out_toCC =>data_fromTable );

 data_in_fromCC_debug <= data_in_fromCC_debug_aux;           
state_reg: process(clk)
begin
    if rising_edge(clk) then
        if new_fifo = '0' then   
            current_state <= next_state; 
        else
         case data_inFIFO(65 downto 64) is 
                when "00" => current_state <= S;
                when "11" => current_state <= I;
                when "10" => current_state <= M;
                when others => current_state <= S;
                end case;
                end if;
    end if;
end process;
    
FSM: process(clk)
    begin
        if rising_edge(clk) then 
        wb_aux <= '0';
            case current_state is
                when S => if data_inFIFO(66) = '0' then 
                               next_state <= S; -- citeste 
                               data_toTable<=data_inFIFO(67 downto 66) & "00" & data_inFIFO(63 downto 0);
                               --wb_aux <= '0';
                           else 
                                --scrie
                                next_state <= M;
                                --wb_aux <= '0';
                            end if;
                                
                  when M =>  if data_inFIFO(66) = '0' then 
                                next_state <= M ; -- citeste tot el 
                                data_toTable <= data_inFIFO;
                                --wb_aux <= '0';
                             else 
                                --scrie si el
                                next_state<=M;
                                data_toTable <=data_inFIFO(67 downto 66) & "10" & data_inFIFO(63 downto 0); -- noua valoare cu M
                                --wb_aux <='0';
                              end if;
                              
                   when I =>  if data_inFIFO(66) = '0' then -- wb
                                next_state <= S;
                                --data_toTable<=data_inFIFO(67 downto 66) & "11" & data_inFIFO(63 downto 0);
                                wb_aux <='1';
                              else
                                next_state <= M;
                                --wb_aux <='0';
                              end if;
                              
                              end case;
                              end if;
           end process;
                              
                              
write_main: process(clk)
            begin
                if rising_edge(clk) then 
                    write_enMain <= '0';
                    line_toMain<=(others =>'0');
                    if wb_table ='1' then 
                        write_enMain <= '1';
                        line_toMain <= data_fromTable(63 downto 0); 
                     end if;
                     end if;
            end process;                 
                                
write_core: process(clk)
            begin
                if rising_edge(clk) then 
                         wb_toCore0 <= '0';
                        wb_toCore1 <='0';
                    if data_fromTable(67) = '0' and wb_table='1' then 
                        data_toCore0 <= data_fromTable;
                        data_toCore1 <=(others =>'0');
                        wb_toCore0 <= '1';
                        wb_toCore1 <='0';
                    elsif data_fromTable(67) = '1' and wb_table='1' then 
                        data_toCore1 <= data_fromTable;
                        data_toCore0 <= (others =>'0');
                        wb_toCore1 <= '1';
                        wb_toCore0 <='0';
                    end if;
                    end if;
            
            end process;

data_fromTable_debug <= data_fromTable;
wb_table_degbug<= wb_table;
end Behavioral;
