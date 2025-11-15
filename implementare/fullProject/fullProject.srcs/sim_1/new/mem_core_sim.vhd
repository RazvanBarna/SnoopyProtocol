library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Mem is
end tb_Mem;

architecture sim of tb_Mem is
    -- componenta testată
    component Mem
        Port (
            memWrite, En, clk, wb, readWriteCC : in std_logic;
            AluRes, Rd2 : in std_logic_vector(31 downto 0);
            data_fromCC : in std_logic_vector(65 downto 0);
            send_data_to_bus : out std_logic_vector(65 downto 0);
            line_index : out std_logic_vector(5 downto 0);
            line_indexCc : in std_logic_vector(5 downto 0);
            memData, aluResOut : out std_logic_vector(31 downto 0)
        );
    end component;

    -- semnale locale
    signal memWrite, En, clk, wb, readWriteCC : std_logic := '0';
    signal AluRes, Rd2, memData, aluResOut : std_logic_vector(31 downto 0) := (others => '0');
    signal data_fromCC, send_data_to_bus : std_logic_vector(65 downto 0) := (others => '0');
    signal line_index, line_indexCc : std_logic_vector(5 downto 0) := (others => '0');

begin
    -- Instanțierea memoriei cache
    uut: Mem
        port map (
            memWrite => memWrite,
            En => En,
            clk => clk,
            wb => wb,
            readWriteCC => readWriteCC,
            AluRes => AluRes,
            Rd2 => Rd2,
            data_fromCC => data_fromCC,
            send_data_to_bus => send_data_to_bus,
            line_index => line_index,
            line_indexCc => line_indexCc,
            memData => memData,
            aluResOut => aluResOut
        );

    -- Clock 10ns
    clk_process : process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- Stimuli
    stim_proc : process
    begin
        wait for 20 ns;

        -- 1️⃣ Caz: scriere în linie Modified (M)
        En <= '1';
        memWrite <= '1';
        readWriteCC <= '1'; -- CPU scrie
        AluRes <= x"00000010"; -- adresa -> index = 4
        Rd2 <= x"AAAAAAAA";
        wait for 10 ns;

        -- 2️⃣ Caz: scriere în linie Shared (S) sau Invalid (I)
        -- forțăm manual starea ca să testăm (în practică ar fi în m)
        -- simulăm adresa 8 (index = 2)
        AluRes <= x"00000008"; 
        wait for 10 ns;

        -- 3️⃣ Caz: write-back (primire linie de la controller)
        memWrite <= '0';
        wb <= '1';
        readWriteCC <= '0'; -- vine de la controller
        line_indexCc <= "000101"; -- linia 5
        data_fromCC <= "10" & x"00000055" & "0100" & "0000" & x"BEEFFF";
        wait for 10 ns;

        -- 4️⃣ Citire asincronă
        wb <= '0';
        memWrite <= '0';
        readWriteCC <= '1';
        AluRes <= x"00000014"; -- altă adresă
        wait for 10 ns;

        -- stop
        wait;
    end process;

end sim;
