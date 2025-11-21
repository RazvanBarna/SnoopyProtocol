library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC_Snoopy is
  Port( data_inFIFO : in std_logic_vector(65 downto 0);
        start : in std_logic;
        data_toCore0,data_toCore1:out std_logic_vector(63 downto 0);
        data_in_fifo_debug,DATA_FROMCC_TOTABLE_GET : out std_logic_vector(65 downto 0);
        data_fromTable_debug,data_in_fromCC_debug,data_inFIFOFromTable_debug : out std_logic_vector(67 downto 0); --67 , scriu in daca trb ; id 1 bit , read/write type 1 bit , state 2 biti , tag 22 , index 6 , offset 4 , data 32 biti
        clk,new_fifo,lw_str_core0,lw_str_core1: in std_logic;
        original_line_debug,other_line_debug : out std_logic_vector(67 downto 0);
        wb_toCore0, wb_toCore1, DONE,modify_state_out,DONE_GET_OUT,NEW_FIFO_OUT,WB_FOR_WB : out std_logic;
        write_enMain,next_instr_core0, next_instr_core1,rd_fifo  : out std_logic;
        line_toMain : out std_logic_vector(63 downto 0)
        );
end UC_Snoopy;

architecture Behavioral of UC_Snoopy is
--EN E NEW FIFO
type MSI_state is (S, M , I);
signal next_state , current_state : MSI_STATE ;
signal data_toCore_aux,data_in_fromCC_debug_aux : std_logic_vector(67 downto 0) :=(others =>'0');
signal wb_aux,wb_table,done_aux : std_logic :='0';
signal data_toTable,data_fromTable : std_logic_vector(67 downto 0) :=(others =>'0');

component table_RAM is
  Port (data_in_fromCC : in std_logic_vector(67 downto 0); 
        data_out_toCC ,data_in_fromCC_debug: out std_logic_vector(67 downto 0);
        original_line,other_line : out std_logic_vector(67 downto 0);
        out_withState: out std_logic_vector(67 downto 0);
        search_state : in std_logic_vector(65 downto 0);
        wb_fromCC,modify_state,read_table : in std_logic;
        wb_ToCC,done ,done_read: out std_logic;
        clk : in std_logic );
end component;

component Get_fullLine_state is
  Port (clk,en : in std_logic;
        data_in : in std_logic_vector(65 downto 0);
        data_fromTable : in std_logic_vector(67 downto 0);
        data_toTable,DATA_FROMCC_TOTABLE_GET : out std_logic_vector(65 downto 0);
        data_out: out std_logic_vector(67 downto 0); 
        done_get,read_table : out std_logic;       
        done_read_table : in std_logic );
end component;

signal data_fromTable_toGet,data_out_Get : std_logic_vector(67 downto 0) :=(others =>'0');
signal data_toTable_fromGet  : std_logic_vector(65 downto 0) :=(others =>'0');
signal done_read_table,modify_state,done_get,read_table_aux,continue_FSM : std_logic :='0';
signal latched_line   : std_logic_vector(67 downto 0) := (others => '0');
signal latched_valid  : std_logic := '0';
begin

next_instr_core0 <= '1' when (done_aux ='1' and data_out_Get(67) = '0') or lw_str_core0 = '0' else '0';
next_instr_core1 <= '1' when (done_aux ='1' and data_out_Get(67) = '1') or lw_str_core1 = '0' else '0';
rd_fifo <= start or done_aux;
DONE <= done_aux;
modify_state_out<=modify_state;
DONE_GET_OUT<=done_get;
NEW_FIFO_OUT<=new_fifo;
WB_FOR_WB<=wb_aux;

C0 : Get_fullLine_state port map(
                                 clk => clk,
                                 en => new_fifo,
                                 DATA_FROMCC_TOTABLE_GET=> DATA_FROMCC_TOTABLE_GET,
                                 done_get=>done_get,
                                 data_in =>data_inFIFO,
                                  data_fromTable => data_fromTable_toGet,
                                  data_toTable =>data_toTable_fromGet,
                                   data_out=>data_out_Get, 
                                   read_table=> read_table_aux,
                                   done_read_table =>done_read_table );

