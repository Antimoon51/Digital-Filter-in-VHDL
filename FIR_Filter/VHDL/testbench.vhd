-------------------------------------------------------------------------------------------------------------
-- Company: 		HTWK Leipzig
-- Engineer: 		Trung Hoang Nguyen
-- 
-- Create Date:    	16:33 04/05/2020 german
-- Module Name:    	Schaltkreisentwurf SKE 
-- Project Name: 	FIR_Filter	
-- Target Devices: 	Kintex-7 XC7K70T
-- Tool versions: 	Xilinx ISE 14.7
-- Description: 	Testbench
--
--
-------------------------------------------------------------------------------------------------------------
LIBRARY IEEE;
	USE IEEE.std_logic_1164.ALL;																		-- data types(signed, std_logic) & rising_edge(Clk)/falling_edge(Clk) similar to Clk'event and Clk = '1'/'0'
	USE IEEE.numeric_std.all;  																		-- arithmetic operation for signed
	Use STD.TEXTIO.all;																					-- read & write files

ENTITY FIR_Filter_TB IS
	GENERIC(
		input_width		: positive	:= 16;
		output_width		: positive	:= 32
	);
END FIR_Filter_TB;
 
ARCHITECTURE behavior OF FIR_Filter_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT FIR_Filter
	GENERIC(
		input_width		: positive	:= 16;
		output_width		: positive	:= 32;
		taps			: positive	:= 128;
		coefficient_width 	: positive	:= 16 
	);
    	PORT(
         	D_IN 			: IN  signed(input_width-1 downto 0);
         	D_OUT 			: OUT signed(output_width-1 downto 0);
         	Clk 			: IN  std_logic;
         	sync_reset 		: IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal D_IN 		: signed(input_width-1 downto 0) := (others => '0');			-- initiate signal := '00..0'
   signal Clk 		: std_logic := '0';
   signal sync_reset 	: std_logic := '1';

   --Outputs
   signal D_OUT 	: signed(output_width-1 downto 0);
   signal output_ready  : std_logic := '0';
 
   -- Clock period definitions
   constant Clk_period 	: time := 1 ms;                                       			-- Clock frequency = 1000Hz  
	
   -- Files
   file input_txt: TEXT open Read_mode is "ECG_signal.txt";
   file output_txt: TEXT open Write_mode is "ECG_result.txt";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   	uut: FIR_Filter 
	GENERIC MAP(
			input_width		=> 	16,
			output_width		=>	32,
			taps			=>	128,
			coefficient_width 	=> 	16 
	)
	PORT MAP(
          		D_IN 			=> 	D_IN,
          		D_OUT 			=> 	D_OUT,
          		Clk 			=> 	Clk,
          		sync_reset 		=> 	sync_reset
        );

	-- Clock process definitions
     	Clock: process(clk, sync_reset)
       	begin 
  		if sync_reset = '1' then 
  			Clk  <= '0';
  		else
  			Clk  <= not Clk after Clk_period/2;
  		end if;		
       	end process;

sync_reset <= '1', '1' after 100 ns, '0' after 503 ns;
	
  	-- Read data by rising edge of clock
	DATA_input: process(Clk)
	variable my_input_line 	: LINE;  
	variable input_values	: real;		
	begin 
		if sync_reset = '1' then
			D_IN 		<= (others => '0');
			output_ready 	<= '0';
		elsif rising_edge(Clk) then
			readline(input_txt, my_input_line);  							-- (file, line)
            		read(my_input_line, input_values);          						-- (line, data_values)
			D_IN <= to_signed(integer(input_values*512.0),D_IN'length);   				-- real to signed
            		output_ready 	<= '1';  
         end if;  
      end process;
		
	-- Write data by falling edge of clock
	DATA_ouput: process(Clk)
	variable my_output_line : LINE;  
	begin
		if falling_edge(Clk) then
			if output_ready = '1' then
				write(my_output_line, real(to_integer(D_OUT))/32768.0) ;  			-- (line, data_values) & signed to real
               			writeline(output_txt, my_output_line);                               		-- (file, line)
            		end if;  
        	end if;  
      end process;
END;
