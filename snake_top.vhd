
--/* https://langster1980.blogspot.com/2015/08/driving-vga-port-using-elbert-v2-and_7.html */

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_top is
    port (
        -- the 12MHz input clock
        Clk : IN STD_LOGIC;

        -- switch inputs to change bg color
        sw : in std_logic_vector(7 downto 0);

        -- output to the vga connector
        hsync : OUT STD_LOGIC;
        vsync : OUT STD_LOGIC;
        rgb   : OUT STD_LOGIC_VECTOR(7 downto 0);

        -- controller buttons
        UP: in std_logic;
        DOWN: in std_logic;
        LEFT: in std_logic;
        RIGHT: in std_logic;
        START: in std_logic;
        RESET: in std_logic
    );

end snake_top;

architecture Behavioral of snake_top is
	-- Internal register to store the colour required
        signal clr: std_logic_vector(7 downto 0);

     -- location of the next pixel
        signal x_next: integer range 0 to 1023 := 641;
        signal y_next: integer range 0 to 1023 := 480;


    component clocking
        port(
			--/*Input clock of 12MHz */
			CLKIN_IN         : in     std_logic;
			CLKFX_OUT          : out    std_logic
        );
    end component;

	 component vga_controller is
    port ( clock: in  std_logic;

           hsync : out  std_logic;
           vsync : out  std_logic;

	        pixle: in  std_logic_vector(7 downto 0);
           rgb : out  std_logic_vector (7 downto 0);

			  pos_x: out integer range 0 to 1023 := 641;
			  pos_y: out integer range 0 to 1023 := 480
          );
	end component;

	component snake_game is
	port(
		clock: in std_logic;
		sw: in std_logic_vector(7 downto 0);

		hcounter: in integer range 0 to 1023;
		vcounter: in integer range 0 to 1023;

		pixels : out std_logic_vector(7 downto 0);
		UP: in std_logic;
		DOWN: in std_logic;
		LEFT: in std_logic;
		RIGHT: in std_logic;
		START: in std_logic;
		RESET: in std_logic
	);
	end component;


	 signal clock   : std_logic := '0';

begin

    gameClock: clocking
    port map (
        CLKIN_IN        => Clk,
        CLKFX_OUT       => clock
    );

    vgaController: entity work.vga_controller
		port map(
			clock => clock,
			hsync => hsync,
			vsync => vsync,
			pixle => clr,
			rgb => rgb,
			pos_x => x_next,
			pos_y => y_next
		);

	snakeGame: entity work.snake_game
		port map(
			clock =>  clock,
			sw => sw,
			x_next  =>  x_next,
			y_next => y_next,
			pixels  => clr,
			UP => UP,
			DOWN => DOWN,
			LEFT => LEFT,
			RIGHT => RIGHT,
			START => START,
			RESET => RESET
		);

end architecture Behavioral;
