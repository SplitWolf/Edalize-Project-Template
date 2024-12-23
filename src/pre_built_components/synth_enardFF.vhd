library ieee;
use ieee.std_logic_1164.all;

entity synth_enardFF is
    port (
        i_d : in std_logic;
        i_cen: in std_logic;
        i_clk   : in std_logic;
        i_resetn : in std_logic;
        o_q, o_qn: out std_logic
    );
end entity synth_enardFF;

architecture behav of synth_enardFF is
    signal int_q : std_logic;
begin

bit1: process (i_clk, i_resetn)
begin
    if i_resetn = '0' then
        int_q <= '0';
    elsif rising_edge(i_clk) then
            if(i_cen = '1') then
                int_q <= i_d after 2ns;
            end if;
    end if;
end process bit1;

o_q     <=  int_q;
o_qn  <=	not(int_q);

end architecture;