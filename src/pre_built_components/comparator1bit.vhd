library ieee;
use ieee.std_logic_1164.all;

entity comparator1bit is
    port (
        i_a: in std_logic;
        i_b: in std_logic;
        i_gt: in std_logic;
        i_lt: in std_logic;
        o_gt: out std_logic;
        o_lt: out std_logic
    );
end comparator1bit;


architecture rtl of comparator1bit is

begin
    o_gt <= (i_gt or ((i_a and not i_b) and not i_lt))  and (i_gt nand i_lt);
    o_lt <= (i_lt or ((not i_a and i_b) and not i_gt)) and (i_gt nand i_lt);
end rtl ; -- rtl