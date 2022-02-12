library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;

entity temp is
    port(
        clock : in std_logic;
        reset : in std_logic
    );
end entity temp;

architecture temp_arch of temp is
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
    -- instantiations
    --------------------------------------------------------------------------------------

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

end architecture;
