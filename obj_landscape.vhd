library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obj_landscape is port(
  clock: in std_logic;

  tile_x: in integer range 0 to 60;
  tile_y: in integer range 0 to 60;
  
  object_on: out std_logic;
  object_rgb: out std_logic_vector(7 downto 0)

 ); end obj_landscape;

architecture Behavioral of obj_landscape is
	constant TILE_SIZE: integer := 8;
	constant wall_rgb: std_logic_vector(7 downto 0) := "00000011";
	
	constant TILES_X: integer := 60;
	constant TILES_Y: integer := 60;
	constant WALL_THICKNESS: integer := 2;
	
	signal wall_on: std_logic;


begin
  outer_wall: process(clock) begin
	if rising_edge(clock) then
		if( (tile_x >= WALL_THICKNESS) and
			 (tile_x < TILES_X-WALL_THICKNESS) and
			 (tile_y >= WALL_THICKNESS ) and
			 (tile_y < TILES_Y-WALL_THICKNESS)) 
		then wall_on <= '0';
		else wall_on <= '1';
		end if;
   end if;
  end process;

	object_on <= wall_on;
	object_rgb <= wall_rgb;
 end Behavioral;