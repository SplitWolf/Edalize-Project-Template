library ieee;
use ieee.std_logic_1164.all;


library basic_rtl;
use basic_rtl.all;

entity downCounter2bits is
    port (
        i_in: in std_logic_vector(1 downto 0);
        i_load: in std_logic;
        i_dec: in std_logic;
        i_clk: in std_logic;
        o_value: out std_logic_vector(1 downto 0);
        o_zero: out std_logic
    );
end downCounter2bits;

architecture rtl of downCounter2bits is
    component synth_enardFF is
        port (
            i_d : in std_logic;
            i_cen: in std_logic;
            i_clk   : in std_logic;
            i_resetn : in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    component busMux2x1 is
        generic(
            DataWidth: integer := 4
        );
        port (
            i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
            i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
            i_sel: in std_logic;
            o_out: out std_logic_vector ((DataWidth-1) downto 0)
        );
    end component;
    signal int_y0t_in, int_y0d_in, int_y0_out, int_y0_mux_out: std_logic;
    signal int_y1t_in, int_y1d_in, int_y1_out, int_y1_mux_out: std_logic;
    signal int_count : std_logic_vector(1 downto 0);
    signal int_load_count: std_logic;
begin
int_load_count <= i_load or i_dec;
o_zero <= int_y0_out nor int_y1_out;
-- int_load_count <= nor int_count;

int_y0t_in <= '1' xor int_y0_out;

y0_mux: entity basic_rtl.busMux2x1 port map (
    i_in0(0) => i_in(0),
    i_in1(0) => int_y0t_in,
    i_sel => i_dec,
    o_out(0) => int_y0d_in 
);


int_y1t_in <= not int_y0_out xor int_y1_out;

y1_mux: entity basic_rtl.busMux2x1 port map (
    i_in0(0) => i_in(0),
    i_in1(0) => int_y1t_in,
    i_sel => i_dec,
    o_out(0) => int_y1d_in 
);


y0: entity basic_rtl.synth_enardFF
    port map (
        i_d => int_y0d_in,
        i_cen => int_load_count,    
        i_clk => i_clk,
        i_resetn => '1',
        o_q => int_y0_out,
        o_qBar => open
    );
y1: entity basic_rtl.synth_enardFF
    port map (
        i_d => int_y1d_in,
        i_cen => int_load_count,    
        i_clk => i_clk,
        i_resetn => '1',
        o_q => int_y1_out,
        o_qBar => open
    );

o_value <= int_y1_out & int_y1_out;


end rtl ; -- rtl