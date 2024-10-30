-- library ieee;
-- use ieee.std_logic_1164.all;

-- library basic_rtl;
-- use basic_rtl.all;


-- entity claAdderNbits is
--     generic (
--         DataWidth: integer := 1
--     );
--     port(
--         i_a, i_b: in std_logic_vector(DataWidth-1 downto 0);
--         i_addBarSub : in std_logic;
--         o_sum: out std_logic_vector(DataWidth-1 downto 0);
--         o_cout : out std_logic;
--         o_overflow: out std_logic;
--         o_zero: out std_logic
--     );
-- end claAdderNbits;


-- architecture rtl of claAdderNbits is

--     signal int_carry: std_logic_vector(DataWidth downto 0);
--     signal int_sum: std_logic_vector(DataWidth-1 downto 0);
--     signal int_b: std_logic_vector(DataWidth-1 downto 0);
    
--     component fullAdder is
--         port(
--             i_a, i_b: in std_logic;
--             i_cin : in std_logic;
--             o_sum: out std_logic;
--             o_cout : out std_logic
--         );
--     end component; 

--     signal int_generate: std_logic_vector(DataWidth-1 downto 0);
--     signal int_propagate: std_logic_vector(DataWidth-1 downto 0);

-- begin

-- gen_b_invert: for i in 0 to DataWidth-1 generate
--         int_b(i) <= i_b(i) xor i_addBarSub;
--     end generate gen_b_invert;

    
--     int_carry(0) <= i_addBarSub;
-- gen_add:
--     for i in 0 to DataWidth-1 generate
--         int_generate(I) <= in_a(I) and in_b(I);
--         int_propagate(I) <= in_a(I) xor in_b(I);
-- -- TODO: FINISH
--         for x in I downto 0 generate
--             int_carry(I) <= int_generate(I) or (int_propagate(I) and int_generate(I-1))
--         end generate;

--         fullAdder_inst: entity basic_rtl.fullAdder
--          port map(
--             i_a => i_a(i),
--             i_b => int_b(i),
--             i_cin => int_carry(i),
--             o_sum => int_sum(i),
--             o_cout => int_carry(i+1)
--         );
--     end generate gen_add;
    

--     -- Ouput Drivers
--     o_sum <= int_sum;
--     o_cout <= int_carry(DataWidth);
--     o_overflow <= int_carry(DataWidth) xor int_carry(DataWidth-1);

    
-- end rtl ; -- rtl