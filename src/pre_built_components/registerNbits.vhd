library ieee;
use ieee.std_logic_1164.all;

entity registerNbits is
    generic(
        DataWidth: natural := 1
    );
    port (
        i_in: in std_logic_vector ((DataWidth-1) downto 0); 
        i_load: in std_logic;
        i_clk: in std_logic;
        i_cen: in std_logic;
        i_resetn: in std_logic;
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end registerNbits;


architecture rtl of registerNbits is
    component synth_enardFF is
        port (
            i_d : in std_logic;
            i_cen: in std_logic;
            i_clk   : in std_logic;
            i_resetn : in std_logic;
            o_q, o_qn: out std_logic
            );
    end component;
    signal int_cen: std_logic;
begin
int_cen <= i_cen and i_load;
gen_reg:
    for I in 0 to DataWidth-1 generate
        reg_bit: synth_enardFF port map
        (i_resetn => i_resetn, i_d => i_in(I), i_cen => int_cen,i_clk => i_clk, o_q => o_out(I), o_qn => open);
    end generate gen_reg;

end rtl;