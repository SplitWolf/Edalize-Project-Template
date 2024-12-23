library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity decoder3x8 is 
    port (
        i_in: in std_logic_vector(2 downto 0);
        o_out0: out std_logic;
        o_out1: out std_logic;
        o_out2: out std_logic;
        o_out3: out std_logic;
        o_out4: out std_logic;
        o_out5: out std_logic;
        o_out6: out std_logic;
        o_out7: out std_logic
    );
end decoder3x8;


architecture rtl of decoder3x8 is
begin
    o_out0 <= not i_in(2) and not i_in(1) and not i_in(0);
    o_out1 <= not i_in(2) and not i_in(1) and i_in(0);
    o_out2 <= not i_in(2) and i_in(1) and not i_in(0);
    o_out3 <= not i_in(2) and i_in(1) and i_in(0);
    o_out4 <= i_in(2) and not i_in(1) and not i_in(0);
    o_out5 <= i_in(2) and not i_in(1) and i_in(0);
    o_out6 <= i_in(2) and i_in(1) and not i_in(0);
    o_out7 <= i_in(2) and i_in(1) and i_in(0);
end rtl ; -- rtl