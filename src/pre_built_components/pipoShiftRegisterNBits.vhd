library ieee;
use ieee.std_logic_1164.all;

library basic_rtl;
use basic_rtl.all;


entity pipoShiftRegisterNBits is
    generic(
        DataWidth: natural := 1
    );
    port (
        i_in: in std_logic_vector ((DataWidth-1) downto 0); 
        i_serialIn: in std_logic;
        i_shitLeftn_shiftRight: in std_logic;
        i_load: in std_logic;
        i_clk: in std_logic;
        i_cen: in std_logic;
        i_resetn: in std_logic;
        o_serialOut: out std_logic;
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end entity pipoShiftRegisterNBits;

architecture rtl of pipoShiftRegisterNBits is
component registerNbits is
    generic(
        DataWidth: integer := 1
    );
    port (
        i_in: in std_logic_vector ((DataWidth-1) downto 0); 
        i_clear: in std_logic;
        i_load: in std_logic;
        i_clock: in std_logic;
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end component;
component busMux4x1 is
    generic(
        DataWidth: integer := 1
    );
    port (
        i_in0: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in1: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in2: in std_logic_vector ((DataWidth-1) downto 0); 
        i_in3: in std_logic_vector ((DataWidth-1) downto 0); 
        i_sel: in std_logic_vector (1 downto 0);
        o_out: out std_logic_vector ((DataWidth-1) downto 0)
    );
end component;

signal int_mux_sel: std_logic_vector(1 downto 0);
signal int_shift_left, int_shift_right, int_out, int_mux_out: std_logic_vector(DataWidth - 1 downto 0);

begin

int_mux_sel <= i_load & i_shitLeftn_shiftRight;

int_shift_left <= int_out(DataWidth - 2 downto 0) & i_serialIn;
int_shift_right <= i_serialIn & int_out(DataWidth - 1 downto 1);

mode_sel: entity basic_rtl.busMux4x1
 generic map(
    DataWidth => DataWidth
)
 port map(
    i_in0 => int_shift_left,
    i_in1 => int_shift_right,
    i_in2 => i_in,
    i_in3 => i_in,
    i_sel => int_mux_sel,
    o_out => int_mux_out
);
registerNbits_inst: entity basic_rtl.registerNbits
 generic map(
    DataWidth => DataWidth
)
 port map(
    i_in => int_mux_out,
    i_load => '1',
    i_clk => i_clk,
    i_cen => i_cen,
    i_resetn => i_resetn,
    o_out => int_out
);

-- Ouput Drivers
o_out <= int_out;
o_serialOut <= (int_out(DataWidth-1) and not i_shitLeftn_shiftRight) or (int_out(0) and i_shitLeftn_shiftRight);

end architecture; -- rtl