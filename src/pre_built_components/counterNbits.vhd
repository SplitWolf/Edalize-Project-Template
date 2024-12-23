library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;

entity counterNbits Is
    generic (
        DataWidth: natural := 1;
        InvertCountDirecton: boolean := false
    );
    port (
        i_in: in std_logic_vector(DataWidth-1 downto 0);
        i_load: in std_logic;
        i_clk: in std_logic;
        i_cen: in std_logic;
        i_resetn: in std_logic;
        o_value: out std_logic_vector(DataWidth-1 downto 0);
        o_zero: out std_logic
    );
end counterNbits;

architecture rtl of counterNbits is
    function get_t_input (current_bit: in natural; int_out: in std_logic_vector; InvertCountDirecton: boolean) 
        return std_logic is
        begin
            if (current_bit = 0) then
                return '1';
            end if;
            if (InvertCountDirecton) then
                return not int_out(current_bit-1) and get_t_input(current_bit-1, int_out, InvertCountDirecton);
            else
                return int_out(current_bit-1) and get_t_input(current_bit-1, int_out, InvertCountDirecton);
            end if;
    end function;
    function or_vec(current_bit: in integer; vec: in std_logic_vector) return std_logic;

    function vector_zero(vec_size: in natural; vec: in std_logic_vector)
        return std_logic is
        begin
            return not or_vec(vec_size-1,vec);
        end function;
    function or_vec(current_bit: in integer; vec: in std_logic_vector)
        return std_logic is
        begin
            if(current_bit = -1) then
                return '0';
            end if;
            return vec(current_bit) or or_vec(current_bit-1, vec);
        end function;
    -- HDL, Up/Down
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
            DataWidth: integer := 1
        );
        port (
            i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
            i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
            i_sel: in std_logic;
            o_out: out std_logic_vector ((DataWidth-1) downto 0)
        );
    end component;
    signal int_count : std_logic_vector(DataWidth-1 downto 0);
    signal int_t_in, int_d_to_t, int_d_in : std_logic_vector(DataWidth-1 downto 0);
begin

gen_counter:
    for I in 0 to DataWidth-1 generate
        int_t_in(I) <= get_t_input(I,int_count, InvertCountDirecton);
        int_d_to_t(I) <= int_t_in(I) xor int_count(I);

        count_mux: entity basic_rtl.busMux2x1 port map (
            i_in0(0) => int_d_to_t(I),
            i_in1(0) => i_in(I),
            i_sel => i_load,
            o_out(0) => int_d_in(I) 
        );

        count_ff: entity basic_rtl.synth_enardFF
        port map (
            i_d => int_d_in(I),
            i_cen => i_cen,
            i_clk => i_clk,
            i_resetn => i_resetn,
            o_q => int_count(I),
            o_qn => open
        );

    end generate gen_counter;
    
    o_value <= int_count;
    o_zero <= vector_zero(DataWidth, int_count);

end rtl ; -- rtl

