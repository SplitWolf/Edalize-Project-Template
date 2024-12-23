library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity adderNbits is
    generic (
        DataWidth: natural := 1
    );
    port(
        i_a, i_b: in std_logic_vector(DataWidth-1 downto 0);
        i_addn_sub : in std_logic;
        o_sum: out std_logic_vector(DataWidth-1 downto 0);
        o_cout : out std_logic;
        o_negative: out std_logic;
        o_overflow: out std_logic;
        o_zero: out std_logic
    );
end adderNbits;


architecture rtl of adderNbits is

    signal int_carry: std_logic_vector(DataWidth downto 0);
    signal int_sum: std_logic_vector(DataWidth-1 downto 0);
    signal int_b: std_logic_vector(DataWidth-1 downto 0);
    
    component fullAdder is
        port(
            i_a, i_b: in std_logic;
            i_cin : in std_logic;
            o_sum: out std_logic;
            o_cout : out std_logic
        );
    end component; 
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

begin

gen_b_invert: for i in 0 to DataWidth-1 generate
        int_b(i) <= i_b(i) xor i_addn_sub;
    end generate gen_b_invert;

    
    int_carry(0) <= i_addn_sub;
gen_add:
    for i in 0 to DataWidth-1 generate
        fullAdder_inst: entity basic_rtl.fullAdder
         port map(
            i_a => i_a(i),
            i_b => int_b(i),
            i_cin => int_carry(i),
            o_sum => int_sum(i),
            o_cout => int_carry(i+1)
        );
    end generate gen_add;
    

    -- Ouput Drivers
    o_sum <= int_sum;
    o_cout <= int_carry(DataWidth);
    o_negative <= int_sum(DataWidth-1);
    o_overflow <= int_carry(DataWidth) xor int_carry(DataWidth-1);
    o_zero <= vector_zero(DataWidth, int_sum);

    
end rtl ; -- rtl