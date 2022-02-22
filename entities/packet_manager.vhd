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
        receive_snf_data : out std_logic;
        packet_out : out std_logic;

        send_data_block : out std_logic_vector(31 downto 0);
        unloading_done : in std_logic_vector(31 downto 0);
        ch_unavailable : in std_logic_vector(31 downto 0);
        load_pulse : in std_logic_vector(31 downto 0);
        ch_label : in t_ch_label;
        block_data : in t_block_data := (others => (others => '0'));
        block_data_dim : in t_block_data_dim := (others => (others => '0'))
    );
end entity packet_manager;

architecture packet_manager_arch of packet_manager is
    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type states is (idle, collect_data, freeze_dt, calc_total_len, send_packet);
    signal current_state : states;

    -- TO REMOVE: send_packet_placeholder is enough
    type t_ch_data_blocks is array (0 to 31) of std_logic_vector(9 downto 0);
    signal ch_data_block : t_ch_data_blocks;

    -- TO REMOVE: send_packet_placeholder is enough
    type t_ch_data_block_dim is array (0 to 31) of std_logic_vector(3 downto 0);
    signal ch_data_block_dim : t_ch_data_block_dim;

    type t_send_packet_placeholder is array (0 to 32) of std_logic_vector(29 downto 0);
    signal send_packet_placeholder : t_send_packet_placeholder;

    signal index : integer range 0 to 31;

    signal total_len : std_logic_vector(15 downto 0); -- 16 bit
    signal total_data_blocks : std_logic_vector(5 downto 0);

    signal cnt_en : std_logic; -- needed
    signal cnt : integer range 0 to 2**16; -- total bit len counter (can be removed eventually)
    signal i : integer range 0 to 30; -- saved_data_block_bit index
    signal j : integer range 0 to 33; -- saved data_block_index

    -- wirings
    signal send_data_block_w : std_logic_vector(31 downto 0);
    signal packet_out_w : std_logic;

