library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;
use work.pkg_signals.all;

entity packet_manager is
    port(
        clock : in std_logic;
        reset : in std_logic;

        send_snf_data : in std_logic;
        packet_out : out std_logic;

        send_data_block : out std_logic_vector(31 downto 0);
        unloading_done : in std_logic_vector(31 downto 0);
        ch_unavailable : in std_logic_vector(31 downto 0);

        load_pulse : in std_logic;
        block_data : in t_block_data;
        block_data_dim : in t_block_data_dim
    );
end entity packet_manager;

architecture packet_manager_arch of packet_manager is
    --------------------------------------------------------------------------------------
    -- components
    --------------------------------------------------------------------------------------
    component clock_div
    port (
      clock_in  : in  std_logic;
      reset     : in  std_logic;
      clock_out : out std_logic
    );
    end component clock_div;

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type states is (idle, collect_data, calc_total_len, send_packet);
    signal current_state : states;

    type t_ch_data_blocks is array (0 to 31) of std_logic_vector(9 downto 0);
    signal ch_data_block : t_ch_data_blocks;

    type t_ch_data_block_dim is array (0 to 31) of std_logic_vector(3 downto 0);
    signal ch_data_block_dim : t_ch_data_block_dim;

    signal total_len : std_logic_vector(15 downto 0); -- 16 bit

    signal cnt_en : std_logic;
    signal cnt : std_logic_vector(5 downto 0); -- use this for ch label

    signal send_packet : std_logic;
    signal send_data_block_w : std_logic_vector(31 downto 0);

    signal rd_op : std_logic;
    signal wr_op : std_logic;

    signal clock_16MHz : std_logic;

begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    clock_div_i : clock_div
    port map (
      clock_in  => clock,
      reset     => reset,
      clock_out => clock_16MHz
    );

    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    send_data_block <= send_data_block_w;
    p_fsm : process(clock, reset)
    begin
        if reset = '0' then
            current_state <= idle;

            cnt_en <= '0';
            cnt <= (others => '0');
            send_data_block_w <= (others => '0');

            ch_data_block <= (others => (others => '0'));
            ch_data_block_dim <= (others => (others => '0'));

            total_len <= (others => '0');
        elsif rising_edge(clock) then
            case( current_state ) is

                when idle =>
                    -- when send_snf_data = '1' -> collect data from all channels
                    -- one by one
                    if send_snf_data = '1' then
                        current_state <= collect_data;
                    end if;

                when collect_data =>
                    -- raise "send_data_block" flag and, if channel is available, load
                    -- data serially in registers
                    -- repeat for all 32 channels
                    if cnt < 32 then
                        -- need to add a statement that waits for the unloading of data
                        -- block to be done
                        if unloading_done(cnt) = '1' OR ch_unavailable(cnt) = '1' then
                            send_data_block_w(cnt) <= '0';
                            cnt <= cnt + 1;
                        else
                            -- 2 clock cycles of 16.666MHz clock after this the data arrives
                            send_data_block_w(cnt) <= '1';
                        end if;
                    else
                        cnt <= (others => '0');
                        current_state <= calc_total_len;
                    end if;

                when calc_total_len =>
                    -- add all block_dims and use it as terminal cnt for the send process
                    if  cnt < 32 then
                        total_len <= total_len + 20 + ch_data_block_dim(cnt);
                        cnt <= cnt + 1;
                    else
                        cnt <= (others => '0');
                        current_state <= send_packet;
                    end if;

                when send_packet =>
                    -- use counter from 0 to total_len for sending packet with 100MHz
                    if cnt < total_len then
                        -- add counter for the total len header
                        -- add counters which term_cnts corresponds to the dimension of ch block datas
                        -- add shift register for packet_out or index pointer

                        cnt <= cnt + 1;
                    else
                        total_len <= (others => '0');
                    end if;

                when others =>
                    current_state <= idle;

            end case;
        end if;
    end process;

    p_load_data : process(load_pulse, reset)
    begin
        if falling_edge(load_pulse) then
            ch_data_block(cnt) <=   block_data(cnt);
            ch_data_block_dim(cnt) <= block_data_dim(cnt);
        end if;
    end process;

end architecture;
