library ieee;
use ieee.std_logic_1164.all;

entity registerNbits is
    generic(
        DataWidth: integer := 1
    );
    port (
        i_in: in std_logic_vector ((DataWidth-1) downto 0); 
        i_clear: in std_logic;
        i_load: in std_logic;
        i_clock: in std_logic;
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end registerNbits;


architecture rtl of registerNbits is
signal int_notClear: std_logic;
component gate_dFF is
port(
    i_resetn: in std_logic;
    i_setn: in std_logic;
    i_d: in std_logic;
    i_cen: in std_logic;
    i_clk: in std_logic;
    o_q, o_qBar: out std_logic);
end component;
begin
int_notClear <= not i_clear;
gen_reg:
    for I in 0 to DataWidth-1 generate
        reg_bit: gate_dFF port map
        (i_resetn => int_notClear, i_setn => '1', i_d => i_in(I), i_cen => i_load,i_clk => i_clock, o_q => o_out(I), o_qBar => open);
    end generate gen_reg;

end rtl;