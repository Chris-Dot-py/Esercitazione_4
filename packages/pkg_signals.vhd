library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

package pkg_signals is

    type t_block_data is array (0 to 31) of std_logic_vector(9 downto 0);
    type t_block_data_dim is array (0 to 31) of std_logic_vector(3 downto 0);
    type t_ch_label is array (0 to 31) of std_logic_vector(15 downto 0);

end package pkg_signals;

package body pkg_signals is
end package body pkg_signals;
