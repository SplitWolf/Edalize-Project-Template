library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;

entity pulse_synchronizer is
    port(
        i_raw: in std_logic;
        i_clkIn: in std_Logic;
        i_clkOut: in std_logic;
        i_resetn: in std_logic;
        o_risingPulse: out std_logic;
        o_fallingPulse: out std_logic
    );
end pulse_synchronizer;


architecture rtl of pulse_synchronizer is
    component synth_enardFF is
        port (
            i_d : in std_logic;
            i_cen: in std_logic;
            i_clk   : in std_logic;
            i_resetn : in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    signal int_falling, int_rising: std_logic; 
    signal int_d0_out, int_d0n_out: std_logic;
    signal int_d1_out, int_d1n_out: std_logic;
    signal int_d2_out, int_d2n_out: std_logic;
    signal int_d3_out, int_d3n_out: std_logic;
    signal int_d0_mux_out: std_logic;
    signal const_vcc, const_gnd: std_logic;
begin
    const_vcc <= '1';
    const_gnd <= '0';

    inputMux: entity basic_rtl.busMux2x1
     generic map(
        DataWidth => 1
    )
     port map(
        i_in0(0) => int_d0_out,
        i_in1(0) => int_d0n_out,
        i_sel => i_raw,
        o_out(0) => int_d0_mux_out
    );

    d0:  entity basic_rtl.synth_enardFF
    port map(
       i_d => int_d0_mux_out,
       i_cen => const_vcc,
       i_clk => i_clkIn,
       i_resetn => i_resetn,
       o_q => int_d0_out,
       o_qn => int_d0n_out
    );
    d1: entity basic_rtl.synth_enardFF
     port map(
        i_d => int_d0_out,
        i_cen => const_vcc,
        i_clk => i_clkOut,
        i_resetn => i_resetn,
        o_q => int_d1_out,
        o_qn => int_d1n_out
    );
    d2: entity basic_rtl.synth_enardFF
    port map(
       i_d => int_d1_out,
       i_cen => const_vcc,
       i_clk => i_clkOut,
       i_resetn => i_resetn,
       o_q => int_d2_out,
       o_qn => int_d2n_out
    );
    d3: entity basic_rtl.synth_enardFF
    port map(
       i_d => int_d2_out,
       i_cen => const_vcc,
       i_clk => i_clkOut,
       i_resetn => i_resetn,
       o_q => int_d3_out,
       o_qn => int_d3n_out
    );

   o_risingPulse <= int_d2_out and int_d3n_out;
   o_fallingPulse <=int_d2n_out and int_d3_out;

end rtl ; -- rtl