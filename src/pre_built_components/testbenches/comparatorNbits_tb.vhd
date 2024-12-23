library ieee;
use ieee.std_logic_1164.all;
-- use ieee.NUMERIC_STD.all;

library basic_rtl;
use basic_rtl.all;

entity comparatorNbits_tb is
end comparatorNbits_tb;

architecture sim of comparatorNbits_tb is

    component comparatorNbits is
        generic (
            DataWidth: natural := 4
        );
        port (
            i_a: in std_logic_vector(DataWidth-1 to 0);
            i_b: in std_logic_vector(DataWidth-1 to 0);
            o_gt: out std_logic;
            o_lt: out std_logic
        );
    end component;

    
    constant data_size: natural := 4;
    signal i_a, i_b: std_logic_vector(3 downto 0);
    signal greater, less, equal: std_logic;
    constant period: time := 50 ns; 

begin
equal <= greater nor less;
DUT: entity basic_rtl.comparatorNbits
        generic map (
            DataWidth => 4
        )
        port map (
            i_a => i_a,
            i_b => i_b,
            o_gt => greater,
            o_lt => less
        );

tb: process
begin
i_a <= "0000";
i_b <= "0000";
wait for period;
report "GT: " & std_logic'image(greater) & " LT: " & std_logic'image(less) & " EQ: " & std_logic'image(equal);

i_a <= "1000";
i_b <= "1000";
wait for period;
report "GT: " & std_logic'image(greater) & " LT: " & std_logic'image(less) & " EQ: " & std_logic'image(equal);

i_a <= "1000";
i_b <= "0100";
wait for period;
report "GT: " & std_logic'image(greater) & " LT: " & std_logic'image(less) & " EQ: " & std_logic'image(equal);

i_a <= "0001";
i_b <= "0000";
wait for period;
report "GT: " & std_logic'image(greater) & " LT: " & std_logic'image(less) & " EQ: " & std_logic'image(equal);

i_a <= "0000";
i_b <= "1000";
wait for period;
report "GT: " & std_logic'image(greater) & " LT: " & std_logic'image(less) & " EQ: " & std_logic'image(equal);

i_a <= "0000";
i_b <= "0001";
wait for period;
report "GT: " & std_logic'image(greater) & " LT: " & std_logic'image(less) & " EQ: " & std_logic'image(equal);


report "Test: OK";
wait;
end process tb;

end sim ; -- sim
