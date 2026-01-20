-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Andrej Bliznak (xblizna00)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity UART_RX_FSM is
    port (
        CLK            : in std_logic;   -- clock signal
        RST            : in std_logic;   -- reset 
        DIN            : in std_logic;   -- input signal
        BIT_COUNTER    : in std_logic_vector(3 downto 0);   -- pocitadlo pre DATA bity (0-15)
        CLOCK_COUNTER  : in std_logic_vector(4 downto 0);   -- pocitadlo pre takty (0-31)
        CLOCK_CNT_ON   : out std_logic;  -- zapnutie "CLOCK_COUNTER"
        READING_BIT_ON : out std_logic;  -- zapnutie "BIT_COUNTER"
        VERIFICATION   : out std_logic   -- konecna validacia po STOP bite
    );
end entity;

-- Architektura FSM
architecture behavioral of UART_RX_FSM is

    -- Stavy automatu
    type state_type is (IDLE, STARTING, MID_START, DATA, STOPPING, VALID);
    signal state : state_type := IDLE;

    begin

        -- Sekvencna cast obvodu
        process (CLK)
        begin
            if RST = '1' then
                state <= IDLE; -- pri resete navrat do stavu IDLE
            elsif rising_edge(CLK) then
                case state is
                    when IDLE =>
                        if DIN = '0' then -- cakanie na START bit 
                            state <= STARTING; -- prechod do STARTING stavu
                        end if;
        
                    when STARTING =>
                        if CLOCK_COUNTER = "01000" then -- po 8 taktoch prechod do MID_START
                            state <= MID_START;
                        end if;
        
                    when MID_START =>
                        if CLOCK_COUNTER = "11000" then -- po 24 taktoch prechod do DATA (koniec start bitu + 8)
                            state <= DATA;
                        end if;
        
                    when DATA =>
                        if BIT_COUNTER = "1000" then -- citanie 8 datovych bitov
                            state <= STOPPING;
                        end if;
        
                    when STOPPING =>
                        if CLOCK_COUNTER = "01111" then
                            if DIN = '1' then -- po 15 taktoch ak je vstupny signal na 1 prechadzame do VALID
                                state <= VALID;
                            end if;
                        end if;
        
                    when VALID =>
                        state <= IDLE;
        
                    when others =>
                        state <= IDLE;
                end case;
            end if;
        end process;
    
        CLOCK_CNT_ON    <= '1' when state = STARTING or state = MID_START or state = DATA or state = STOPPING else '0';
        READING_BIT_ON  <= '1' when state = DATA else '0';
        VERIFICATION    <= '1' when state = VALID else '0';
    
end architecture;