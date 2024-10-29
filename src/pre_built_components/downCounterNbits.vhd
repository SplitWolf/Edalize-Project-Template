-- library ieee;
-- use ieee.std_logic_1164.all;


-- library basic_rtl;
-- use basic_rtl.all;

-- entity downCounterNbits Is
--     generic (
--         DataWidth: integer := 3
--     );
--     port (
--         i_in: in std_logic_vector(DataWidth-1 downto 0);
--         i_load: in std_logic;
--         i_dec: in std_logic;
--         i_clk: in std_logic;
--         o_value: out std_logic_vector(DataWidth-1 downto 0);
--         o_zero: out std_logic
--     );
-- end downCounterNbits;

-- architecture rtl of downCounterNbits is
--     component synth_enardFF is
--         port (
--             i_d : in std_logic;
--             i_cen: in std_logic;
--             i_clk   : in std_logic;
--             i_resetn : in std_logic;
--             o_q, o_qBar: out std_logic
--         );
--     end component;
--     component busMux2x1 is
--         generic(
--             DataWidth: integer := 4
--         );
--         port (
--             i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
--             i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
--             i_sel: in std_logic;
--             o_out: out std_logic_vector ((DataWidth-1) downto 0)
--         );
--     end component;
--     signal int_y0t_in, int_y0d_in, int_y0_out, int_y0_mux_out: std_logic;
--     signal int_y1t_in, int_y1d_in, int_y1_out, int_y1_mux_out: std_logic;
--     signal int_count : std_logic_vector(DataWidth-1 downto 0);
--     signal int_t_in, int_d_to_t, int_d_in : std_logic_vector(DataWidth-1 downto 0);
--     signal int_load_count: std_logic;
-- begin
-- int_load_count <= i_load or i_dec;
-- o_zero <= int_y0_out nor int_y1_out;
-- int_t_in(0) <= '1';
-- gen_counter:
--     for I in 0 to DataWidth-1 generate
--         for X in 1 to I generate
--             int
--             int_t_in(I) <= int_count(X-1) and int_t_in(I);
--         end generate;


--         int_d_to_t(I) <= int_t_in(I) xor int_count(I);

--         count_mux: entity basic_rtl.busMux2x1 port map (
--             i_in0(0) => i_in(I),
--             i_in1(0) => int_d_to_t(I),
--             i_sel => i_dec,
--             o_out(0) => int_d_in(I) 
--         );

--         count_ff: entity basic_rtl.synth_enardFF
--         port map (
--             i_d => int_d_in(I),
--             i_cen => int_load_count,
--             i_clk => i_clk,
--             i_resetn => '1',
--             o_q => int_count(I),
--             o_qBar => open
--         );

--     end generate gen_counter;
    
--     o_value <= int_count;


-- end rtl ; -- rtl