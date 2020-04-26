library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity obj_snake is port(
  clock: in std_logic;
  tile_x: in integer range 0 to 60;
  tile_y: in integer range 0 to 60;
  object_on: out std_logic;
  object_rgb: out std_logic_vector(7 downto 0);
  UP: in std_logic;
  DOWN: in std_logic;
  LEFT: in std_logic;
  RIGHT: in std_logic;
  START: in std_logic;
  RESET: in std_logic

 ); end obj_snake;

architecture Behavioral of obj_snake is
	constant TILE_SIZE: integer := 8;
	constant head_rgb: std_logic_vector(7 downto 0) := "11100000";
	signal body_rgb: std_logic_vector(7 downto 0) := "11000110";

	constant TILES_X: integer := 60;
	constant TILES_Y: integer := 60;
	constant WALL_THICKNESS: integer := 2;
	
	signal head_pos_x: integer := 3;
	signal head_pos_y: integer := 3;
	signal head_moved: std_logic;
	
	signal head_on, body_on, snake_on: std_logic;
	signal snake_rgb: std_logic_vector(7 downto 0) := "00000000";
	
	signal ref_signal, b_toggle: std_logic := '0';
	
	signal running, running_next: std_logic := '0';
	type p_states is (init, is_stopped, run_p, stop_p, is_running);
	signal p_state, p_state_next: p_states := init;


begin
  press_start: process(clock) begin
	if rising_edge(clock) then
		p_state <= p_state_next;
		running <= running_next;
	end if;
  end process;
  
  press_fsm_state: process(START, running, p_state) begin
		case (p_state) is
			when init => p_state_next <= is_stopped;
			
			when is_stopped =>
				if(START = '0') then
					p_state_next <= run_p;
				else 
					p_state_next <= is_stopped;
				end if;
				
			when run_p =>
				if(START = '0') then 
					p_state_next <= run_p;
				else
					p_state_next <= is_running;
				end if;
				
			when is_running =>
				if(START = '0') then
						p_state_next <= stop_p;
					else 
						p_state_next <= is_running;
					end if;
			
			when stop_p =>
				if(START = '0') then 
					p_state_next <= stop_p;
				else
					p_state_next <= is_stopped;
				end if;
		end case;
  end process;
  
  press_fsm_out: process(START, running, p_state) begin
		case (p_state) is
			when is_stopped 	=> running_next <= '0';
			when is_running 	=> running_next <= '1';
			when others 		=> running_next <= running;
		end case;
  end process;
  
  
  animation: entity work.ClockPrescaler 
  port map(
		clock => clock,
		enable => running,
      tick => ref_signal
  );
  
  bodycolor:
  process(clock, ref_signal, b_toggle) begin
		if rising_edge(clock) then
		   if ref_signal = '1' then
			b_toggle <= not b_toggle;
			end if;
		end if;
  end process;
  
  bodytoggle:
  process(clock, b_toggle) begin
	if rising_edge(clock) then
		if(b_toggle = '1') 
			then body_rgb <= "11000110";
			else body_rgb <= "00111111";
		end if;
	end if;
  end process;
  
  head_loc: entity work.snake_head
	 port map(
		clock =>  clock,
		tick => ref_signal,
		pos_x => head_pos_x,
		pos_y => head_pos_y,
		head_moved => head_moved,
		UP => UP,
		DOWN => DOWN,
		LEFT => LEFT,
		RIGHT => RIGHT,
		START => START,
		RESET => RESET
	 );
	 
  head_obj: process(clock, head_pos_x, head_pos_y) begin
	if rising_edge(clock) then
		if( (tile_x = head_pos_x) and
			 (tile_y = head_pos_y)) 
		then head_on <= '1';
		else head_on <= '0';
		end if;
   end if;
  end process;
  
  body_loc: entity work.snake_body
  port map(
		clock => clock,
		head_x => head_pos_x,
		head_y => head_pos_y,
		new_loc => head_moved,
		cur_x => tile_x,
		cur_y => tile_y,
		object_on => body_on
  );
  
  process(clock, head_on, body_on, body_rgb) begin
	if rising_edge(clock) then
		if(head_on = '1')
		then 
			snake_on <= '1'; 
			snake_rgb <= head_rgb;
		elsif (body_on = '1')
		then 
			snake_on <= '1'; 
			snake_rgb <= body_rgb;
		else snake_on <= '0';
		end if;
   end if;
  end process;
  

	object_on <= snake_on;
	object_rgb <= snake_rgb;
 end Behavioral;