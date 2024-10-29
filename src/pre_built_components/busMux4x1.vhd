library ieee;
use ieee.std_logic_1164.all;

entity busMux4x1 is
    generic(
        DataWidth: integer := 1
    );
    port (
        i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in2: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in3: in std_logic_vector ((DataWidth-1) downto 0); 
        i_sel: in std_logic_vector (1 downto 0);
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end busMux4x1;

architecture rtl of busMux4x1 is
signal int_sel0, int_sel1, int_sel2, int_sel3  : std_logic;
begin
int_sel0 <= not i_sel(0) and not i_sel(1);
int_sel1 <= i_sel(0) and not i_sel(1);
int_sel2 <= not i_sel(0) and i_sel(1);
int_sel3 <= i_sel(0) and i_sel(1);

gen_out: for i in 0 to DataWidth-1 generate
    o_out(i) <= (i_in0(i) and int_sel0) or (i_in1(i) and int_sel1) or (i_in2(i) and int_sel2) or (i_in3(i) and int_sel3);
end generate gen_out;
end rtl;