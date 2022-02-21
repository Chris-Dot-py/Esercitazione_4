library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;

entity std_discr_ch is
    generic(ch_label : std_logic_vector(15 downto 0) := x"FFFF"; FIFO_len : integer := 10);
    port(
        clock : in std_logic; -- use 16.666MHz clock
        reset : in std_logic;

        freeze_data : in std_logic;
        rd_op : in std_logic; -- when 1, switch FIFO
        wr_op : in std_logic; -- use data_ready
        wr_data : in std_logic; -- sense(n) -- disabilitato se disable attivo

        load_pulse : out std_logic;
        rd_data : out std_logic_vector(FIFO_len-1 downto 0);
        o_bits_stored : out std_logic_vector(3 downto 0);

        std_discr_diag : in std_logic;
        std_discr_o : out std_logic; -- disabilitato se disable attivo

        set_config : in std_logic;
        std_discr_dir : in std_logic;
        std_discr_disable : in std_logic;
        std_discr_sbit_en : in std_logic;
        std_discr_ibit_en : in std_logic;

        std_discr_sbit_alm : out std_logic;
        std_discr_ibit_alm : out std_logic;
        ch_unavailable : out std_logic;
        unloading_done : out std_logic;

        std_discr_label : out std_logic_vector(15 downto 0)

        -- sanitization control signals are to be added
    );
end entity std_discr_ch;

architecture std_discr_ch_arch of std_discr_ch is
    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------

    -- maybe I can use just one, 2 arrays maybe isn't necessary
    type t_FIFO is array (0 to 1) of std_logic_vector(FIFO_len-1 downto 0);
    signal bit_FIFO : t_FIFO;

    type t_bits_stored_tracker is array (0 to 1) of std_logic_vector(3 downto 0);
    signal bits_stored : t_bits_stored_tracker;

    -- detect re
    signal rd_op_d : std_logic;
    signal wr_op_d : std_logic;

    signal wr_bit : std_logic;
    signal send_data_block : std_logic;

    signal wr_index : std_logic_vector(3 downto 0);
    signal FIFO_switch : std_logic;

    signal cnt_en : std_logic;
    signal cnt  : std_logic_vector(3 downto 0);
    -- wirings
    signal rd_data_w : std_logic_vector(9 downto 0);
    signal ch_unavailable_w : std_logic;

    -- no necessary: load_pulse (to be changed to data_ready) is enough
    signal unloading_done_w : std_logic;
    signal o_bits_stored_w : std_logic_vector(3 downto 0);
    signal std_discr_o_w : std_logic; -- not implemented yet

    -- config and status register
    signal r_config : std_logic_vector(3 downto 0);
    signal r_status : std_logic_vector(3 downto 0);

    -- load_pulse:
    signal load_pulse_w : std_logic;

    --LABEL
    signal std_discr_label_w : std_logic_vector(15 downto 0) := ch_label;

begin
    std_discr_label <= std_discr_label_w;
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------

    ch_unavailable <= ch_unavailable_w;
    ch_unavailable_w <= '1' when r_config(3) = '1' else
                      '1' when r_config(2) = '1' else
                      '0';

    std_discr_o <=  '0' when r_config(3) = '1' else
                    '0' when r_config(2) = '0' else
                    std_discr_o_w;

    p_save_config : process(clock, reset)
    begin
        if reset = '0' then
            r_config <= (others => '0');
            r_status <= (others => '0');
        elsif rising_edge(clock) then
            if set_config = '1' then
                r_config(3) <= std_discr_disable;
                r_config(2) <= std_discr_dir;
                r_config(1) <= std_discr_sbit_en; -- funz ancora da implementare
                r_config(0) <= std_discr_ibit_en; -- funz ancora da implementare
            end if;
        end if;
    end process;

    p_detect_re : process(clock, reset)
    begin
        if reset = '0' then
            rd_op_d <= '0';
            wr_op_d <= '0';
            wr_bit <= '0';
            send_data_block <= '0';
        elsif rising_edge(clock) then
            rd_op_d <= rd_op;
            wr_op_d <= wr_op;

            -- save sense value command
            if wr_op = '1' AND wr_op_d = '0' then
                wr_bit <= '1';
            else
                wr_bit <= '0';
            end if;

            -- send block data command
            if rd_op = '1' AND rd_op_d = '0' then
                send_data_block <= '1';
            else
                send_data_block <= '0';
            end if;
        end if;
    end process;


    rd_data <= rd_data_w;
    o_bits_stored <= o_bits_stored_w;
    load_pulse <= load_pulse_w;
    unloading_done <= unloading_done_w;
    P_fifo : process(clock, reset)
    begin
        if reset = '0' then
            bit_FIFO <= (others => (others => '0'));
            bits_stored <= (others => (others => '0'));
            FIFO_switch <= '0';
            load_pulse_w <= '0';
            unloading_done_w <= '0';
            rd_data_w <= (others => '0');
            o_bits_stored_w <= (others => '0');

        elsif rising_edge(clock) then

            -- write buffer operation
            if (r_config(3) = '0') AND (r_config(2)) = '0' then
                if wr_bit = '1' then
                        if send_data_block = '1' then
                            bit_FIFO(conv_integer(not FIFO_switch))(9) <= wr_data;
                            bits_stored(conv_integer(not FIFO_switch)) <= bits_stored(conv_integer(not FIFO_switch)) + 1;
                        else
                            bit_FIFO(conv_integer(FIFO_switch))(conv_integer(wr_index)) <= wr_data;
                            bits_stored(conv_integer(FIFO_switch)) <= bits_stored(conv_integer(FIFO_switch)) + 1;
                        end if;
                end if;
            end if;

            -- raad buffer operation
            unloading_done_w <= load_pulse_w;
            if ch_unavailable_W = '0' then
                if send_data_block = '1' then
                    load_pulse_w <= '1';
                    FIFO_switch <= not FIFO_switch;
                    rd_data_w <= bit_FIFO(conv_integer(FIFO_switch));
                    o_bits_stored_w <= bits_stored(conv_integer(FIFO_switch));
                    bit_FIFO(conv_integer(FIFO_switch)) <= (others => '0');
                    bits_stored(conv_integer(FIFO_switch)) <= (others => '0');
                else
                    load_pulse_w <= '0';
                end if;
            end if;
        end if;

    end process;

    p_gestione_wr_index : process(clock, reset)
    begin
        if reset = '0' then
            wr_index <= "1001";
        elsif rising_edge(clock) then
            if (r_config(3) = '0') AND (r_config(2)) = '0' then
                if wr_bit = '1' AND send_data_block = '1' then
                    wr_index <= "1001";
                elsif wr_bit = '1' and send_data_block = '0' then
                    if wr_index = 0 then
                        wr_index <= "1001";
                    else
                        wr_index <= wr_index - 1;
                    end if;
                elsif wr_bit = '0' and send_data_block = '1' then
                    wr_index <= "1001";
                end if;
            end if;

        end if;
    end process;

end architecture;
