library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;

entity tb_2 is
end entity tb_2;

architecture tb_2_arch of tb_2 is
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

    component HI_8345
    port (
      sclk : in  std_logic;
      mosi : in  std_logic;
      miso : out std_logic;
      csn  : in  std_logic
    );
    end component HI_8345;

    component std_discr_ch
    generic (
      ch_label : std_logic_vector;
      FIFO_len : integer := 10
    );
    port (
      clock              : in  std_logic;
      reset              : in  std_logic;
      rd_op              : in  std_logic;
      wr_op              : in  std_logic;
      wr_data            : in  std_logic;
      load_pulse         : out std_logic;
      rd_data            : out std_logic_vector(FIFO_len-1 downto 0);
      o_bits_stored      : out std_logic_vector(3 downto 0);
      std_discr_diag     : in  std_logic;
      std_discr_o        : out std_logic;
      set_config         : in  std_logic;
      std_discr_dir      : in  std_logic;
      std_discr_disable  : in  std_logic;
      std_discr_sbit_en  : in  std_logic;
      std_discr_ibit_en  : in  std_logic;
      std_discr_sbit_alm : out std_logic;
      std_discr_ibit_alm : out std_logic;
      ch_unavailable     : out std_logic;
      unloading_done     : out std_logic;
      std_discr_label    : out std_logic_vector(15 downto 0)
    );
    end component std_discr_ch;


    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    constant number_of_slaves : integer range 0 to 3 := 1;
    constant FIFO_len : integer range 0 to 10 := 10;

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    signal HI_threshold   : integer range 6 to 44 := 21;
    signal LO_threshold   : integer range 4 to 42 := 9;

    signal clock          : std_logic;
    signal clock_16MHz    : std_logic;
    signal reset          : std_logic;
    signal busy           : std_logic;
    signal data_byte_in     : std_logic_vector(7 downto 0) := "00000000";
    signal slv_addr       : std_logic_vector(number_of_slaves-1 downto 0):= "0";

    signal sense          : std_logic_vector(31 downto 0);
    signal data_ready     : std_logic;

    signal sclk           : std_logic;
    signal mosi           : std_logic;
    signal miso           : std_logic;
    signal csn            : std_logic;

    -- spi_cmd
    signal set_ctrl       : std_logic := '0';
    signal set_psen       : std_logic := '0';
    signal set_gocenhys : std_logic := '0';
    signal set_socenhys : std_logic := '0';
    signal set_tmdata : std_logic := '0';
    signal rd_tmdata   : std_logic := '0';
    signal rd_all_ssb : std_logic := '0';
    -- rd_regs
    signal rd_r_ctrl    : std_logic := '0';
    signal rd_r_psen    : std_logic := '0';
    signal rd_r_gocenhys    : std_logic := '0';
    signal rd_r_socenhys    : std_logic := '0';
    signal rd_r_SSB0    : std_logic := '0';
    signal rd_r_SSB1    : std_logic := '0';
    signal rd_r_SSB2    : std_logic := '0';
    signal rd_r_SSB3    : std_logic := '0';

    -- memss
    signal rd_op              : std_logic := '0';
    signal wr_op              : std_logic;
    signal wr_data            : std_logic;
    signal load_pulse         : std_logic;
    signal rd_data            : std_logic_vector(FIFO_len-1 downto 0);
    signal o_bits_stored      : std_logic_vector(3 downto 0);
    signal std_discr_diag     : std_logic;
    signal std_discr_o        : std_logic;
    signal set_config         : std_logic;
    signal std_discr_dir      : std_logic;
    signal std_discr_disable  : std_logic;
    signal std_discr_sbit_en  : std_logic;
    signal std_discr_ibit_en  : std_logic;
    signal std_discr_sbit_alm : std_logic;
    signal std_discr_ibit_alm : std_logic;
    signal ch_unavailable     : std_logic;
    signal unloading_done     : std_logic;
    signal std_discr_label    : std_logic_vector(15 downto 0);


begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    spi_master_i : spi_master
    generic map (
        number_of_slaves => number_of_slaves
    )
    port map (
        clock         => clock,
        clock_16MHz   => clock_16MHz,
        reset         => reset,
        busy          => busy,
        spi_cmd(7) => set_ctrl,
        spi_cmd(6) => set_psen,
        spi_cmd(5) => set_gocenhys,
        spi_cmd(4) => set_socenhys,
        spi_cmd(3) => set_tmdata,
        spi_cmd(2) => rd_tmdata,
        spi_cmd(1) => rd_all_ssb,
        spi_cmd(0) => '0',
        rd_regs(7)        => rd_r_ctrl,
        rd_regs(6)        => rd_r_psen,
        rd_regs(5)        => rd_r_gocenhys,
        rd_regs(4)        => rd_r_socenhys,
        rd_regs(3)        => rd_r_SSB0,
        rd_regs(2)        => rd_r_SSB1,
        rd_regs(1)        => rd_r_SSB2,
        rd_regs(0)        => rd_r_SSB3,
        data_byte_in  => data_byte_in,
        slv_addr      => slv_addr,
        sense         => sense,
        data_ready    => data_ready,
        sclk          => sclk,
        mosi          => mosi,
        miso          => miso,
        csn           => csn
    );

    HI_8345_i : HI_8345
    port map (
      sclk => sclk,
      mosi => mosi,
      miso => miso,
      csn  => csn
    );

    std_discr_ch_i : std_discr_ch
    generic map (
      ch_label => std_discr_label,
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,
      rd_op              => rd_op,
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => load_pulse, --
      rd_data            => rd_data,
      o_bits_stored      => o_bits_stored,
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => '0', --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => ch_unavailable, --
      unloading_done     => unloading_done,--
      std_discr_label    => std_discr_label --
    );


    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_gen_clk_100MHz : process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    p_gen_rst : process
    begin
        reset <= '0';
        set_config <= '0';
        wait for 1 ns;
        reset <= '1';
        set_config <= '1';
        wait for 200 ns;
        set_config <= '0';

        wait;
    end process;

    p_rd_op : process
    begin
        wait for 500 ns;
        for i in 0 to 4 loop
            wait until falling_edge(data_ready);
            if i = 4 then
                -- rd_op
                wait for 400 ns;
                wait until rising_edge(clock_16MHz);
                rd_op <= '1';
                wait until rising_edge(clock_16MHz);
                rd_op <= '0';
            end if;
        end loop;

        for i in 0 to 8 loop
            if i = 8 then
                -- rd_op
                wait for 2700 ns;
                wait until rising_edge(clock_16MHz);
                rd_op <= '1';
                wait until rising_edge(clock_16MHz);
                rd_op <= '0';
            end if;
            wait until falling_edge(data_ready);
        end loop;

        for i in 0 to 8 loop
            wait until rising_edge(data_ready);
            if i = 4 then
                -- rd_op
                rd_op <= '1';
                wait until rising_edge(clock_16MHz);
                rd_op <= '0';
                wait until rising_edge(clock_16MHz);
            end if;
        end loop;

    end process;

    p_wr_op: process
    begin
        wait for 500 ns;
        -- store data
        for i in 0 to 5 loop
            wait for 3 us;
            rd_all_ssb <= '1';
            wait until rising_edge(busy);
            rd_all_ssb <= '0';
        end loop;

        -- store data
        for i in 0 to 8 loop
            wait for 3 us;
            rd_all_ssb <= '1';
            wait until rising_edge(busy);
            rd_all_ssb <= '0';
        end loop;

        -- store data
        for i in 0 to 8 loop
            wait for 3 us;
            rd_all_ssb <= '1';
            wait until rising_edge(busy);
            rd_all_ssb <= '0';
        end loop;


        wait;
    end process;


end architecture;
