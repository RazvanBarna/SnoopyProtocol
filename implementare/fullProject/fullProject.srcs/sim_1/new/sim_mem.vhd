library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Mem is
end tb_Mem;

architecture Behavioral of tb_Mem is
    -- Semnale pentru DUT
    signal clk : std_logic := '0';
    signal memWrite, En, wb, readWriteCC : std_logic := '0';
    signal AluRes, Rd2 : std_logic_vector(31 downto 0) := (others => '0');
    signal data_fromCC : std_logic_vector(65 downto 0) := (others => '0');
    signal send_data_to_bus, line_debug : std_logic_vector(65 downto 0);
    signal useCC : std_logic;
    signal memData, aluResOut : std_logic_vector(31 downto 0);
    
    -- Component declaration

component Mem0 is
   Port (memWrite,En,clk,wb,readWriteCC: in std_logic;
         AluRes,Rd2: in std_logic_vector(31 downto 0);
         data_fromCC : in std_logic_vector(65 downto 0);
         send_data_to_bus,line_debug : out std_logic_vector(65 downto 0) ; 
         useCC: out std_logic;
         memData,aluResOut: out std_logic_vector(31 downto 0));
end component;

begin
    -- Instantiere DUT
    DUT: Mem0
        port map(
            clk => clk,
            memWrite => memWrite,
            En => En,
            wb => wb,
            readWriteCC => readWriteCC,
            AluRes => AluRes,
            Rd2 => Rd2,
            data_fromCC => data_fromCC,
            send_data_to_bus => send_data_to_bus,
            useCC => useCC,
            line_debug => line_debug,
            memData => memData,
            aluResOut => aluResOut
        );

    -- Clock process - 10ns period
    clk_process: process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;


    main_process: process
    begin
--        en <='1';
--        wb <='1';
--        readWriteCC <= '0';
--        data_fromCC <= "00" &X"09877" & "10" & "000100" & "0000" & X"11000055"; --S
--       wait for 20 ns; --load , ar trb sa citesc asta cu wb 
        
        
--        --read simplu
--        wb <='0';
--        aluRes <= x"00000000";
--        Rd2 <= x"00000000";
--        memWrite <='0';
--        readWriteCC <='0';
--        wait for 20 ns;
        
--        Rd2 <= (others =>'0');
--        wb <='1';
         en <='1';
        readWriteCC <= '1';
        memWrite <= '1';
        Rd2 <= X"99900055";
        data_fromCC <= (others => '0'); --M scriu in memorie nu conteaza dataFromCC
        wait for 20 ns; -- wb merge ,scrie in memorie
--        en <='1';
--        wb <= '0';
--        readWriteCC <='1';
--        memWrite <='1';
--        --data_fromCC <= "00" &X"09877" & "10" & "000100" & "0000" & X"99900055"; nu e nevoie
--        wait for 20 ns ; 

        
        -- ar trb sa se activeze ucc ca poate fi wb 
    --        --functioneaza totul
        
        
 
    end process;

end Behavioral;