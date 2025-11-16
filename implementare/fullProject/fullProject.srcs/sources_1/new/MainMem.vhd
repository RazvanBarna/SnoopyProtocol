library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity MainMem is
  Port (dataIn : in std_logic_vector(63 downto 0);
        write_enMain : in std_logic;
        clk : in std_logic;
        send_data_to_CCback: out std_logic_vector(63 downto 0));
end MainMem;

architecture Behavioral of MainMem is
type matrix is array( 0 to 63 ) of std_logic_vector(544 downto 0); --16 de 32 ,22 tag , 1 valid 6 index , 4 offset
signal M : matrix := (
   0 =>   (544 => '1', others => '0'),
    1  => (544 => '1', others => '0'),
    2  => (544 => '1', others => '0'),
    3  => (544 => '1', others => '0'),
    4 =>  "1" & "0000" & X"9877" & "10" & "000100" & "0000" & (511 downto 0 => '0'),
    5  => (544 => '1', others => '0'),
    6  => (544 => '1', others => '0'),
    7  => (544 => '1', others => '0'),
    8  => (544 => '1', others => '0'),
    9  => (544 => '1', others => '0'),
    10 => (544 => '1', others => '0'),
    11 => (544 => '1', others => '0'),
    12 => (544 => '1', others => '0'),
    13 => (544 => '1', others => '0'),
    14 => (544 => '1', others => '0'),
    15 => (544 => '1', others => '0'),
    16 => (544 => '1', others => '0'),
    17 => (544 => '1', others => '0'),
    18 => (544 => '1', others => '0'),
    19 => (544 => '1', others => '0'),
    20 => (544 => '1', others => '0'),
    21 => (544 => '1', others => '0'),
    22 => (544 => '1', others => '0'),
    23 => (544 => '1', others => '0'),
    24 => (544 => '1', others => '0'),
    25 => (544 => '1', others => '0'),
    26 => (544 => '1', others => '0'),
    27 => (544 => '1', others => '0'),
    28 => (544 => '1', others => '0'),
    29 => (544 => '1', others => '0'),
    30 => (544 => '1', others => '0'),
    31 => (544 => '1', others => '0'),
    32 => (544 => '1', others => '0'),
    33 => (544 => '1', others => '0'),
    34 => (544 => '1', others => '0'),
    35 => (544 => '1', others => '0'),
    36 => (544 => '1', others => '0'),
    37 => (544 => '1', others => '0'),
    38 => (544 => '1', others => '0'),
    39 => (544 => '1', others => '0'),
    40 => (544 => '1', others => '0'),
    41 => (544 => '1', others => '0'),
    42 => (544 => '1', others => '0'),
    43 => (544 => '1', others => '0'),
    44 => (544 => '1', others => '0'),
    45 => (544 => '1', others => '0'),
    46 => (544 => '1', others => '0'),
    47 => (544 => '1', others => '0'),
    48 => (544 => '1', others => '0'),
    49 => (544 => '1', others => '0'),
    50 => (544 => '1', others => '0'),
    51 => (544 => '1', others => '0'),
    52 => (544 => '1', others => '0'),
    53 => (544 => '1', others => '0'),
    54 => (544 => '1', others => '0'),
    55 => (544 => '1', others => '0'),
    56 => (544 => '1', others => '0'),
    57 => (544 => '1', others => '0'),
    58 => (544 => '1', others => '0'),
    59 => (544 => '1', others => '0'),
    60 => (544 => '1', others => '0'),
    61 => (544 => '1', others => '0'),
    62 => (544 => '1', others => '0'),
    63 => (544 => '1', others => '0')
);
signal index  : integer := 0;
signal offset : integer range 0 to 15 := 0;
signal aux : std_logic_vector(63 downto 0) :=(others =>'0');

begin

proc_write: process(clk)
            variable start_bit : integer ;
            variable end_bit: integer ;
            begin
                if rising_edge(clk) then 
                   if write_enMain = '1' then 
                        index  <= to_integer(unsigned(dataIn(41 downto 36)));
                        offset <= to_integer(unsigned(dataIn(35 downto 32)));
                        if M(index)(544) = '1' then
                        start_bit := offset * 32;
                        end_bit   := start_bit + 31;
                        M(index)(end_bit downto start_bit) <= dataIn(31 downto 0);
                        aux <= dataIn;
                    end if;
                    else 
                    end if;
                    end if;
              end process;
              
send_data_to_CCback <= aux;

end Behavioral;
