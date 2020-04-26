library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obj_grid is port(
  clock: in std_logic;

  x: in integer range 0 to 1023;
  y: in integer range 0 to 1023;
  tile_x: in integer range 0 to 60;
  tile_y: in integer range 0 to 60;
  
  object_on: out std_logic;
  object_rgb: out std_logic_vector(7 downto 0)

 ); end obj_grid;

architecture Behavioral of obj_grid is
	constant TILE_SIZE: integer := 8;
	constant grid_rgb: std_logic_vector(7 downto 0) := "11111111";
	
	signal pgrid_on, tgrid_on, grid_on: std_logic;
	signal x_grd, y_grd, tx_grd, ty_grd: integer range 0 to 7 := 0;

begin
  pixel_grid: process(clock) begin
		if rising_edge(clock) then
			x_grd <= x mod TILE_SIZE;
			y_grd <= y mod TILE_SIZE;
			if((x_grd = 0) and (y_grd = 0))
			then pgrid_on <= '1';
			else pgrid_on <= '0';
			end if;
		end if;
  end process;
  
  tile_grid: process(clock) begin
	if rising_edge(clock) then
			tx_grd <= tile_x mod 4;
			ty_grd <= tile_y mod 4;
			if((tx_grd = 0) and (ty_grd = 0))
			then 
				tx_grd <= x mod 2;
				ty_grd <= y mod 2;
				if((tx_grd = 0) and (ty_grd = 0))
				then tgrid_on <= '1';
				else tgrid_on <= '0';
				end if;
			else tgrid_on <= '0';
			end if;
		end if;
  end process;

	process (pgrid_on, tgrid_on) begin
		if( (pgrid_on = '1') or (tgrid_on = '1') )
		then grid_on <= '1';
		else grid_on <= '0';
		end if;
	end process;
	
	object_on <= grid_on;
	object_rgb <= grid_rgb;
 end Behavioral;