-------------------------------------------------------------------------------------------------------------
-- Company: 		HTWK Leipzig
-- Engineer: 		Trung Hoang Nguyen
-- 
-- Create Date:    	16:33 04/05/2020 german
-- Module Name:    	Schaltkreisentwurf SKE 
-- Project Name: 	FIR_Filter	
-- Target Devices: 	Kintex-7 XC7K70T
-- Tool versions: 	Xilinx ISE 14.7
-- Description: 	FIR Filter for ECG-Signal
--
--
-------------------------------------------------------------------------------------------------------------
library IEEE;
	USE IEEE.std_logic_1164.ALL;										-- data types(signed, std_logic) & rising_edge(Clk)/falling_edge(Clk) similar to Clk'event and Clk = '1'/'0'
	USE IEEE.numeric_std.all;  										-- arithmetic operation for signed

entity FIR_Filter is
	generic(
		input_width		: positive	:= 16;
		output_width		: positive	:= 32;
		taps			: positive	:= 128;
		coefficient_width 	: positive	:= 16 
	);
	port(
		D_IN			: in 	signed(input_width-1 downto 0);
		D_OUT			: out   signed(output_width-1 downto 0);
		Clk			: in 	std_logic;
		sync_reset		: in 	std_logic	
	);
end FIR_Filter;

architecture Filter_Behavioral of FIR_Filter is
-- Use D-FF as Shift-register
component RisingEdge_Register_SyncReset is						
	generic(  
		input_width		: positive	:= 16;
		output_width		: positive	:= 16 		
   		); 
   	port(  
		Q 			: out   signed(input_width-1 downto 0);
		D 			: in 	signed(output_width-1 downto 0);
		Clk 			: in 	std_logic;    
		sync_reset		: in 	std_logic
   );  
end component RisingEdge_Register_SyncReset;

-- Type definition
-- array[signed,signed,..]
type shift_reg_type is array(0 to taps-1) of signed(input_width-1 downto 0);
type mult_reg_type is array(0 to taps-1) of signed(input_width+coefficient_width-1 downto 0);
type add_reg_type is array(0 to taps-1) of signed(input_width+coefficient_width-1 downto 0);

-- Signaldeclaration
signal shift_reg_signal : shift_reg_type:= (others => (others => '0'));
signal mult_reg_signal 	: mult_reg_type	:= (others => (others => '0'));
signal add_reg_signal 	: add_reg_type 	:= (others => (others => '0'));

-----------------------------------------------FIR COEFFICIENT-----------------------------------------------
type coefficient_FIR_type is array(0 to taps-1) of signed(coefficient_width-1 downto 0);
constant coefficient_FIR : coefficient_FIR_type :=(
"0000000000000100","0000000000001000","0000000000001110","0000000000001011","1000000000010010","1000000001001110","1000000010010010","1000000010101100",
"1000000001011101","0000000010000000","0000000111000011","0000001011100010","0000001100001101","0000000110000001","1000000111101010","1000011001010101",
"1000100011100101","1000100011101000","1000010010011100","0000010110100001","0000110001110111","0000111010100110","0000111001110001","0000100111011100",
"1000101011110000","1001000101011001","1001001111000001","1001001101010010","1000111010000000","0000111110000110","0001010110101110","0001100000001000",
"0001011101111001","0001001010000100","1001001101101010","1001100110000001","1001101110110011","1001101100001000","1001011000001101","0001011011001100",
"0001110011111110","0001111011101001","0001111001000000","0001100101010101","1001100111110011","1010000001011000","1010000111111100","1010000101100110",
"1001110010011010","0001110100100011","0010001110000101","0010010100110110","0010010010111111","0010000000011001","1010000010101001","1010011011111111",
"1010100100000100","1010100011000111","1010010001100011","0010010101110000","0010110010100001","0011000000001010","0011000101111010","0011001001001011",
"0011001001001011","0011000101111010","0011000000001010","0010110010100001","0010010101110000","1010010001100011","1010100011000111","1010100100000100",
"1010011011111111","1010000010101001","0010000000011001","0010010010111111","0010010100110110","0010001110000101","0001110100100011","1001110010011010",
"1010000101100110","1010000111111100","1010000001011000","1001100111110011","0001100101010101","0001111001000000","0001111011101001","0001110011111110",
"0001011011001100","1001011000001101","1001101100001000","1001101110110011","1001100110000001","1001001101101010","0001001010000100","0001011101111001",
"0001100000001000","0001010110101110","0000111110000110","1000111010000000","1001001101010010","1001001111000001","1001000101011001","1000101011110000",
"0000100111011100","0000111001110001","0000111010100110","0000110001110111","0000010110100001","1000010010011100","1000100011101000","1000100011100101",
"1000011001010101","1000000111101010","0000000110000001","0000001100001101","0000001011100010","0000000111000011","0000000010000000","1000000001011101",
"1000000010101100","1000000010010010","1000000001001110","1000000000010010","0000000000001011","0000000000001110","0000000000001000","0000000000000100"
);
-----------------------------------------------FIR COEFFICIENT-----------------------------------------------
begin
	
	shift_reg_signal(0) 	<= D_IN;
		
	D_FF_GEN:
	for i in 0 to  taps-2 generate
		begin
			D_FF: RisingEdge_Register_SyncReset 
			generic map (input_width => 16)
			port map(
						Q	 	=> shift_reg_signal(i+1),    
						Clk 		=> Clk,  
						sync_reset	=> sync_reset,  
						D		=> shift_reg_signal(i)
				);		
			mult_reg_signal(i) 	<= shift_reg_signal(i) * coefficient_FIR(i);
			add_reg_signal(i+1) 	<= add_reg_signal(i) + mult_reg_signal(i);
		end generate D_FF_GEN;
		
	D_OUT <= add_reg_signal(taps-1);
	
end Filter_Behavioral;

-------------------------------------------------------------------------------------------------------------
library IEEE;
	USE IEEE.Std_logic_1164.all;
	USE IEEE.numeric_std.all;

entity RisingEdge_Register_SyncReset is 
   generic(
		input_width	: positive := 16;
		output_width	: positive := 16
	  );
   port(
      		Q 		: out   signed(input_width-1 downto 0);
		D 		: in 	signed(output_width-1 downto 0);   
      		Clk 		: in 	std_logic;  
		sync_reset	: in 	std_logic   
   );
end RisingEdge_Register_SyncReset;

architecture Behavioral of RisingEdge_Register_SyncReset is  
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
