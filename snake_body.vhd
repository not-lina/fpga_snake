library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity snake_body is port(
	clock: in std_logic;
	-- current head position
	head_x: in integer range 0 to 60;
	head_y: in integer range 0 to 60;
	new_loc: in std_logic;
	
	-- current cursor poition
	cur_x: in integer range 0 to 60;
	cur_y: in integer range 0 to 60;
	
	-- cursor is within a body tile
	object_on: out std_logic
);
end snake_body;

architecture Behavioral of snake_body is
	constant BODY_SIZE: integer := 5;
	signal has_loc: std_logic := '0';
	
  -- declare our array
  type ram_type is array (0 to BODY_SIZE ) of integer range 0 to 60;
  signal ramx : ram_type;
  signal ramy : ram_type;
  
  -- declare our pointers
  subtype index_type is integer range 0 to BODY_SIZE;
  signal head : index_type := 0;
  signal tail : index_type := 0;
  
  -- Increment and wrap
  procedure incr(signal index : inout index_type) is
  begin
    if index = BODY_SIZE then
      index <= 0;
    else
      index <= index + 1;
    end if;
  end procedure;
  
begin

	-- Update the head pointer in write
  PROC_HEAD : process(clock, new_loc) begin
    if rising_edge(clock) then
      if (new_loc = '1') then 
			ramx(head) <= head_x;
			ramy(head) <= head_y;
			incr(head);
      end if;
    end if;
  end process;

  PX_TEST: process(clock, cur_x, cur_y) begin
		if rising_edge(clock) then 
				if ((ramx(tail) = cur_x) and 
					(ramy(tail) = cur_y))
				then has_loc <= '1';
				else has_loc <= '0';
					  incr(tail);
				end if;

		end if;
  end process;
  
  object_on <= has_loc;
end Behavioral;