C: table_RAM port map(
                     clk => clk,
                     out_withState=> data_fromTable_toGet,
                     search_state=> data_toTable_fromGet,
                     modify_state=> modify_state,
                     read_table => read_table_aux,
                     done_read=>done_read_table,
                     data_in_fromCC => data_out_Get,
                     wb_fromCC =>wb_aux,
                     original_line=> original_line_debug,
                     other_line=>other_line_debug,
                     wb_ToCC => wb_table,
                     data_in_fromCC_debug  => data_in_fromCC_debug_aux,
                     done => done_aux,
                     data_out_toCC =>data_fromTable );

 data_in_fromCC_debug <= data_in_fromCC_debug_aux;  
   
 -- latch data_out_Get when Get_fullLine_state tells us it's ready
process(clk)
begin
  if rising_edge(clk) then
    if done_get = '1' then
      latched_line  <= data_out_Get;
      latched_valid <= '1';
    elsif (done_aux = '1' and modify_state = '1') then
      -- table_RAM finished the modification request: we can clear payload
      latched_valid <= '0';
    end if;
  end if;
end process;
       
state_reg: process(clk)
begin
    if rising_edge(clk) then
        if latched_valid = '1' and modify_state = '0' then
            case latched_line(65 downto 64) is
                when "00" => current_state <= S;
                when "11" => current_state <= I;
                when "10" => current_state <= M;
                when others => current_state <= I;
            end case;
        else
            current_state <= next_state;
        end if;
    end if;
end process;
    
FSM: process(clk)
begin
    if rising_edge(clk) then
        -- default values (nu resetăm modify_state aici; îl controlăm explicit)
        wb_aux <= '0';
        continue_FSM <= '0';
        next_state <= current_state;

        -- Trigger FSM dacă avem o linie capturată sau continuăm o operație
        if (latched_valid = '1' or continue_FSM = '1') then
            case current_state is
                when S =>
                    if latched_line(66) = '0' then
                        -- read in S
                        next_state <= S;
                        data_toTable <= latched_line(67 downto 66) & "00" & latched_line(63 downto 0);
                        modify_state <= '1';  -- cerere de scriere în table_RAM
                    else
                        -- write in S -> upgrade la M
                        next_state <= M;
                        modify_state <= '1';
                        continue_FSM <= '1';
                        data_toTable <= latched_line(67 downto 66) & "10" & latched_line(63 downto 0);
                    end if;

                when M =>
                    if latched_line(66) = '0' then
                        next_state <= M;
                        data_toTable <= latched_line;
                        modify_state <= '1';
                    else
                        next_state <= M;
                        data_toTable <= latched_line(67 downto 66) & "10" & latched_line(63 downto 0);
                        modify_state <= '1';
                    end if;

                when I =>
                    if latched_line(66) = '0' then
                        -- need WB then bring line -> we assert wb and request modify after wb completes
                        wb_aux <= '1';
                        -- do NOT assert modify_state until we have the new line; 
                        -- practical approach: keep latched_valid set, and after done_aux clear, FSM will re-evaluate and then set modify_state
                        continue_FSM <= '1';
                    else
                        -- write into I -> upgrade to M
                        next_state <= M;
                        modify_state <= '1';
                        continue_FSM <= '1';
                        data_toTable <= latched_line(67 downto 66) & "10" & latched_line(63 downto 0);
                    end if;
                when others =>
                    next_state <= I;
            end case;
        end if;

        -- clear modify_state when table_RAM finished processing (done_aux)
        if done_aux = '1' then
            modify_state <= '0';
            -- latched_valid is cleared in latch-process above when done_aux and modify_state='1'
        end if;
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
                        data_toCore0 <= data_fromTable(63 downto 0);
                        data_toCore1 <=(others =>'0');
                        wb_toCore0 <= '1';
                        wb_toCore1 <='0';
                    elsif data_fromTable(67) = '1' and wb_table='1' then 
                        data_toCore1 <= data_fromTable(63 downto 0);
                        data_toCore0 <= (others =>'0');
                        wb_toCore1 <= '1';
                        wb_toCore0 <='0';
                    end if;
                    end if;
            
            end process;
data_fromTable_debug <= data_fromTable;
data_inFIFOFromTable_debug <= data_out_Get;
data_in_fifo_debug<=data_inFIFO;
end Behavioral;