library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;
use work.pkg_signals.all;

entity tb_3 is
end entity tb_3;

architecture tb_3_arch of tb_3 is
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
      std_discr_label    : out std_logic_vector(15 downto 0)
    );
    end component std_discr_ch;

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

    component tb_output_analysis
    port (
      clock            : in  std_logic;
      reset            : in  std_logic;
      receive_snf_data : in  std_logic;
      packet_in        : in  std_logic
    );
    end component tb_output_analysis;

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

    signal r_HI_threshold : std_logic_vector(7 downto 0);
    signal r_LO_threshold : std_logic_vector(7 downto 0);

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

    -- packet_manager
    signal send_snf_data   : std_logic := '0';
    signal receive_snf_data : std_logic ;
    signal packet_out      : std_logic;
    signal send_data_block : std_logic_vector(31 downto 0) := (others => '0');
    signal i_ch_unavailable  : std_logic_vector(31 downto 0) := (others => '0');
    signal i_load_pulse      : std_logic_vector(31 downto 0) := (others => '0');
    signal block_data      : t_block_data;
    signal block_data_dim  : t_block_data_dim;
    signal ch_label        : t_ch_label;

    -- config signals
    signal disable_ch : std_logic_vector(31 downto 0);

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
        HI_threshold => r_HI_threshold,
        LO_threshold => r_LO_threshold,
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

    packet_manager_i : packet_manager
    port map (
      clock           => clock,
      reset           => reset,
      send_snf_data   => send_snf_data,
      receive_snf_data => receive_snf_data,
      packet_out      => packet_out,
      send_data_block => send_data_block,

      ch_unavailable => i_ch_unavailable,
      load_pulse      => i_load_pulse,
      block_data      => block_data,
      block_data_dim  => block_data_dim,
        ch_label      => ch_label
    );

    tb_output_analysis_i : tb_output_analysis
    port map (
      clock            => clock,
      reset            => reset,
      receive_snf_data => receive_snf_data,
      packet_in        => packet_out
    );

    -- CONFIGURATIONS
    disable_ch(31) <= '0';
    disable_ch(30) <= '0';
    disable_ch(29) <=  '0';
    disable_ch(28) <= '0';
    disable_ch(27) <= '0';
    disable_ch(26) <= '0';
    disable_ch(25) <= '0';
    disable_ch(24) <= '0';
    disable_ch(23) <= '0';
    disable_ch(22) <= '0';
    disable_ch(21) <= '0';
    disable_ch(20) <= '0';
    disable_ch(19) <= '0';
    disable_ch(18) <= '0';
    disable_ch(17) <= '0';
    disable_ch(16) <= '0';
    disable_ch(15) <= '0';
    disable_ch(14) <= '0';
    disable_ch(13) <= '0';
    disable_ch(12) <= '0';
    disable_ch(11) <= '0';
    disable_ch(10) <= '0';
    disable_ch(9) <= '0';
    disable_ch(8) <= '0';
    disable_ch(7) <= '0';
    disable_ch(6) <= '0';
    disable_ch(5) <= '0';
    disable_ch(4) <= '0';
    disable_ch(3) <= '0';
    disable_ch(1) <= '0';
    disable_ch(2) <= '0';
    disable_ch(0) <= '0';

    ch_32_i : std_discr_ch
    generic map (
      ch_label => x"AA1F",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(31), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(31),
      rd_data            => block_data(31),
      o_bits_stored      => block_data_dim(31),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(31), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(31), --

      std_discr_label    => ch_label(31) --
    );

    ch_31_i : std_discr_ch
    generic map (
      ch_label => x"AA1E",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(30), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(30),
      rd_data            => block_data(30),
      o_bits_stored      => block_data_dim(30),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(30), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(30), --

      std_discr_label    => ch_label(30) --
    );

    ch_30_i : std_discr_ch
    generic map (
      ch_label => x"AA1D",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(29), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(29),
      rd_data            => block_data(29),
      o_bits_stored      => block_data_dim(29),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(29), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(29), --

      std_discr_label    => ch_label(29) --
    );

    ch_29_i : std_discr_ch
    generic map (
      ch_label => x"AA1C",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(28), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(28),
      rd_data            => block_data(28),
      o_bits_stored      => block_data_dim(28),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(28), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(28), --

      std_discr_label    => ch_label(28) --
    );

    ch_28_i : std_discr_ch
    generic map (
      ch_label => x"AA1B",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(27), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(27),
      rd_data            => block_data(27),
      o_bits_stored      => block_data_dim(27),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(27), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(27), --

      std_discr_label    => ch_label(27) --
    );

    ch_27_i : std_discr_ch
    generic map (
      ch_label => x"AA1A",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(26), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(26),
      rd_data            => block_data(26),
      o_bits_stored      => block_data_dim(26),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(26), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(26), --

      std_discr_label    => ch_label(26) --
    );

    channel_25_i : std_discr_ch
    generic map (
      ch_label => x"AA19",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(25), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(25),
      rd_data            => block_data(25),
      o_bits_stored      => block_data_dim(25),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(25), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(25), --

      std_discr_label    => ch_label(25) --
    );

    channel_24_i : std_discr_ch
    generic map (
      ch_label => x"AA18",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(24), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(24),
      rd_data            => block_data(24),
      o_bits_stored      => block_data_dim(24),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(24), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(24), --

      std_discr_label    => ch_label(24) --
    );

    channel_23_i : std_discr_ch
    generic map (
      ch_label => x"AA17",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(23), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(23),
      rd_data            => block_data(23),
      o_bits_stored      => block_data_dim(23),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(23), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(23), --

      std_discr_label    => ch_label(23) --
    );

    channel_22_i : std_discr_ch
    generic map (
      ch_label => x"AA16",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(22), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(22),
      rd_data            => block_data(22),
      o_bits_stored      => block_data_dim(22),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(22), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(22), --

      std_discr_label    => ch_label(22) --
    );

    channel_21_i : std_discr_ch
    generic map (
      ch_label => x"AA15",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(21), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(21),
      rd_data            => block_data(21),
      o_bits_stored      => block_data_dim(21),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(21), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(21), --

      std_discr_label    => ch_label(21) --
    );

    channel_20_i : std_discr_ch
    generic map (
      ch_label => x"AA14",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(20), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(20),
      rd_data            => block_data(20),
      o_bits_stored      => block_data_dim(20),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(20), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(20), --

      std_discr_label    => ch_label(20) --
    );

    channel_19_i : std_discr_ch
    generic map (
      ch_label => x"AA13",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(19), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(19),
      rd_data            => block_data(19),
      o_bits_stored      => block_data_dim(19),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(19), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(19), --

      std_discr_label    => ch_label(19) --
    );

    channel_18_i : std_discr_ch
    generic map (
      ch_label => x"AA12",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(18), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(18),
      rd_data            => block_data(18),
      o_bits_stored      => block_data_dim(18),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(18), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(18), --

      std_discr_label    => ch_label(18) --
    );

    channel_17_i : std_discr_ch
    generic map (
      ch_label => x"AA11",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(17), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(17),
      rd_data            => block_data(17),
      o_bits_stored      => block_data_dim(17),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(17), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(17), --

      std_discr_label    => ch_label(17) --
    );

    channel_16_i : std_discr_ch
    generic map (
      ch_label => x"AA10",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(16), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(16),
      rd_data            => block_data(16),
      o_bits_stored      => block_data_dim(16),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(16), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(16), --

      std_discr_label    => ch_label(16) --
    );

    channel_15_i : std_discr_ch
    generic map (
      ch_label => x"AA0F",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(15), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(15),
      rd_data            => block_data(15),
      o_bits_stored      => block_data_dim(15),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(15), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(15), --

      std_discr_label    => ch_label(15) --
    );

    channel_14_i : std_discr_ch
    generic map (
      ch_label => x"AA0E",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(14), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(14),
      rd_data            => block_data(14),
      o_bits_stored      => block_data_dim(14),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(14), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(14), --

      std_discr_label    => ch_label(14) --
    );

    channel_13_i : std_discr_ch
    generic map (
      ch_label => x"AA0D",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(13), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(13),
      rd_data            => block_data(13),
      o_bits_stored      => block_data_dim(13),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(13), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(13), --

      std_discr_label    => ch_label(13) --
    );

    channel_12_i : std_discr_ch
    generic map (
      ch_label => x"AA0C",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(12), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(12),
      rd_data            => block_data(12),
      o_bits_stored      => block_data_dim(12),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(12), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(12), --

      std_discr_label    => ch_label(12) --
    );

    channel_11_i : std_discr_ch
    generic map (
      ch_label => x"AA0B",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(11), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(11),
      rd_data            => block_data(11),
      o_bits_stored      => block_data_dim(11),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(11), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(11), --

      std_discr_label    => ch_label(11) --
    );

    channel_10_i : std_discr_ch
    generic map (
      ch_label => x"AA0A",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(10), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(10),
      rd_data            => block_data(10),
      o_bits_stored      => block_data_dim(10),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(10), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(10), --

      std_discr_label    => ch_label(10) --
    );

    channel_9_i : std_discr_ch
    generic map (
      ch_label => x"AA09",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(9), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(9),
      rd_data            => block_data(9),
      o_bits_stored      => block_data_dim(9),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(9), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(9), --

      std_discr_label    => ch_label(9) --
    );

    channel_8_i : std_discr_ch
    generic map (
      ch_label => x"AA08",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(8), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(8),
      rd_data            => block_data(8),
      o_bits_stored      => block_data_dim(8),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(8), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(8), --

      std_discr_label    => ch_label(8) --
    );

    channel_7_i : std_discr_ch
    generic map (
      ch_label => x"AA07",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(7), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(7),
      rd_data            => block_data(7),
      o_bits_stored      => block_data_dim(7),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(7), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(7), --

      std_discr_label    => ch_label(7) --
    );

    channel_6_i : std_discr_ch
    generic map (
      ch_label => x"AA06",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(6), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(6),
      rd_data            => block_data(6),
      o_bits_stored      => block_data_dim(6),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(6), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(6), --

      std_discr_label    => ch_label(6) --
    );

    channel_5_i : std_discr_ch
    generic map (
      ch_label => x"AA05",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(5), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(5),
      rd_data            => block_data(5),
      o_bits_stored      => block_data_dim(5),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(5), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(5), --

      std_discr_label    => ch_label(5) --
    );

    channel_4_i : std_discr_ch
    generic map (
      ch_label => x"AA04",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(4), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(4),
      rd_data            => block_data(4),
      o_bits_stored      => block_data_dim(4),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(4), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(4), --

      std_discr_label    => ch_label(4) --
    );

    channel_3_i : std_discr_ch
    generic map (
      ch_label => x"AA03",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(3), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(3),
      rd_data            => block_data(3),
      o_bits_stored      => block_data_dim(3),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(3), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(3), --

      std_discr_label    => ch_label(3) --
    );

    channel_2_i : std_discr_ch
    generic map (
      ch_label => x"AA02",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(2), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(2),
      rd_data            => block_data(2),
      o_bits_stored      => block_data_dim(2),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(2), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(2), --

      std_discr_label    => ch_label(2) --
    );

    channel_1_i : std_discr_ch
    generic map (
      ch_label => x"AA01",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(1), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(1),
      rd_data            => block_data(1),
      o_bits_stored      => block_data_dim(1),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(1), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(1), --

      std_discr_label    => ch_label(1) --
    );

    channel_0_i : std_discr_ch
    generic map (
      ch_label => x"AA00",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(0), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(31),
      load_pulse         => i_load_pulse(0),
      rd_data            => block_data(0),
      o_bits_stored      => block_data_dim(0),
      std_discr_diag     => '0', --
      std_discr_o        => std_discr_o,--
      set_config         => set_config,--
      std_discr_disable  => disable_ch(0), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => std_discr_sbit_alm, --
      std_discr_ibit_alm => std_discr_ibit_alm, --
      ch_unavailable     => i_ch_unavailable(0), --

      std_discr_label    => ch_label(0) --
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
                send_snf_data <= '1';
                wait until rising_edge(clock_16MHz);
                send_snf_data <= '0';
            end if;
        end loop;

        for i in 0 to 8 loop
            if i = 8 then
                -- rd_op
                wait for 2700 ns;
                wait until rising_edge(clock_16MHz);
                send_snf_data <= '1';
                wait until rising_edge(clock_16MHz);
                send_snf_data <= '0';
            end if;
            wait until falling_edge(data_ready);
        end loop;

        for i in 0 to 9 loop
            if i = 3 then
                -- rd_op
                wait for 3000 ns;
                wait until rising_edge(clock_16MHz);
                send_snf_data <= '1';
                wait until rising_edge(clock_16MHz);
                send_snf_data <= '0';
            end if;
            wait until falling_edge(data_ready);
        end loop;

        wait for 10 us;
        wait until rising_edge(clock_16MHz);
        send_snf_data <= '1';
        wait until rising_edge(clock_16MHz);
        send_snf_data <= '0';
        wait;
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
