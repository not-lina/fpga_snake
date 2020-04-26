library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obj_mux is port
 (
  -- Assuming 50MHz clock.If the clock is reduced then it might give the unexpected output.
  clock: in std_logic;
  pixels_on, wall_on, grid_on, snake_on: in std_logic;
  pixels_rgb, grid_rgb, wall_rgb, snake_rgb: in std_logic_vector(7 downto 0);

  rgb_out: out std_logic_vector(7 downto 0)
 ); end obj_mux;

architecture Behavioral of obj_mux is
	signal selected_rgb: std_logic_vector(7 downto 0);

begin

	process (pixels_on, pixels_rgb,
			grid_on, grid_rgb,
			wall_on, wall_rgb,
			snake_on, snake_rgb) begin
		if (pixels_on = '0') then selected_rgb <= "00000000"; -- blank
		else
		   if (grid_on = '1') then selected_rgb <= grid_rgb;
			elsif (wall_on = '1') then selected_rgb <= wall_rgb;
			elsif (snake_on = '1') then selected_rgb <= snake_rgb;
			else selected_rgb <= pixels_rgb;
			end if;
		end if;
	end process;

	rgb_out <= selected_rgb;
 end Behavioral;
