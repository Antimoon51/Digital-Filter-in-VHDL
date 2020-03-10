----------------------------------------------------------------------------------
-- Company: HTWK
-- Engineer: Trung Hoang Nguyen
-- 
-- Create Date:    16:35:44 03/04/2020 
-- Design Name: 
-- Module Name:    FIR_Filter - Behavioral 
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
library IEEE;
	USE IEEE.Std_logic_1164.all;   
	--USE IEEE.Std_logic_unsigned.all;
	USE IEEE.numeric_std.all;
	USE IEEE.math_real.all; 
library work;
	use work.FIR_COEFF.all;
	use work.RisingEdge_DFlipFlop_SyncReset.all;

entity FIR_Filter is

	generic(
		input_width		: integer	:= 16;
		output_width	: integer	:= 16;
		taps				: integer	:= 80;
		coefficient_width : real 
	);
	port(
		D_IN				: in 	std_logic_vector(input_width-1 downto 0);
		D_OUT				: out std_logic_vector(output_width-1 downto 0);
		Clk				: in 	std_logic;
		sync_reset		: in 	std_logic	
	);
	
end FIR_Filter;


architecture Filter_verhalten of FIR_Filter is
--DD FlipFlop als Komponenten benutzen für das Schieberegister	
component RisingEdge_DFlipFlop_SyncReset is	
									
	generic(  
		input_width		: integer	:= 16  
   ); 
   port(  
    Q 					: out std_logic_vector(input_width-1 downto 0);
	 D 					: in 	std_logic_vector(output_width-1 downto 0);
    Clk 					: in 	std_logic;    
    sync_reset			: in 	std_logic
   );  
 end component RisingEdge_DFlipFlop_SyncReset;

-- Typendefinitionen bzw. eigene Datentypen von std_logic_vector erstellen für Schieberregister, Multiplizieren, Addieren
type shift_reg_type is array(0 to taps-1) of std_logic_vector(input_width-1 downto 0);
type mult_reg_type is array(0 to taps-1) of std_logic_vector(input_width-1 downto 0);
type add_reg_type is array(0 to taps-1) of std_logic_vector(input_width-1 downto 0);

type coefficient_vector_type is array(1 to taps) of std_logic_vector(input_width-1 downto 0);

-- Signaldeklaration
signal shift_reg_signal : shift_reg_type	:= (others => (others => '0'));
signal mult_reg_signal 	: mult_reg_type	:= (others => (others => '0'));
signal add_reg_signal 	: add_reg_type		:= (others => (others => '0'));

signal coefficient_vector : coefficient_vector_type := (others => (others => '0'));

begin
	
	coefficient_vector(1) <= std_logic_vector(to_unsigned(integer(coeffcient_FIR(1) * 512.0, taps)));
	
	shift_reg_signal(0) 	<= D_IN;
	mult_reg_signal(0) 	<= D_IN * coefficient_vector(1);
	add_reg_signal(0) 	<= D_IN * coefficient_vector(1);
		
	D_FF_GEN:
	for i in 0 to  taps-2 generate
		begin
			D_FF: RisingEdge_DFlipFlop_SyncReset generic map (input_width => 8)
			port map(
						Q	 			=> shift_reg_signal(i+1),    
						Clk 			=> Clk,  
						sync_reset	=> sync_reset,  
						D				=> shift_reg_signal(i)
						);
			coefficient_vector(i+2) <= std_logic_vector(to_unsigned(integer(coeffcient_FIR(i+2) * 512.0, taps)));			
			mult_reg_signal(i+1) <= shift_reg_signal(i+1) * coefficient_vector(i+2);
			add_reg_signal(i+1) <= add_reg_signal(i) + mult_reg_signal(i+1);
		end generate D_FF_GEN;
		
	D_OUT <= add_reg_signal(taps-1);
	
end Filter_verhalten;
