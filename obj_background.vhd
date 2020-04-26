library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obj_background is port(
  clock: in std_logic;
  sw: in std_logic_vector(7 downto 0);

  tile_x: in integer;
  tile_y: in integer;
  
  
  object_on: out std_logic;
  object_rgb: out std_logic_vector(7 downto 0)

 ); end obj_background;

architecture Behavioral of obj_background is
	constant TILES_X: integer := 60;
	constant TILES_Y: integer := 60;
	signal pixels_on: std_logic := '0';
	signal sw_buf, pixels_rgb: std_logic_vector(7 downto 0);


begin
  sw_buf <= sw;
    -- background, switch controlled
  scan_area: process(clock) begin
		if rising_edge(clock) then
			 if ( 
				 (tile_x >= 0) and 
				 (tile_x < TILES_X) and 
				 (tile_y >= 0) and 
				 (tile_y < TILES_Y ))
			 then  pixels_on <= '1' ;
			 else pixels_on <='0';
			 end if;
			 pixels_rgb <= sw_buf;
		end if;

	object_on <= pixels_on;
	object_rgb <= pixels_rgb;
	end process;
 end Behavioral;