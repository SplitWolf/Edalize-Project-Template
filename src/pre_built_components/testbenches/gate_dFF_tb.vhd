library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;

entity gate_dFF_tb is
end gate_dFF_tb;


architecture testbench of gate_dFF_tb is
signal d, enable, a_set, a_reset, clock, q, qBar: std_logic;
signal sim_end : boolean := false;
    component gate_dFF is
        port(
            i_resetn: in std_logic;
            i_setn: in std_logic;
            i_d: in std_logic;
            i_cen: in std_logic;
            i_clk: in std_logic;
            o_q, o_qBar: out std_logic);
    end component;
constant period: time := 50 ns; 

begin
DUT: entity basic_rtl.gate_dFF port map (i_resetn => a_reset, i_setn => a_set, i_d => d, i_cen => enable, i_clk => clock, o_q => q, o_qBar => qBar);
-- this is the clock process to simulate the clock. It will toggle
-- every half period
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

tb: process
begin
    wait for 10 ns;
    a_set <= '1';
    a_reset <= '0', '1' after (period - 2 ns); -- Active low asynchronous reset
    wait for period;
    assert (q = '0') report "Test for initial reset failed, output should be 0" severity failure;
    d <= '0'; -- Set d & enable to 0
    enable <= '0';
    wait for period;
    assert (q = '0') report "Test for enable 0, D 1 failed, output should be 0" severity failure;
    d <= '0';
    enable <= '1';
    wait for period;
    assert (q = '0') report "Test for enable 1, D 0 failed, output should be 0" severity failure;
    d <= '1';
    enable <= '0';
    wait for period;
    assert (q = '0') report "Test for enable 0, D 1 failed, output should be 0" severity failure;
    d <= '1';
    enable <= '1';
    wait for period;
    assert (q = '1') report "Test for enable 1, D 1 failed, output should be 1" severity failure;
    d <= '0';
    enable <= '0';
    wait for period;
    assert (q = '1') report "Test for enable 0, D 0 failed, output should be 1" severity failure;
    d <= '0';
    enable <= '1';
    wait for period - 1 ns;
    assert (q = '0') report "Test for enable 1, D 0 failed, output should be 0" severity failure;
    d <= '1';
    enable <= '1';
    wait for 1 ns;
    wait for period - 1 ns;
    assert (q = '1') report "Test for enable 1, D 1 transition failed, output should be 1" severity failure;
    d <= '0';
    enable <= '1';
    wait for 1 ns;
    wait for period;
    assert (q = '0') report "Test for enable 1, D 0 transition failed, output should be 0" severity failure;
    wait for period/4;
    a_set <= '0';
    wait for 5 ns;
   wait for period/2;
    assert (q = '1') report "Test async active low set failed, output should be 1" severity failure;
    a_set <= '1';
    d <= '0';
    wait for period;
    assert (q = '0') report "Test state responds to D 0 after async set, output should be 0" severity failure;
    sim_end <= true;
    report "Test: OK";
    wait;
end process tb;


end testbench;