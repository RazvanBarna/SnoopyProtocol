library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MainMem is
  Port (dataIn : in std_logic_vector(63 downto 0);
        cache_id : in std_logic;
        instr_type : in std_logic_vector(1 downto 0); -- 00 read, 01 wr , 10 wb
        clk,reset,wr_en : in std_logic;
        cache_id_out : out std_logic;
        send_data_to_bus: out std_logic_vector(63 downto 0));
end MainMem;

architecture Behavioral of MainMem is
type matrix is array( 0 to 63 ) of std_logic_vector(150 downto 0); --4 de 32 ,22 tag , 1 valid
signal M : matrix :=(others =>(others =>'0'));
signal index: std_logic_vector( 5 downto 0) :=(others =>'0');
signal offset : std_logic_vector(3 downto 0) :=(others =>'0');
signal tag : std_logic_vector(21 downto 0) :=(others =>'0');
signal data,data_aux,data_read : std_logic_vector(31 downto 0) :=(others =>'0');
signal data_out : std_logic_vector(63 downto 0) :=(others =>'0');

begin
    tag <= dataIn(63 downto 42);
    index <= dataIn(41 downto 36);
    offset<= dataIn(35 downto 32);
    data <= dataIn(31 downto 0);
    
    process(clk)
         variable high, low: integer; 
    begin
        if rising_edge(clk) then 
             high := 127 - 32*to_integer(unsigned(offset));
             low := 127 - 32*(to_integer(unsigned(offset))+1) + 1;
            if M(to_integer(unsigned(index)))(150) = '1' then 
                if tag = M(to_integer(unsigned(index)))(149 downto 128) then 
                    if wr_en = '1' and (instr_type = "01" or instr_type = "10") then
                        M(to_integer(unsigned(index)))(high downto low) <= data;
                         data_aux <=  data;
                             end if;
                             else data_aux <= (others =>'Z');
                             end if;
                             else 
                              M(to_integer(unsigned(index)))(high downto low)<= data;
                              data_aux <= data;
                                M(to_integer(unsigned(index)))(150) <= '1';
                                M(to_integer(unsigned(index)))(149 downto 128) <= tag;
                             end if;
                             elsif reset ='1' then M <= (others =>(others =>'0'));
                                
                             end if;
         
    end process;
    data_read<= M(to_integer(unsigned(index)))(127 - 32*to_integer(unsigned(offset)) downto 127 - 32*(to_integer(unsigned(offset))+1) + 1);
    
    process(instr_type, data_aux, tag, index, offset, cache_id)
    begin
        if instr_type = "00" then --rd
           data_out <= tag & index & offset & data_read;
           cache_id_out <= cache_id;
        elsif instr_type = "01" then --wr NU CONTEAZA AICI 
            data_out <= tag & index & offset & data_aux;
            cache_id_out <= cache_id;
        elsif instr_type = "10" then --wb
             data_out <= tag & index & offset & data_aux;
             cache_id_out <= not cache_id; 
        end if;
    end process;
    
    send_data_to_bus <= data_out;


end Behavioral;
