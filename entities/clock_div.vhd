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
        clock_in : in std_logic; -- 100 MHz
        reset : in std_logic;
        clock_out : out std_logic
    );
end entity clock_div;

architecture clock_div_arch of clock_div is
    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    -- base counter for internal clock @ 16.66..MHz
    signal cnt : std_logic_vector(1 downto 0);
    signal clk_16MHz : std_logic;

begin
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    clock_out <= clk_16MHz;
    process(clock_in, reset)
    begin
        if reset = '0' then
            clk_16MHz <= '0';
            cnt <= (others => '0');
        elsif rising_edge(clock_in) then
            if cnt = 2 then
                cnt <= (others => '0');
                clk_16MHz <= not clk_16MHz;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

end architecture;
