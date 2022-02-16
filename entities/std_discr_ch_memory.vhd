library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;

entity std_discr_ch_memory is
    generic(FIFO_len : integer := 16);
    port(
        clock : in std_logic; -- use 16.666MHz clock
        reset : in std_logic;

        rd_op : in std_logic; -- when 1, switch FIFO

        wr_op : in std_logic; -- use data_ready
        wr_data : in std_logic; -- sense(n)

        rd_data : out std_logic;
        o_bits_stored : out std_logic_vector(3 downto 0)

        -- sanitization control signals are to be added
    );
end entity std_discr_ch_memory;

architecture std_discr_ch_memory_arch of std_discr_ch_memory is
    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type t_FIFO is array (0 to 1) of std_logic_vector(FIFO_len-1 downto 0);
    signal bit_FIFO : t_FIFO;

    type t_bits_stored_tracker is array (0 to 1) of std_logic_vector(3 downto 0);
    signal bits_stored : t_bits_stored_tracker;

    signal wr_index : std_logic_vector(3 downto 0);
    signal FIFO_switch : std_logic;
    signal busy_unloading_FIFO : std_logic;

    signal cnt_en : std_logic;
    signal cnt  : std_logic_vector(3 downto 0);
    -- wirings
    signal rd_data_w : std_logic;

begin
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    rd_data <= rd_data_w;
    o_bits_stored <= bits_stored(conv_integer(busy_unloading_FIFO));
    P_fifo : process(clock, reset)
    begin
        if reset = '0' then
            bit_FIFO <= (others => (others => '0'));
            bits_stored <= (others => (others => '0'));
            wr_index <= (others => '1');
            FIFO_switch <= '0';
            busy_unloading_FIFO <= '0';
            rd_data_w <= '0';

            cnt_en <= '0';
            cnt <= (others => '0');
        elsif rising_edge(clock) then

            -- OPTIMIZE THE INDEXES
            -- store bits starting from MSB
            if wr_op = '1' then
                if rd_op = '1' then
                    bit_FIFO(conv_integer(not FIFO_switch))(15) <= wr_data;
                    bits_stored(conv_integer(not FIFO_switch)) <= bits_stored(conv_integer(not FIFO_switch)) + 1;
                else
                    bit_FIFO(conv_integer(FIFO_switch))(conv_integer(wr_index)) <= wr_data;
                    bits_stored(conv_integer(FIFO_switch)) <= bits_stored(conv_integer(FIFO_switch)) + 1;
                end if;
            end if;

            -- gestione wr_index
            if wr_op = '1' AND rd_op = '1' then
                wr_index <= x"E";
            elsif wr_op = '1' and rd_op = '0' then
                wr_index <= wr_index - 1;
            elsif cnt_en = '0' and rd_op = '1' then
                wr_index <= (others => '1');
            end if;

            -- when reading: freeze fifo and switch to the other fifo
            -- and shift out to the last bit inserted
            if rd_op = '1' then
                cnt_en <= '1';
                cnt <= (others => '0');
                busy_unloading_FIFO <= FIFO_switch;
                FIFO_switch <= not FIFO_switch;
            elsif cnt_en = '1' then
                if cnt < bits_stored(conv_integer(busy_unloading_FIFO)) then
                    rd_data_w <= bit_FIFO(conv_integer(busy_unloading_FIFO))(15);
                    bit_FIFO(conv_integer(busy_unloading_FIFO))(0) <= '0';
                    for i in 0 to 14 loop
                        bit_FIFO(conv_integer(busy_unloading_FIFO))(i + 1) <= bit_FIFO(conv_integer(busy_unloading_FIFO))(i);
                    end loop;
                    cnt <= cnt + 1;
                else
                    cnt_en <= '0';
                    cnt <= (others => '0');
                    bits_stored(conv_integer(busy_unloading_FIFO)) <= (others => '0');
                end if;
            end if;

        end if;
    end process;

end architecture;
