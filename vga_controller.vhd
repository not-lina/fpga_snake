-- vga_controller.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library work;

entity vga_controller is port (
    -- 50MHz clock
    clock: in  std_logic;

    -- outputs to display
    rgb : out  std_logic_vector (7 downto 0);
    hsync : out  std_logic;
    vsync : out  std_logic;

    -- colored pixel input from game logic
    pixle: in  std_logic_vector(7 downto 0);

    -- output for game logic to determine color of next pixels
    pos_x: out integer range 0 to 1023 := 641;
    pos_y: out integer range 0 to 1023 := 480
); end vga_controller;

architecture Behavioral of vga_controller is
    constant PIXLES: integer := 799;
    constant SCANLINES: integer := 524;

    constant MAX_X: integer := 480;
    constant MAX_Y: integer := 640;

    constant V_SYNC_START: integer := 490;
    constant V_SYNC_END: integer := 492;

    constant H_SYNC_START: integer := 656;
    constant H_SYNC_END: integer := 752;

    signal rgb_out: std_logic_vector(7 downto 0);
    signal sync_h, sync_v: std_logic := '0';


    signal hCount: integer range 0 to PIXLES := MAX_Y;
    signal vCount: integer range 0 to SCANLINES := MAX_X;

    signal nextHCount: integer range 0 to PIXLES := 641;
    signal nextVCount: integer range 0 to SCANLINES := 481;

	signal divide_by_2 : std_logic := '0';

begin
    vga_signal: process(clock) begin
        if rising_edge(clock) then
            -- divide down the clock from 50 MHz to 25 MHz
            if divide_by_2 = '1' then

                -- Has an entire scanline been displayed?
                if(hCount = PIXLES)
                    then hCount <= 0;
                        -- Has an entire frame been displayed?
                        if(vCount = SCANLINES)
                            then vCount <= 0;
                            else vCount <= vCount + 1;
                        end if;
                else hCount <= hCount + 1;
                end if;

                if (nextHCount = PIXLES)
                    then nextHCount <= 0;

                    if (nextVCount = SCANLINES)
                        then nextVCount <= 0;
                        else nextVCount <= vCount + 1;
                    end if;

                else nextHCount <= hCount + 1;
                end if;

                -- vertical sync signal
                if (vCount >= V_SYNC_START and vCount < V_SYNC_END)
                    then sync_v <= '0';
                    else sync_v <= '1';
                end if;

                -- horizontal sync signal
                if (hCount >= H_SYNC_START and hCount < H_SYNC_END)
                    then sync_h <= '0';
                    else sync_h <= '1';
                end if;

                -- we are within the display area
                if (hCount < MAX_Y and vCount < MAX_X)
                then
                    rgb_out <= pixle;
                end if;
            end if;

            divide_by_2 <= not divide_by_2;
        end if;
    end process;

    rgb <= rgb_out;
    hsync <= sync_h;
    vsync <= sync_v;
    pos_x <= nextHCount;
    pos_y <= nextVCount;

end architecture Behavioral;
