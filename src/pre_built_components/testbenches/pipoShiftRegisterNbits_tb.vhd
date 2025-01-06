library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity pipoShiftRegisterNbits_tb is
end pipoShiftRegisterNbits_tb;


architecture sim of pipoShiftRegisterNbits_tb is
    component pipoShiftRegisterNBits is
        generic(
            DataWidth: natural := 1
        );
        port (
            i_in: in std_logic_vector ((DataWidth-1) downto 0); 
            i_serialIn: in std_logic;
            i_shiftLeft: in std_logic; 
            i_shiftRight: in std_logic; 
            i_clear: in std_logic;
            i_load: in std_logic;
            i_clock: in std_logic;
            o_serialOut: std_logic;
            o_out: out std_logic_vector ((DataWidth-1) downto 0)
        );
    end component;

    signal input, output: std_logic_vector(3 downto 0);
    signal sIn, shlr, reset, load, clock,cen, sOut: std_logic;

    signal case_int: natural := 0;
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

DUT: entity basic_rtl.pipoShiftRegisterNBits
 generic map(
    DataWidth => 4
)
 port map(
    i_in => input,
    i_serialIn => sIn,
    i_shitleftn_shiftright => shlr,
    i_resetn => reset,
    i_load => load,
    i_clk => clock,
    i_cen => cen,
    o_serialOut => sOut,
    o_out => output
);

tb: process
begin
reset <= '0', '1' after period;
cen <= '0';
wait for period - 2ns;
-- Load 0101
input <= "0101";
sIn <= '1';
shlr <= '0';
load <= '1';
cen <= '1', '0' after period;
wait for period;
case_int <= case_int + 1;
report "Case: " & integer'image(case_int) & " Ouput: " & to_string(output);
assert output = "0101"
    report "ouput not expected"
    severity error;
-- Shift Left, cen = 0. Do nothing
sIn <= '0';
shlr <= '0';
load <= '0';
wait for period;
case_int <= case_int + 1;
report "Case: " & integer'image(case_int) & " Ouput: " & to_string(output);
assert output = "0101"
    report "ouput not expected"
    severity error;
-- Shift Left, cen = 1. Shfit 0101 left 1, Sin=0, Expected: 1010
cen <= '1';
wait for period;
case_int <= case_int + 1;
report "Case: " & integer'image(case_int) & " Ouput: " & to_string(output);
assert output = "1010"
    report "ouput not expected"
    severity error;
-- Shift Left, cen = 1. Shfit 1010 left 1, Sin=1, Expected: 0101
sIn <= '1';
shlr <= '0';
load <= '0';
wait for period;
case_int <= case_int + 1;
report "Case: " & integer'image(case_int) & " Ouput: " & to_string(output);
assert output = "0101"
    report "ouput not expected"
    severity error;


sim_end <= true;
report "Test: OK";
wait;
end process tb;

    
end sim ; -- sim