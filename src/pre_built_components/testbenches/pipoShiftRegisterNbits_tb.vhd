library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity pipoShiftRegisterNbits_tb is
end pipoShiftRegisterNbits_tb;


architecture sim of pipoShiftRegisterNbits_tb is
    component pipoShiftRegisterNBits is
        generic(
            DataWidth: integer := 1
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
    signal sIn, shl, shr, clr, load, clock, sOut: std_logic;

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
    i_shiftLeft => shl,
    i_shiftRight => shr,
    i_clear => clr,
    i_load => load,
    i_clock => clock,
    o_serialOut => sOut,
    o_out => output
);

tb: process
begin
clr <= '1', '0' after period;
wait for period;
input <= "0101";
sIn <= '1';
shl <= '0';
shr <= '0';
load <= '1';
wait for period;
sIn <= '0';
shl <= '1';
shr <= '0';
load <= '0';
wait for period;
sIn <= '1';
shl <= '0';
shr <= '1';
load <= '0';
wait for period;

sim_end <= true;
report "Test: OK";
wait;
end process tb;

    
end sim ; -- sim