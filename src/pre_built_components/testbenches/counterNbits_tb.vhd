library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;
use ieee.NUMERIC_STD.all;

library basic_rtl;
use basic_rtl.all;

entity counterNbits_tb is
end counterNbits_tb;

architecture sim of counterNbits_tb is

    component counterNbits Is
    generic (
        DataWidth: natural := 1;
        InvertCountDirecton: boolean := false
    );
    port (
        i_in: in std_logic_vector(DataWidth-1 downto 0);
        i_load: in std_logic;
        i_count: in std_logic;
        i_clk: in std_logic;
        i_cen: in std_logic;
        i_resetn: in std_logic;
        o_value: out std_logic_vector(DataWidth-1 downto 0);
        o_zero: out std_logic
    );
    end component;

    
    constant data_size: natural := 4;
    signal input: std_logic_vector(3 downto 0);
    signal output: std_logic_vector(3 downto 0);
    signal load, count, clock, zero, resetn: std_logic;
    signal sim_end : boolean := false;
    constant period: time := 50 ns; 

begin
clk: process
begin
    while (not sim_end) loop
    clock <= '1';
    wait for period/2;
    clock <= '0';
    wait for period/2;
    end loop;
    wait;
end process clk;

DUT: entity basic_rtl.counterNbits
 generic map(
    DataWidth => data_size,
    InvertCountDirecton => false
)
 port map(
    i_in => input,
    i_load => load,
    i_clk => clock,
    i_cen => count,
    i_resetn => resetn,
    o_value => output,
    o_zero => zero
);

tb: process
begin
resetn <= '0', '1' after period;
wait for period;
input <= "0000";
load <= '1', '0' after period+2 ns;
count <= '0';
wait for period;
count <= '1';
wait for period;
-- Test for counting up from zero in sequential order
for i in 0 to 2**data_size-1 loop
    report "Current Num:" & integer'image(i) & LF & HT & "Count Value:" & integer'image(to_integer(unsigned(output)));
    assert (i = to_integer(unsigned(output))) report "Incorrect count value" severity failure;
    wait for period;
end loop;
sim_end <= true;
report "Test: OK";
wait;
end process tb;

end sim ; -- sim
