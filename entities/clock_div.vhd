library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;

entity clock_div is
    port(
        clock_in : in std_logic;
        reset : in std_logic
        clock_out : out std_logic
    );
end entity clock_div;

architecture clock_div_arch of clock_div is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    constant
    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    signal

begin
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    process(clock, reset)
    begin
        if reset = '0' then

        elsif rising_edge(clock) then

        end if;
    end process;

end architecture;
