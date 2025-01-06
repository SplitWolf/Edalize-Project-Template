library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity claAdder4bits is
    port(
        i_a, i_b: in std_logic_vector(3 downto 0);
        i_addn_sub : in std_logic;
        o_gp: out std_logic;
        o_gg: out std_logic;
        o_sum: out std_logic_vector(3 downto 0);
        o_cout : out std_logic;
        o_negative: out std_logic;
        o_overflow: out std_logic;
        o_zero: out std_logic
    );
end claAdder4bits;


architecture rtl of claAdder4bits is
    component claAdder1bit is
        port(
            i_a, i_b: in std_logic;
            i_cin : in std_logic;
            o_sum: out std_logic;
            o_prop: out std_logic;
            o_gen : out std_logic
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

    signal int_carry: std_logic_vector(4 downto 0);
    signal int_prop: std_logic_vector(3 downto 0);
    signal int_gen: std_logic_vector(3 downto 0);
    signal int_sum: std_logic_vector(3 downto 0);
    signal int_b: std_logic_vector(3 downto 0);
        
begin

int_carry(0) <= i_addn_sub;
int_carry(1) <= int_gen(0) or (int_prop(0) and int_carry(0));
int_carry(2) <= int_gen(1) or (int_gen(0) and int_prop(1)) 
            or (int_carry(0) and int_prop(1) and int_prop(0));
int_carry(3) <= int_gen(2) or (int_gen(1) and int_prop(2)) 
            or (int_gen(0) and int_prop(2) and int_prop(1)) or (int_carry(0) and int_prop(2) and int_prop(1) and int_prop(0));
int_carry(4) <= int_gen(3) or (int_gen(2) and int_prop(3)) or (int_gen(1) and int_prop(3) and int_prop(2)) 
            or (int_gen(0) and int_prop(3) and int_prop(2) and int_prop(1)) or (int_carry(0) and int_prop(3) and int_prop(2) and int_prop(1) and int_prop(0));

o_gg <= int_gen(3) or (int_gen(2) and int_prop(3)) or (int_gen(1) and int_prop(3) and int_prop(2)) 
        or (int_gen(0) and int_prop(3) and int_prop(2) and int_prop(1));
o_gp <= int_prop(3) and int_prop(2) and int_prop(1) and int_prop(0);

gen_b_invert: for i in 0 to 3 generate
        int_b(i) <= i_b(i) xor i_addn_sub;
    end generate gen_b_invert;
gen_add:
    for i in 0 to 3 generate
    claAdder1bit: entity basic_rtl.claAdder1bit
         port map(
            i_a => i_a(i),
            i_b => int_b(i),
            i_cin => int_carry(i),
            o_gen => int_gen(i),
            o_prop => int_prop(i),
            o_sum => int_sum(i)
        );
    end generate gen_add;
    

    -- Ouput Drivers
    o_sum <= int_sum;
    o_cout <= int_carry(4);
    o_negative <= int_sum(3);
    o_overflow <= int_carry(4) xor int_carry(3);
    o_zero <= vector_zero(4, int_sum);

    
end rtl ; -- rtl