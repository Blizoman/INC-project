-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Andrej Bliznak (xblizna00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;



-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is
    signal clock_cnt      : std_logic_vector(4 downto 0) := "00000"; -- pocitadlo taktov (0-31)
    signal bit_cnt        : std_logic_vector(3 downto 0) := "0000"; -- pocitadlo DATA bitov (0-15)
    signal clk_cnt_on     : std_logic := '0'; -- zapnutie "CLOCK_COUNTER"
    signal bit_on         : std_logic := '0'; -- zapnutie "BIT_COUNTER"
    signal verify         : std_logic := '0'; -- konecna validacia po STOP bite
    begin

    -- Pripojenie FSM 
    fsm: entity work.UART_RX_FSM
    port map (
        CLK             => CLK,
        RST             => RST,
        DIN             => DIN,
        BIT_COUNTER     => bit_cnt,
        CLOCK_COUNTER   => clock_cnt,
        CLOCK_CNT_ON    => clk_cnt_on,
        READING_BIT_ON  => bit_on,
        VERIFICATION    => verify
    );


    -- Hlavny proces pre spracovanie dat
    process (CLK)
    begin
        if RST = '1' then
            clock_cnt <= "00000"; -- reset vsetkych signalov
            bit_cnt <= "0000";
            DOUT <= (others => '0');
            DOUT_VLD <= '0';
        elsif rising_edge(CLK) then -- pocitanie taktov pocas aktivneho stavu
            if clk_cnt_on = '1' then
                clock_cnt <= clock_cnt + 1;
            else
                clock_cnt <= "00000";
            end if;
            
            if clock_cnt = "11000" then -- vzorkovanie "mid bitu"
                clock_cnt <= "01111";
            end if;
            
            -- Zapisovanie dátových bitov
            if bit_on = '1' then 
                if clock_cnt = "01111" then -- vzorkovanie na 15. takte
                    clock_cnt <= "00000";   -- reset pre dalsi bit
                    case bit_cnt is
                        when "0000" => DOUT(0) <= DIN;
                        when "0001" => DOUT(1) <= DIN;
                        when "0010" => DOUT(2) <= DIN;
                        when "0011" => DOUT(3) <= DIN;
                        when "0100" => DOUT(4) <= DIN;
                        when "0101" => DOUT(5) <= DIN;
                        when "0110" => DOUT(6) <= DIN;
                        when "0111" => DOUT(7) <= DIN;
                        when others => null;
                    end case;
                    bit_cnt <= bit_cnt + 1; -- swap na dalsi bit
                end if;
            end if;
            
            if bit_on = '0' then -- "reset bit_counteru" 
                bit_cnt <= "0000";
            end if;

            DOUT_VLD <= verify; 

        end if;
    end process;

end architecture;
