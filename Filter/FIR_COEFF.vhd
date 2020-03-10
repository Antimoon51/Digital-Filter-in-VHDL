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

package FIR_COEFF is
-- Deklaration des Koeffiziententypes
type coefficient_FIR_type is array(1 to 80) of real;
-- Filterkoeffzienten bzw. Impulsantwort
constant coeffcient_FIR: coefficient_FIR_type := (
		 -0.00000000e+00, -1.32737315e-05, -4.22900574e-05, -6.91403254e-05,
       -7.74430294e-05, -5.72726596e-05, -9.72429205e-06,  4.95700442e-05,
        8.85876261e-05,  5.91930304e-05, -1.00192461e-04, -4.59524946e-04,
       -1.08994539e-03, -2.05499788e-03, -3.40102702e-03, -5.14769146e-03,
       -7.27961472e-03, -9.74018132e-03, -1.24283699e-02, -1.51993019e-02,
       -1.78688885e-02, -2.02226052e-02, -2.20280407e-02, -2.30504937e-02,
       -2.30705595e-02, -2.19023906e-02, -1.94111663e-02, -1.55282722e-02,
       -1.02627932e-02, -3.70814863e-03,  3.95696369e-03,  1.24737218e-02,
        2.15143652e-02,  3.06988555e-02,  3.96159976e-02,  4.78476206e-02,
        5.49941323e-02,  6.06996116e-02,  6.46745980e-02,  6.67148819e-02,
        6.67148819e-02,  6.46745980e-02,  6.06996116e-02,  5.49941323e-02,
        4.78476206e-02,  3.96159976e-02,  3.06988555e-02,  2.15143652e-02,
        1.24737218e-02,  3.95696369e-03, -3.70814863e-03, -1.02627932e-02,
       -1.55282722e-02, -1.94111663e-02, -2.19023906e-02, -2.30705595e-02,
       -2.30504937e-02, -2.20280407e-02, -2.02226052e-02, -1.78688885e-02,
       -1.51993019e-02, -1.24283699e-02, -9.74018132e-03, -7.27961472e-03,
       -5.14769146e-03, -3.40102702e-03, -2.05499788e-03, -1.08994539e-03,
       -4.59524946e-04, -1.00192461e-04,  5.91930304e-05,  8.85876261e-05,
        4.95700442e-05, -9.72429205e-06, -5.72726596e-05, -7.74430294e-05,
       -6.91403254e-05, -4.22900574e-05, -1.32737315e-05, -0.00000000e+00
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
