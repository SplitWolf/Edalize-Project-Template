library ieee;
use ieee.std_logic_1164.all;

entity gate_dFF is
    port(
        i_resetn: in std_logic;
        i_setn: in std_logic;
        i_d: in std_logic;
        i_cen: in std_logic;
        i_clk: in std_logic;
        o_q, o_qBar: out std_logic);
end gate_dFF;

architecture rtl of gate_dFF is
    signal int_q, int_qBar,  int_s1Bar, int_r1Bar: std_logic;
    signal int_q2, int_q2Bar, int_s2Bar, int_r2Bar : std_logic;
begin
    int_s2Bar <= not ( i_d and not i_clk) and i_setn;
    int_r2Bar <= not ( not i_d and not i_clk) and i_resetn;
    
    
    int_q2 <= int_s2Bar nand int_q2Bar; 
    int_q2Bar <= int_r2Bar nand int_q2;
    
    int_s1Bar <= not (int_q2 and i_clk and i_cen) and i_setn;
    int_r1Bar <= not (int_q2Bar and i_clk and i_cen) and i_resetn;
    
    int_q <= (int_s1Bar nand int_qBar);
    int_qBar <= (int_r1Bar nand int_q);
    
    o_q <= int_q;
    o_qBar <= int_qBar;
 
end rtl;