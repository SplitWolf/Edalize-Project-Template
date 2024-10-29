library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
    port(
        i_a, i_b: in std_logic;
        i_cin : in std_logic;
        o_sum: out std_logic;
        o_cout : out std_logic
    );
end fullAdder;


architecture rtl of fullAdder is

    signal int_sum, int_carry: std_logic;

    signal intAxorB: std_logic;

begin
    intAxorB <= i_a xor i_b;
    o_cout <= (intAxorB and i_cin) or (i_a and i_b);
    o_sum <= intAxorB xor i_cin;
end rtl ; -- rtl