library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;

entity std_discr_ch is
    generic(ch_label : std_logic_vector(15 downto 0));
    port(
        clock : in std_logic;
        reset : in std_logic

        send_snf_data : in std_logic;
        sense_in : in std_logic;

        std_discr_if : inout std_logic; -- (?)
        std_discr_o : out std_logic; -- (?)

        std_discr_diag : in std_logic;
        std_discr_dir : in std_logic;
        std_discr_disable : in std_logic
        std_discr_label : out std_logic_vector(15 downto 0)
        std_discr_sbit_en : in std_logic;
        std_discr_sbit_alm : out std_logic;
        std_discr_ibit_en : in std_logic;
        std_discr_ibit_alm : out std_logic
    );
end entity std_discr_ch;

architecture std_discr_ch_arch of std_discr_ch is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------
    -- add memory to store sensi_in datas (FIFO)
    -- For every interface, the data to the Backbone can be idealized as made of three o due? è DUE!
    -- buffers. The received data from the interfaces can be stored in two buffers; when
    -- the packet are required, the first buffer is frozen, the incoming data are stored
    -- in the second buffer, while the data from the first buffer are sent to the Backbone.
    -- When the updated packet is required, the second buffer freezes its data and sends
    -- them, the first reads its incoming data.

    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    constant std_discr_label : std_logic_vector(15 downto 0) := ch_label;
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