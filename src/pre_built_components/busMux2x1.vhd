library ieee;
use ieee.std_logic_1164.all;

entity busMux2x1 is
    generic(
        DataWidth: integer := 1
    );
    port (
        i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
        i_sel: in std_logic;
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end busMux2x1;

architecture rtl of busMux2x1 is
begin
gen_out: for i in 0 to DataWidth-1 generate
    o_out(i) <= (i_in0(i) and not i_sel) or (i_in1(i) and i_sel);
end generate gen_out;
end rtl;