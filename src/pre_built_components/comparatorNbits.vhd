library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;

entity comparatorNbits is
    generic (
        DataWidth: natural := 1
    );
    port (
        i_a: in std_logic_vector(DataWidth-1 downto 0);
        i_b: in std_logic_vector(DataWidth-1 downto 0);
        o_gt: out std_logic;
        o_eq: out std_logic;
        o_lt: out std_logic
    );
end comparatorNbits;


architecture rtl of comparatorNbits is
    component comparator1bit is
        port (
            i_a: in std_logic;
            i_b: in std_logic;
            i_gt: in std_logic;
            i_lt: in std_logic;
            o_gt: out std_logic;
            o_lt: out std_logic
        );
    end component comparator1bit;
    signal const_gnd: std_logic;
    signal int_lt_out, int_gt_out: std_logic_vector(DataWidth downto 0);
begin
    const_gnd <= '0';

    int_gt_out(DataWidth) <= const_gnd;
    int_lt_out(DataWidth) <= const_gnd;
    gen_comp: for I in DataWidth-1 downto 0 generate
        bit: entity basic_rtl.comparator1bit
            port map (
                i_a => i_a(I),
                i_b => i_b(I),
                i_gt => int_gt_out(I+1),
                i_lt => int_lt_out(I+1),
                o_gt => int_gt_out(I),
                o_lt => int_lt_out(I) 
            );
    end generate gen_comp;
    o_lt <= int_lt_out(0);
    o_gt <= int_gt_out(0);
    o_eq <= int_lt_out(0) nor int_gt_out(0);
end rtl ; -- rtl