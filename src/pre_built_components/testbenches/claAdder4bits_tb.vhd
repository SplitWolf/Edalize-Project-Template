library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library basic_rtl;
 use basic_rtl.claAdder4bits;

entity claAdder4bits_tb is
end entity;

architecture sim of claAdder4bits_tb is
    signal in_a, in_b: std_logic_vector(3 downto 0);
    signal addnSub, prop_out, gen_out: std_logic;
    signal sum: std_logic_vector(3 downto 0);
    signal C,N,V,Z: std_logic;
begin
    DUT: entity basic_rtl.claAdder4bits 
    port map(
        i_a => in_a,
        i_b => in_b,
        i_addn_sub => addnSub,
        o_gp => prop_out,
        o_gg => gen_out,
        o_sum => sum,
        o_cout => C,
        o_negative => N,
        o_overflow => V,
        o_zero => Z
    );

    tb: process
    begin
        addnSub <= '1';
        in_a <= "0001";
        in_b <= "0010";
        wait for 20 ns;
        addnSub <= '0';
        in_a <= "0100";
        in_b <= "0010";
        wait for 20 ns;
        in_a <= "0001";
        in_b <= "0010";
        wait for 20 ns;
        addnSub <= '1';
        in_a <= "1000";
        in_b <= "0011";
        wait for 20 ns;
        addnSub <= '0';
        in_a <= "0100";
        in_b <= "0010";
        -- addnSub <= '1';
        wait for 20 ns;
        in_a <= "0010";
        in_b <= "1000";
        addnSub <= '1';
        wait for 20 ns;
        wait;
    end process;

end architecture;
