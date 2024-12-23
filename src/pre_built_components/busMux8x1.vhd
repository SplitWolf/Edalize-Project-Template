library ieee;
use ieee.std_logic_1164.all;



entity busMux8x1 is
    generic(
        DataWidth: integer := 2
    );
    -- type data_bus_array is array(7 downto 0) of std_logic_vector (DataWidth-1 downto 0);
    port (
        i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in2: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in3: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in4: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in5: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in6: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in7: in std_logic_vector ((DataWidth-1) downto 0); 
        i_sel: in std_logic_vector (2 downto 0);
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end busMux8x1;

architecture rtl of busMux8x1 is
signal int_sel0, int_sel1, int_sel2, int_sel3, int_sel4, int_sel5, int_sel6, int_sel7  : std_logic;
begin
int_sel0 <= not i_sel(2) and not i_sel(0) and not i_sel(1);
int_sel1 <= not i_sel(2) and i_sel(0) and not i_sel(1);
int_sel2 <= not i_sel(2) and not i_sel(0) and i_sel(1);
int_sel3 <= not i_sel(2) and i_sel(0) and i_sel(1);
int_sel4 <= i_sel(2) and not i_sel(0) and not i_sel(1);
int_sel5 <= i_sel(2) and i_sel(0) and not i_sel(1);
int_sel6 <= i_sel(2) and not i_sel(0) and i_sel(1);
int_sel7 <= i_sel(2) and i_sel(0) and i_sel(1);

--process(i_sel, i_in0, i_in1, i_in2, i_in3, i_in4, i_in5, i_in6, i_in7)
--begin
--case i_sel is
--    when "000" => o_out <= i_in0;
--    when "001" => o_out <= i_in1;
--    when "010" => o_out <= i_in2;
--    when "011" => o_out <= i_in3;
--    when "100" => o_out <= i_in4;
--    when "101" => o_out <= i_in5;
--    when "110" => o_out <= i_in6;
--    when "111" => o_out <= i_in7;
--    when others => o_out <= (others => 'X');
--end case;
--end process;

 gen_out: for i in 0 to DataWidth-1 generate
     o_out(i) <= (i_in0(i) and int_sel0) or (i_in1(i) and int_sel1) or (i_in2(i) and int_sel2) or (i_in3(i) and int_sel3)
                 or (i_in4(i) and int_sel4) or (i_in5(i) and int_sel5) or (i_in6(i) and int_sel6) or (i_in7(i) and int_sel7);
 end generate gen_out;
end rtl;