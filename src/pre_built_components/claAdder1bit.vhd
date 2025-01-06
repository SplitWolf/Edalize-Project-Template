library ieee;
use ieee.std_logic_1164.all;

entity claAdder1bit is
    port(
        i_a, i_b: in std_logic;
        i_cin : in std_logic;
        o_sum: out std_logic;
        o_prop: out std_logic;
        o_gen : out std_logic
    );
end claAdder1bit;


architecture rtl of claAdder1bit is

    signal int_sum, int_carry: std_logic;

    signal intAxorB: std_logic;

begin
    intAxorB <= i_a xor i_b;
    o_prop <= intAxorB;
    o_gen <= i_a and i_b;
    o_sum <= intAxorB xor i_cin;
end rtl ; -- rtl