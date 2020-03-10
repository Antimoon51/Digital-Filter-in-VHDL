----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:17:42 03/04/2020 
-- Design Name: 
-- Module Name:    D-FlipFlop - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
Library IEEE;
USE IEEE.Std_logic_1164.all;

entity RisingEdge_DFlipFlop_SyncReset is 

	generic(
		input_width	: integer := 16;
		output_width: integer := 16
	);
	
   port(
      Q 				: out std_logic_vector(input_width-1 downto 0);
	   D 				: in 	std_logic_vector(output_width-1 downto 0);   
      Clk 			: in 	std_logic;  
		sync_reset	: in 	std_logic   
   );
end RisingEdge_DFlipFlop_SyncReset;

architecture Behavioral of RisingEdge_DFlipFlop_SyncReset is  
begin  
 process(Clk)
 begin 
   if(rising_edge(Clk)) then
		if(sync_reset='1') then 
			Q <= (others =>'0');
		else 
			Q <= D; 
		end if;
   end if;       
 end process;  
end Behavioral; 