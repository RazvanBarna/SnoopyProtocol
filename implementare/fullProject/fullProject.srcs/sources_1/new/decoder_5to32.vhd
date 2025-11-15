library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_5to32 is
    Port (
        wr_ptr     : in  STD_LOGIC_VECTOR(4 downto 0);
        decode_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end decoder_5to32;


architecture Behavioral of decoder_5to32 is
begin
    process(wr_ptr)
    begin
        decode_out <= (others => '0'); 

        case wr_ptr is
            when "00000" => decode_out(0)  <= '1';
            when "00001" => decode_out(1)  <= '1';
            when "00010" => decode_out(2)  <= '1';
            when "00011" => decode_out(3)  <= '1';
            when "00100" => decode_out(4)  <= '1';
            when "00101" => decode_out(5)  <= '1';
            when "00110" => decode_out(6)  <= '1';
            when "00111" => decode_out(7)  <= '1';
            when "01000" => decode_out(8)  <= '1';
            when "01001" => decode_out(9)  <= '1';
            when "01010" => decode_out(10) <= '1';
            when "01011" => decode_out(11) <= '1';
            when "01100" => decode_out(12) <= '1';
            when "01101" => decode_out(13) <= '1';
            when "01110" => decode_out(14) <= '1';
            when "01111" => decode_out(15) <= '1';
            when "10000" => decode_out(16) <= '1';
            when "10001" => decode_out(17) <= '1';
            when "10010" => decode_out(18) <= '1';
            when "10011" => decode_out(19) <= '1';
            when "10100" => decode_out(20) <= '1';
            when "10101" => decode_out(21) <= '1';
            when "10110" => decode_out(22) <= '1';
            when "10111" => decode_out(23) <= '1';
            when "11000" => decode_out(24) <= '1';
            when "11001" => decode_out(25) <= '1';
            when "11010" => decode_out(26) <= '1';
            when "11011" => decode_out(27) <= '1';
            when "11100" => decode_out(28) <= '1';
            when "11101" => decode_out(29) <= '1';
            when "11110" => decode_out(30) <= '1';
            when others => decode_out(31) <= '1';
        end case;
    end process;
end Behavioral;
