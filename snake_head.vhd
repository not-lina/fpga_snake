-- snake_head.vhd

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity snake_head is port(
  clock: in std_logic;
  tick: in std_logic;
  pos_x: out integer range 0 to 60;
  pos_y: out integer range 0 to 60;
  head_moved: out std_logic;
  UP: in std_logic;
  DOWN: in std_logic;
  LEFT: in std_logic;
  RIGHT: in std_logic;
  START: in std_logic;
  RESET: in std_logic
); end snake_head;

architecture Behavioral of snake_head is
	signal head_pos_x, head_pos_x_next: integer range 0 to 60 := 22;
	signal head_pos_y, head_pos_y_next: integer range 0 to 60 := 22;
	signal moved, moved_next: std_logic;

	type statetype is (init, iwait, up_go, up_wait, down_go, down_wait,
							 left_go, left_wait, right_go, right_wait
	);
	signal state, nextstate: statetype;
	type dir is (up_d, down_d, left_d, right_d);
	signal path, path_next: dir;

	type mv_states is( m_hold, m_ready, m_trigger );
	signal mv_state, mv_state_next : mv_states := m_hold;
	signal move, move_next: std_logic := '0';

begin
   -- handshake for animations
    move_snake: process(tick, mv_state) begin
        case(mv_state) is
            when m_hold =>
                if(tick = '1')
                then mv_state_next <= m_ready;
                else mv_state_next <= m_hold;
                end if;
                move_next <= '0';

            when m_ready =>
                mv_state_next <= m_trigger;
                move_next <= '1';

            when m_trigger =>
                if(tick = '0')
                then mv_state_next <= m_hold;
                else mv_state_next <= m_trigger;
                end if;
                move_next <= '0';

            when others =>
                mv_state_next <= m_hold;
                move_next <= '0';
        end case;
    end process;

    -- state register and fsm tick
	reg_state: process(clock) begin
		 if rising_edge(clock) then
			  state <= nextstate;
			  head_pos_x <= head_pos_x_next;
			  head_pos_y <= head_pos_y_next;
			  moved <= moved_next;
			  path <= path_next;
			  move <= move_next;
			  mv_state <= mv_state_next;
		 end if;
	end process;

	output_decode:
	process (state, head_pos_x, head_pos_y, path) begin
        case (state) is
            when init =>
                head_pos_x_next <= 22;
                head_pos_y_next <= 22;
                moved_next <= '0';
                path_next <= up_d;

            when up_go =>
                head_pos_x_next <= head_pos_x;
                head_pos_y_next <= head_pos_y + 1;
                moved_next <= '1';
                path_next <= up_d;

            when down_go =>
                head_pos_x_next <= head_pos_x;
                head_pos_y_next <= head_pos_y - 1;
                moved_next <= '1';
                path_next <= down_d;

            when right_go =>
                head_pos_x_next <= head_pos_x + 1;
                head_pos_y_next <= head_pos_y;
                moved_next <= '1';
                path_next <= right_d;

            when left_go =>
                head_pos_x_next <= head_pos_x - 1;
                head_pos_y_next <= head_pos_y;
                moved_next <= '1';
                path_next <= left_d;

            when others =>
                head_pos_x_next <= head_pos_x;
                head_pos_y_next <= head_pos_y;
                moved_next <= '0';
                path_next <= path;
        end case;
    end process;

    next_state_decode:
    process(state, move, path, UP, DOWN, LEFT, RIGHT, RESET, START) begin
        -- async reset
		if(RESET = '0') then nextstate <= init;

		-- animation ticks take presidence over user button presses
		elsif (move = '1') then
		    case (path) is
                when up_d => nextstate <= up_go;
                when down_d => nextstate <= down_go;
                when left_d => nextstate <= left_go;
                when right_d => nextstate <= right_go;
                when others => nextstate <= state;
            end case;

		else case (state) is
            when init => nextstate <= iwait;

            when iwait =>
					 if(UP='0') then nextstate <= up_go;
					 elsif (DOWN = '0') then nextstate <= down_go;
					 elsif (LEFT = '0') then nextstate <= left_go;
					 elsif (RIGHT = '0') then nextstate <= right_go;
					 else nextstate <= iwait;
					 end if;

            when up_go => nextstate <= up_wait;

            when up_wait =>
                if(UP='0')
                then nextstate <= up_wait;
                else nextstate <= iwait;
                end if;

            when down_go => nextstate <= down_wait;

            when down_wait =>
                if(DOWN='0')
                then nextstate <= down_wait;
                else nextstate <= iwait;
                end if;

            when left_go => nextstate <= left_wait;

            when left_wait =>
                if(LEFT='0')
                then nextstate <= left_wait;
                else nextstate <= iwait;
                end if;

				when right_go => nextstate <= right_wait;

            when right_wait =>
                if(RIGHT='0')
                then nextstate <= right_wait;
                else nextstate <= iwait;
                end if;

            when others => nextstate <= init;
        end case;
	    end if;
    end process;

	pos_x <= head_pos_x;
	pos_y <= head_pos_y;
	head_moved <= moved;
 end Behavioral;


