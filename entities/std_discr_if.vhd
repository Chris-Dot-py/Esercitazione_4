------------------------------------------------------------------------------------------
--  BLOCK DESCRIPTION :
--  On power on, the block starts on "reset_mode" until "config_mode" = '1'
--
--  This block has two operating modes: Configuration mode & Sampling Mode
--
--  Configuration Mode :
--      * Enters this mode when "config_mode" = '1'
--      * in this mode the SPI master configures the holt IC sending the following
--        commands :
--              1. set software_reset
--              2. clear software_reset
--              3. set sensor operating modes
--              4. set sensor threhold values according to the operating mode:
--                  4a. set gocenhys
--                  4b. set socenhys
--              5. set "config_done" = '1' then go into "sampling_mode"
--
--  Sampling Mode :
--      * Enters this mode after "set_thresholds" in configuration mode
--      * has a counter for sending the "spi_cmd" every 100us (10Ksps)
--      * Exits this mode when "config_mode" = '1'
------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;
use work.pkg_signals.all;

entity std_discr_if is
    port(
        clock : in std_logic; -- 100MHz
        reset : in std_logic;
        -- holt interface
        sclk : out std_logic;
        mosi : out std_logic;
        miso : in std_logic;
        csn : out std_logic;

        -- interface with "interface processing"
        send_snf_data : in std_logic;
        receive_snf_data : out std_logic;
        packet_out : out std_logic;

        -- temporary: to be revised
        config_mode : in std_logic;
        config_done : out std_logic;
        set_config : in std_logic_vector(31 downto 0);
        disable_ch : in std_logic_vector(31 downto 0);
        psen           : in std_logic_vector(3 downto 0);
        HI_threshold : in std_logic_vector(7 downto 0);
        LO_threshold : in std_logic_vector(7 downto 0);

        samples_present : out std_logic_vector(3 downto 0)
    );
end entity std_discr_if;

architecture std_discr_if_arch of std_discr_if is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------
    component spi_master
    generic (
      number_of_slaves : integer := 1
    );
    port (
      clock         : in  std_logic;
      reset         : in  std_logic;
      busy          : out std_logic;
      spi_cmd       : in  std_logic_vector(7 downto 0);
      rd_regs       : in  std_logic_vector(7 downto 0);
      data_byte_in  : in  std_logic_vector(7 downto 0);
      HI_threshold : in std_logic_vector(7 downto 0);
      LO_threshold : in std_logic_vector(7 downto 0);
      slv_addr      : in  std_logic_vector(number_of_slaves-1 downto 0);
      sense         : out std_logic_vector(31 downto 0);
      data_ready    : out std_logic;
      sclk          : out std_logic;
      mosi          : out std_logic;
      miso          : in  std_logic;
      csn           : out std_logic;
      clock_16MHz   : out std_logic
    );
    end component spi_master;

    component top_32_std_discr_ch
    generic (
      FIFO_len : integer := 10
    );
    port (
      clock_16MHz     : in  std_logic;
      reset           : in  std_logic;
      send_data_block : in  std_logic_vector(31 downto 0);
      data_ready      : in  std_logic;
      sense           : in  std_logic_vector(31 downto 0);
      o_data_ready    : out std_logic_vector(31 downto 0);
      block_data      : out t_block_data;
      block_data_dim  : out t_block_data_dim;
      set_config      : in  std_logic_vector(31 downto 0);
      disable_ch      : in  std_logic_vector(31 downto 0);
      ch_unavailable  : out std_logic_vector(31 downto 0);
      ch_label        : out t_ch_label
    );
    end component top_32_std_discr_ch;

    component packet_manager
    port (
      clock           : in  std_logic;
      reset           : in  std_logic;
      send_snf_data   : in  std_logic;
      receive_snf_data : out std_logic;
      packet_out      : out std_logic;
      send_data_block : out std_logic_vector(31 downto 0);

      ch_unavailable  : in  std_logic_vector(31 downto 0);
      load_pulse      : in  std_logic_vector(31 downto 0);
      ch_label        : in t_ch_label;
      block_data      : in  t_block_data;
      block_data_dim  : in  t_block_data_dim
    );
    end component packet_manager;



    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    constant number_of_slaves : integer range 0 to 3 := 1;
    constant FIFO_len : integer range 0 to 10 := 10;
    constant term_cnt : integer range 0 to 1650 := 1623; -- 1623 for 10us with 16.66MHz ( wr_bit is present every 99960 ns )

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    -- spi master
    signal busy         : std_logic;
    signal busy_d         : std_logic;
    signal clock_16MHz  : std_logic;
    signal sense        : std_logic_vector(31 downto 0);
    signal data_ready   : std_logic;

    -- configuration signals
    signal spi_cmd      : std_logic_vector(7 downto 0);
    signal rd_regs      : std_logic_vector(7 downto 0);
    signal data_byte_in : std_logic_vector(7 downto 0);
    -- placeholders
    signal r_psen : std_logic_vector(3 downto 0);
    signal r_HI_threshold : std_logic_vector(7 downto 0);
    signal r_LO_threshold : std_logic_vector(7 downto 0);
    -- channels
    signal send_data_block : std_logic_vector(31 downto 0);
    signal o_data_ready    : std_logic_vector(31 downto 0);
    signal block_data      : t_block_data;
    signal block_data_dim  : t_block_data_dim;
    signal ch_unavailable  : std_logic_vector(31 downto 0);
    signal ch_label        : t_ch_label;
    --packet manager

    -- config mode delay
    type t_config_states is (reset_mode, set_SRes, release_SRes, set_psen, set_gocenhys, set_socenhys, sampling_mode);
    signal current_state : t_config_states;

    signal cnt : std_logic_vector(10 downto 0);
    signal cnt_en : std_logic;

    signal first_threshold_setup_done : std_logic;
    signal data_byte_1_sent : std_logic;
    signal SRes_done : std_logic;
    signal config_done_w : std_logic;


    -- for testing purposes
    signal samples_present_w : std_logic_vector(3 downto 0);

begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    spi_master_i : spi_master
    generic map (
      number_of_slaves => number_of_slaves
    )
    port map (
      clock        => clock, --
      reset        => reset, --
      busy         => busy, --
      spi_cmd      => spi_cmd,
      rd_regs      => rd_regs,
      data_byte_in => data_byte_in,
      HI_threshold => r_HI_threshold,
      LO_threshold => r_LO_threshold,
      slv_addr     => "0", --
      sense        => sense, --
      data_ready   => data_ready, --
      sclk         => sclk, --
      mosi         => mosi, --
      miso         => miso, --
      csn          => csn, --
      clock_16MHz  => clock_16MHz --
    );

    top_32_std_discr_ch_i : top_32_std_discr_ch
    generic map (
      FIFO_len => FIFO_len
    )
    port map (
      clock_16MHz     => clock_16MHz, --
      reset           => reset, --
      send_data_block => send_data_block, --
      data_ready      => data_ready, --
      sense           => sense, --
      o_data_ready    => o_data_ready, --
      block_data      => block_data, --
      block_data_dim  => block_data_dim, --
      set_config      => set_config, --
      disable_ch      => disable_ch, --
      ch_unavailable  => ch_unavailable, --

      ch_label        => ch_label --
    );

    packet_manager_i : packet_manager
    port map (
      clock            => clock, --
      reset            => reset, --
      send_snf_data    => send_snf_data, --
      receive_snf_data => receive_snf_data, --
      packet_out       => packet_out, --
      send_data_block  => send_data_block, --

      ch_unavailable   => ch_unavailable, --
      load_pulse       => o_data_ready, --
      ch_label         => ch_label, --
      block_data       => block_data, --
      block_data_dim   => block_data_dim --
    );

    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_busy_delay : process(clock_16MHz,reset)
    begin
        if reset = '0' then
            busy_d <= '0';
        elsif rising_edge(clock_16MHz) then
            busy_d <= busy;
        end if;
    end process;

    samples_present <= samples_present_w;
    config_done <= config_done_w;
    p_setup_fsm : process(clock_16MHz, reset)
    begin
        if reset = '0' then
            current_state <= reset_mode;

            spi_cmd <= (others => '0');
            rd_regs <= (others => '0');
            data_byte_in <= (others => '0');

            r_psen <= (others => '0');
            r_HI_threshold <= (others => '0');
            r_LO_threshold <= (others => '0');

            first_threshold_setup_done <= '0';
            data_byte_1_sent <= '0';
            SRes_done <= '0';
            cnt <= (others => '0');
            cnt_en <= '0';
            config_done_w <= '0';

            samples_present_w <= (others => '0');
        elsif rising_edge(clock_16MHz) then

            case( current_state ) is

                when reset_mode =>
                    if config_mode = '1' then
                        if busy_d = '0' AND busy = '0'then
                            current_state <= set_SRes;
                            spi_cmd <= "10000000";
                            data_byte_in <= x"02";
                        end if;

                        config_done_w <= '0';
                        -- save params
                        r_psen <= psen;
                    end if;

                when set_SRes =>
                    if busy_d = '1' AND busy = '0' then
                        current_state <= release_SRes;
                        spi_cmd <= "10000000";
                        data_byte_in <= x"00";
                    end if;
                --
                when release_SRes =>
                    if busy_d = '1' AND busy = '0' then
                        current_state <= set_psen;
                        spi_cmd <= "01000000";
                        data_byte_in <= x"0A";
                    end if;

                when set_psen =>
                    if busy = '0' AND busy_d = '1' then
                        current_state <= set_gocenhys;
                        spi_cmd <= "00100000";
                        data_byte_in <= r_HI_threshold;
                        r_HI_threshold <= HI_threshold;
                        r_LO_threshold <= LO_threshold;
                    end if;

                when set_gocenhys =>
                    if busy = '0' AND busy_d = '1' then
                        current_state <= set_socenhys;
                        spi_cmd <= "00010000";
                        data_byte_in <= r_HI_threshold;
                        r_HI_threshold <= HI_threshold;
                        r_LO_threshold <= LO_threshold;
                    end if;

                when set_socenhys =>
                    if busy = '0' AND busy_d = '1' then
                        current_state <= sampling_mode;
                        spi_cmd <= "00000000";
                        data_byte_in <= x"00";
                        config_done_w <= '1';
                    end if;

                when sampling_mode =>
                    if config_mode = '0' then
                        if busy = '0' then
                            -- add timer for samples every 100us
                            if cnt < term_cnt then -- 1623 is
                                cnt <= cnt + 1;
                                spi_cmd <= "00000000";
                            else
                                spi_cmd <= "00000010";
                                if send_snf_data = '1' then
                                    samples_present_w <= (others => '0');
                                else
                                    samples_present_w <= samples_present_w + 1;
                                end if;
                                cnt <= (others => '0');
                            end if;

                        end if;

                        if send_snf_data = '1' then
                            samples_present_w <= (others => '0');
                        end if;
                    else
                        cnt <= (others => '0');
                        current_state <= reset_mode;
                    end if;

                when others =>
                    current_state <= reset_mode;
            end case;

        end if;
    end process;
end architecture;
