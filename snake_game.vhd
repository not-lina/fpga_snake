library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_game is port
 (
  -- Assuming 50MHz clock.If the clock is reduced then it might give the unexpected output.
  clock: in std_logic;
  sw: in std_logic_vector(7 downto 0);
  -- The counter tells whether the correct position on the screen is reached where the data is to be displayed.
  x_next: in integer range 0 to 1023;
  y_next: in integer range 0 to 1023;
  -- Output the colour that should appear on the screen.
  pixels : out std_logic_vector(7 downto 0);
  UP: in std_logic;
  DOWN: in std_logic;
  LEFT: in std_logic;
  RIGHT: in std_logic;
  START: in std_logic;
  RESET: in std_logic
 ); end snake_game;

architecture Behavioral of snake_game is
	-- tile mesh 
	constant TILE_SIZE: integer := 8;
	constant TILES_X: integer := 60;
	constant TILES_Y: integer := 60;

	-- object signals indicate if we are within on eof the objects
	signal pixels_on, wall_on, grid_on, snake_on: std_logic;
	signal pixels_rgb, grid_rgb, wall_rgb, snake_rgb: std_logic_vector(7 downto 0);
	 
	-- Intermediate register telling the exact position on display on screen.
	signal x : integer range 0 to 1023 := 0;
	signal y : integer range 0 to 1023 := 0;
	signal tile_x,tile_y: integer;


begin
	grid_object: entity work.obj_grid
    port map(
        clock =>  clock,
		  x => x,
		  y => y,
		  tile_x => tile_x,
		  tile_y => tile_y,
		  object_on => grid_on,
		  object_rgb => grid_rgb
    );
	 
	 landscape_obj: entity work.obj_landscape
    port map(
        clock =>  clock,
		  tile_x => tile_x,
		  tile_y => tile_y,
		  object_on => wall_on,
		  object_rgb => wall_rgb
    );
	 
	 snake_obj: entity work.obj_snake
	 port map(
		clock =>  clock,
		tile_x => tile_x,
		tile_y => tile_y,
		object_on => snake_on,
		object_rgb => snake_rgb,
		UP => UP,
		DOWN => DOWN,
		LEFT => LEFT,
		RIGHT => RIGHT,
		START => START,
		RESET => RESET
	 );
	 
	 bg_obj: entity work.obj_background
	 port map(
		clock => clock,
		sw => sw,
		tile_x => tile_x,
		tile_y => tile_y,
		object_on => pixels_on,
		object_rgb => pixels_rgb
	 );

  x <= x_next;
  y <= y_next;
  tile_x <= x_next / TILE_SIZE;
  tile_y <= y_next / TILE_SIZE;
  
	display_out: entity work.obj_mux
	port map(
		clock => clock,
		pixels_on => pixels_on, 
		pixels_rgb => pixels_rgb, 
		grid_on => grid_on, 
		grid_rgb => grid_rgb,
		wall_on => wall_on, 
		wall_rgb => wall_rgb,
		snake_on => snake_on, 
		snake_rgb => snake_rgb,
		rgb_out => pixels
	);

 end Behavioral;