library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity decoder2x4 is 
    port (
        i_in: in std_logic_vector(1 downto 0);
        o_out0: out std_logic;
        o_out1: out std_logic;
        o_out2: out std_logic;
        o_out3: out std_logic
    );
end decoder2x4;


architecture rtl of decoder2x4 is
begin
    o_out0 <= not i_in(1) and not i_in(0);
    o_out1 <= not i_in(1) and i_in(0);
    o_out2 <= i_in(1) and not i_in(0);
    o_out3 <= i_in(1) and i_in(0);
end rtl ; -- rtl