-------------------------------------------------------------------------------------------------------------
-- Company: 			HTWK Leipzig
-- Engineer: 			Trung Hoang Nguyen
-- 
-- Create Date:    	16:33 04/05/2020 german
-- Module Name:    	Schaltkreisentwurf SKE 
-- Project Name: 		FIR_Filter	
-- Target Devices: 	Kintex-7 XC7K70T
-- Tool versions: 	Xilinx ISE 14.7
-- Description: 		FIR Filter for ECG-Signal
--
--
-------------------------------------------------------------------------------------------------------------
library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;	
	use WORK.FIR_Filter_2_package.ALL;

entity FIR_Filter_2 is

	port(
		input_port		: in 	signed(input_width-1 downto 0);
		output_port		: out 	signed(output_width-1 downto 0);
		clk 			: in 	std_logic;
		sync_reset 		: in 	std_logic
	);
end FIR_Filter_2;

architecture sequential_behavior of FIR_Filter_2 is

type shift_array is array(0 to taps-1) of signed(input_width-1 downto 0);
type multi_array is array(0 to taps-1) of signed(input_width+coefficient_width-1 downto 0);

signal shift_inputvalues : shift_array;

begin

	process(clk,sync_reset)
	variable add : signed(input_width+coefficient_width-1 downto 0);
	variable products : multi_array;
	
	begin
	if sync_reset = '0' then
		add := (others => '0');
		products := (others => (others => '0'));
		shift_inputvalues <= (others => (others => '0'));
	elsif rising_edge(clk) then
		add := (others => '0');
		shift_inputvalues(0) <= input_port;
		MULT: for i in 0 to taps-1 loop
					if i < taps/2 then
						products(i) := shift_inputvalues(i) * coefficient(i);
					else
						products(i) := shift_inputvalues(i) * coefficient(taps-i-1);
					end if;
				end loop;
				add := products(0);
		ADDA: for i in 1 to taps-1 loop
					add := add + products(i);
				end loop;
		output_port <= add(input_width+coefficient_width-1 downto coefficient_width);
		SHIFT:for i in 1 to taps-1 loop
					shift_inputvalues(taps-i) <= shift_inputvalues(taps-i-1);
				end loop;
	end if;
	end process;

end sequential_behavior;

