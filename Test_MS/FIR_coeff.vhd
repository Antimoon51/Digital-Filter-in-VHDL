--
--	Package für die Übersichttlichkeit im Code
-- Hier wurde der Typ für die Koeffzienten deklariert sowie die Filter in eine Konstante eingespeichert
-- Der Bandpass wurde für zwischen 10Hz und 40Hz berechnet
-- mit einer Abtastfrequenz von 500Hz
--
-- fu = 10  Hz
-- fo = 40  Hz
-- fs = 1000 Hz


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_signed.all;

package FIR_COEFF is
-- Deklaration des Koeffiziententypes
type coefficient_FIR_type is array(1 to 80) of signed(std_logic_vector(16-1 downto 0));
-- Filterkoeffzienten bzw. Impulsantwort
constant coeffcient_FIR: coefficient_FIR_type := (X"0",
X"0",
X"0",
X"-1",
X"-1",
X"0",
X"0",
X"0",
X"1",
X"0",
X"-1",
X"-6",
X"-10",
X"-1e",
X"-33",
X"-4d",
X"-6d",
X"-92",
X"-ba",
X"-e3",
X"-10c",
X"-12f",
X"-14a",
X"-159",
X"-15a",
X"-148",
X"-123",
X"-e8",
X"-99",
X"-37",
X"3b",
X"bb",
X"142",
X"1cc",
X"252",
X"2cd",
X"338",
X"38e",
X"3ca",
X"3e8",
X"3e8",
X"3ca",
X"38e",
X"338",
X"2cd",
X"252",
X"1cc",
X"142",
X"bb",
X"3b",
X"-37",
X"-99",
X"-e8",
X"-123",
X"-148",
X"-15a",
X"-159",
X"-14a",
X"-12f",
X"-10c",
X"-e3",
X"-ba",
X"-92",
X"-6d",
X"-4d",
X"-33",
X"-1e",
X"-10",
X"-6",
X"-1",
X"0",
X"1",
X"0",
X"0",
X"0",
X"-1",
X"-1",
X"0",
X"0",
X"0" 
		 );

end FIR_COEFF;

package body FIR_COEFF is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end FIR_COEFF;
