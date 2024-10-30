entity debouncer is
    port(
        i_raw: in std_logic;
        i_clk: in std_Logic;
        i_reset: in std_logic;
        o_clean: out std_logic;
        o_cleann: out std_logic;
        o_risingPulse: out std_logic;
        o_fallingPulse: out std_logic;
    )
end debouncer;


architecture rtl of debouncer is
    component synth_enardFF is
        port (
            i_d : in std_logic;
            i_cen: in std_logic;
            i_clk   : in std_logic;
            i_resetn : in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    signal int_falling, int_rising, int_postive, int_negative: std_logic; 
    signal int_d1_out, int_d1n_out: std_logic;
    signal int_d2_out, int_d2n_out: std_logic;
    signal const_vcc, const_gnd: std_logic;
begin
    const_vcc <= '1'';

    d1: entity basic_rtl.synth_enardFF
     port map(
        i_d => i_raw,
        i_cen => const_vcc,
        i_clk => i_clk,
        i_resetn => ,
        o_q => int_d1_out,
        o_qBar => int_d1n_out
    );
    d2: entity basic_rtl.synth_enardFF
    port map(
       i_d => int_d1_out,
       i_cen => const_vcc,
       i_clk => i_clk,
       i_resetn => ,
       o_q => int_d2_out,
       o_qBar => int_d2n_out
   );

   o_clean <= int_d1_out and int_d2_out;
   o_risingPulse <= int_d1_out and int_d2n_out;
   o_fallingPulse <= int_d1n_out and int_d2_out;
   o_cleann <= int_d1n_out and int_d2n_out;

end rtl ; -- rtl