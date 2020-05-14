-------------------------------------------------------------------------------------------------------------
-- Company: 			HTWK Leipzig
-- Engineer: 			Trung Hoang Nguyen
-- 
-- Create Date:   	16:33 04/05/2020 german
-- Module Name:   	Schaltkreisentwurf SKE 
-- Project Name: 		FIR_Filter	
-- Target Devices:	Kintex-7 XC7K70T
-- Tool versions:		Xilinx ISE 14.7
-- Description: 		Testbench
--
--
-------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;
	USE STD.TEXTIO.ALL;
	USE work.FIR_Filter_2_package.all;

ENTITY testbench IS
END testbench;

ARCHITECTURE behavior OF testbench IS 

-- Component Declaration
   COMPONENT FIR_Filter_2
   PORT(
            input_port		: in 	signed(input_width-1 downto 0);
				output_port		: out signed(output_width-1 downto 0);
				clk 				: in 	std_logic;
				sync_reset 		: in 	std_logic
             );
   END COMPONENT;
   --Inputs
   signal input_port 	: signed(input_width-1 downto 0);			
   signal Clk 				: std_logic;
   signal sync_reset 	: std_logic;

   --Outputs
   signal output_port 	: signed(output_width-1 downto 0);
   signal output_ready  : std_logic := '0';
   -- Clock period definitions
   constant Clk_period 	: time := 1 ms;                                       				  
	
   -- Files
   file input_txt: TEXT open Read_mode is "ECG_signal_2.txt";
   file output_txt: TEXT open Write_mode is "ECG_result_2.txt";
	

BEGIN

-- Component Instantiation
        uut: FIR_Filter_2 PORT MAP(
                input_port => input_port,
                output_port => output_port,
					 clk => clk,
					 sync_reset => sync_reset
        );

-- Clock process definitions
Clock: process(clk, sync_reset)
   begin 
	if sync_reset = '0' then 
  		Clk  <= '0';
  	else
		Clk  <= not Clk after Clk_period/2;
   end if;		
   end process;
			
sync_reset <= '0', '1' after 200 ns;
	
  	-- Read data by rising edge of clock
	DATA_input: process(clk)
	variable my_input_line 	: LINE;  
	variable input_values	: real;		
	begin 
		if sync_reset = '0' then
			input_port 		<= (others => '0');
			output_ready 	<= '0';
		elsif rising_edge(clk) then
			readline(input_txt, my_input_line);  						
         read(my_input_line, input_values);          					
			input_port <= to_signed(integer(input_values*512.0*1000.0),input_port'length);   				
         output_ready 	<= '1';  
      end if;  
   end process;
		
	-- Write data by falling edge of clock
	DATA_ouput: process(clk)
	variable my_output_line : LINE;  
	begin
		if falling_edge(clk) then
			if output_ready = '1' then
				write(my_output_line, real(to_integer(output_port))/(32768.0*10.0)) ;  		
            writeline(output_txt, my_output_line);                               	
         end if;  
      end if;  
   end process;
END;