begin
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    send_data_block <= send_data_block_w;
    packet_out <= packet_out_w when current_state = send_packet else
                    'Z'; -- 'Z' is just for waveform readability

    p_fsm : process(clock, reset)
        -- just for testing
        variable L : line;
    begin
        if reset = '0' then
            current_state <= idle;
            ch_data_block <= (others => (others => '0'));
            ch_data_block_dim <= (others => (others => '0'));

            cnt_en <= '0';
            cnt <= 0;
            send_data_block_w <= (others => '0');
            total_len <= x"0010";
            total_data_blocks <= (others => '0');
            i <= 0;
            j <= 0;

            receive_snf_data <= '0';
            packet_out_w <= '0';
            send_packet_placeholder <= (others => (others => '0'));
            index <= 31;
        elsif rising_edge(clock) then
            case( current_state ) is

                --========
                when idle =>
                --========
                    -- when send_snf_data = '1' -> collect data from all channels
                    if send_snf_data = '1' then
                        send_data_block_w <= not (ch_unavailable);
                        current_state <= freeze_dt;
                    end if;

                --========
                when freeze_dt =>
                --========
                    if load_pulse =  not (ch_unavailable) then
                        send_data_block_w <= (others => '0');
                        current_state <= collect_data;
                    end if;

                --========
                when collect_data =>
                --========
                    -- raise "send_data_block" flag and, if channel is available, load
                    -- data with "load_pulse"
                    -- make use of a memory where to store data so that available data
                    -- can be stored next to each other
                    -- repeat for all 32 channels
                    if cnt <= 31 then
                        -- need to add a statement that waits for the unloading of data
                        -- block to be done
                            ch_data_block(cnt) <=   block_data(cnt);
                            ch_data_block_dim(cnt) <= block_data_dim(cnt);

                            -- add total bit len for eache block
                            if ch_unavailable(cnt) = '0' then
                                send_packet_placeholder(index)(29 downto 14) <= ch_label(cnt);

                                    -- -- just for testing
                                    -- write(L, string'("channel "));
                                    -- write(L,cnt, field => 2);
                                    -- write(L,string'(" has "));
                                    -- write(L,string'("label : "));
                                    -- for k in 1 to 16 loop
                                    --     write(L, ch_label(cnt)(16 - k));
                                    --     if (k mod 4) = 0 then
                                    --         write(L,string'("_"));
                                    --     end if;
                                    -- end loop;
                                    -- write(L,string'(" "));

                                send_packet_placeholder(index)(13 downto 10) <= block_data_dim(cnt);

                                    -- -- just for testing
                                    -- write(L,string'("block_data dim: "));
                                    -- write(L, block_data_dim(cnt));
                                    -- write(L,string'(" "));

                                send_packet_placeholder(index)(9 downto 0) <= block_data(cnt);

                                    -- -- just for testing
                                    -- write(L,string'("block_data : "));
                                    -- for k in 1 to 10 loop
                                    --     write(L, block_data(cnt)(10 - k));
                                    --     if (k mod 4) = 0 then
                                    --         write(L,string'("_"));
                                    --     end if;
                                    -- end loop;
                                    -- write(L,string'(" "));
                                    -- writeline(output, L);

                                if index > 0 then
                                    index <= index - 1;
                                end if;

                                total_data_blocks <= total_data_blocks + 1;
                            end if;

                            send_data_block_w(cnt) <= '0';
                            cnt <= cnt + 1;
                    else
                        cnt <= 0;
                        index <= 31;
                        total_data_blocks <= total_data_blocks + 1; -- for total_len
                        total_len <= x"0010";
                        current_state <= calc_total_len;
                    end if;

                --========
                when calc_total_len =>
                --========
                    -- add all block_dims and use it as terminal cnt for the send process
                    if  cnt < 32 then
                        if ch_unavailable(cnt) = '0' then
                            total_len <= total_len + x"14" + block_data_dim(cnt);
                            -- write(L, block_data_dim(cnt));
                            -- writeline(output, L);
                        end if;
                        cnt <= cnt + 1;
                    else
                        cnt <= 0;
                        i <= 0;
                        j <= 0;
                        send_packet_placeholder(32)(29 downto 14) <= total_len;
                        current_state <= send_packet;
                    end if;


                --========
                when send_packet =>
                --========
                    if cnt < total_len then
                        receive_snf_data <= '1';

                        if j < total_data_blocks then
                            -- send total_len first
                            if j = 0 then
                                if i < 15 then
                                    packet_out_w <= send_packet_placeholder(32 - j)(29 - i);
                                    -- write(L, send_packet_placeholder(32 - j)(29 - i));
                                    -- if ((i + 1) mod 4) = 0 then
                                    --     write(L, string'("_"));
                                    -- end if;
                                    i <= i + 1;
                                else
                                    packet_out_w <= send_packet_placeholder(32 - j)(29 - 15);
                                        -- write(L, send_packet_placeholder(32 - j)(29 - i));
                                        -- write(L, string'(" has been sent as total_len "));
                                        -- writeline(output, L);
                                    i <= 0;
                                    j <= j + 1;
                                end if;
                            else
                                -- send data_blocks
                                if i < (20 + conv_integer(send_packet_placeholder(32 - j)(13 downto 10)) - 1) then
                                    packet_out_w <= send_packet_placeholder(32 - j)(29 - i);
                                    --     write(L, send_packet_placeholder(32 - j)(29 - i));
                                    -- if ((i + 1) mod 4) = 0 then
                                    --     write(L, string'("_"));
                                    -- end if;
                                    i <= i + 1;
                                else
                                    packet_out_w <= send_packet_placeholder(32 - j)(29 - (20 + conv_integer(send_packet_placeholder(32 - j)(13 downto 10)) - 1));
                                        -- write(L, send_packet_placeholder(32 - j)(29 - i));
                                        -- write(L, string'(" has been sent as data block : "));
                                        -- write(L, j);
                                        -- writeline(output, L);
                                    i <= 0;
                                    j <= j + 1;
                                end if;

                            end if;
                        end if;
                        cnt <= cnt + 1;
                    else
                        cnt <= 0;
                        i <= 0;
                        j <= 0;
                        receive_snf_data <= '0';
                        total_data_blocks <= (others => '0');
                        total_len <= x"0010";
                        send_packet_placeholder <= (others => (others => '0'));
                        current_state <= idle;
                    end if;

                --========
                when others =>
                --========
                    current_state <= idle;

            end case;
        end if;
    end process;

end architecture;
