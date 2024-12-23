library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity adderNbits_tb is
end adderNbits_tb;

architecture sim of adderNbits_tb is

    signal A, B: STD_LOGIC_VECTOR(3 downto 0);

    signal SUM : STD_LOGIC_VECTOR(3 downto 0);
    signal c_out, addSub : STD_LOGIC;

    component adderNbits is
        generic (
            DataWidth: natural := 4
        );
        port(
            i_a, i_b: in std_logic_vector(DataWidth-1 downto 0);
            i_addBarSub : in std_logic;
            o_sum: out std_logic_vector(DataWidth-1 downto 0);
            o_cout : out std_logic;
            o_overflow: out std_logic;
            o_zero: out std_logic
        );
    end component;
begin
DUT: entity basic_rtl.adderNbits
 generic map(
    DataWidth => 4
 )
 port map(
    i_a => A,
    i_b => B,
    i_addn_sub => addSub,
    o_sum => SUM,
    o_cout => c_out,
    o_overflow => open,
    o_zero => open
 );

tb: process
begin
    addSub <= '1';
    A <= "0001";
    B <= "0010";
    wait for 20ns;
    addSub <= '0';
    A <= "0100";
    B <= "0010";
    wait for 20ns;
    A <= "0001";
    B <= "0010";
    wait for 20ns;
    A <= "0001";
    B <= "0010";
    wait for 20ns;
    A <= "0100";
    B <= "0010";
    addSub <= '1';
    wait for 20ns;
    wait;
end process;

end sim ; -- sim