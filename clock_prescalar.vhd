-- clock_prescalar.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;

entity ClockPrescaler is
    port(
        clock   : in STD_LOGIC; -- 50 Mhz
		  enable : in STD_LOGIC;
        tick     : out STD_LOGIC
    );
end ClockPrescaler;


architecture Behavioral of ClockPrescaler is
    signal prescaler: unsigned(23 downto 0) := X"000000";
    signal newClock, divided : std_logic := '0';
begin

    tick <= newClock;

	 divideClock: process(clock, divided) begin
		if rising_edge(clock) then
			divided <= not divided;
		end if;
	 end process;

    countClock: process(clock, newClock)
    begin
        if rising_edge(clock) and enable = '1' then
				if(divided = '1') then
            if(prescaler =  X"BEBC20") then
                prescaler   <= (others => '0');
                newClock <= not newClock;

             else
					prescaler <= prescaler + "1";
            end if;
        end if;
		  end if;
    end process;


end Behavioral;
