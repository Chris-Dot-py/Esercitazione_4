library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;
use work.pkg_signals.all;

entity top_32_std_discr_ch is
    generic( FIFO_len : integer := 10 );
    port(
        clock_16MHz : in std_logic;
        reset : in std_logic;

        send_data_block : in std_logic_vector(31 downto 0);
        data_ready      : in std_logic;
        sense           : in std_logic_vector(31 downto 0);
        o_data_ready      : out std_logic_vector(31 downto 0);
        block_data      : out t_block_data;
        block_data_dim  : out t_block_data_dim;

        set_config : in std_logic_vector(31 downto 0);
        disable_ch : in std_logic_vector(31 downto 0);
        ch_unavailable : out std_logic_vector(31 downto 0);
        ch_label       : out t_ch_label
    );
end entity top_32_std_discr_ch;

architecture top_32_std_discr_ch_arch of top_32_std_discr_ch is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------
    component std_discr_ch
    generic (
      ch_label : std_logic_vector;
      FIFO_len : integer := 10
    );
    port (
      clock              : in  std_logic; --
      reset              : in  std_logic; --
      rd_op              : in  std_logic; --
      wr_op              : in  std_logic; --
      wr_data            : in  std_logic; --
      o_data_ready         : out std_logic; --
      rd_data            : out std_logic_vector(FIFO_len-1 downto 0); --
      o_bits_stored      : out std_logic_vector(3 downto 0); --
      std_discr_diag     : in  std_logic; -- to do
      std_discr_o        : out std_logic; --
      set_config         : in  std_logic; --
      std_discr_dir      : in  std_logic; --
      std_discr_disable  : in  std_logic; --
      std_discr_sbit_en  : in  std_logic; --
      std_discr_ibit_en  : in  std_logic; --
      std_discr_sbit_alm : out std_logic; --
      std_discr_ibit_alm : out std_logic; --
      ch_unavailable     : out std_logic; --
      std_discr_label    : out std_logic_vector(15 downto 0) --
    );
    end component std_discr_ch;

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------

begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    channel_31_i : std_discr_ch
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
      o_data_ready => o_data_ready(31),
      rd_data            => block_data(31),
      o_bits_stored      => block_data_dim(31),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(31),--
      std_discr_disable  => disable_ch(31), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(31), --

      std_discr_label    => ch_label(31) --
    );

    channel_30_i : std_discr_ch
    generic map (
      ch_label => x"AA1E",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(30), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(30),
      o_data_ready => o_data_ready(30),
      rd_data            => block_data(30),
      o_bits_stored      => block_data_dim(30),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(30),--
      std_discr_disable  => disable_ch(30), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(30), --

      std_discr_label    => ch_label(30) --
    );

    channel_29_i : std_discr_ch
    generic map (
      ch_label => x"AA1D",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(29), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(29),
      o_data_ready => o_data_ready(29),
      rd_data            => block_data(29),
      o_bits_stored      => block_data_dim(29),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(29),--
      std_discr_disable  => disable_ch(29), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(29), --

      std_discr_label    => ch_label(29) --
    );

    channel_28_i : std_discr_ch
    generic map (
      ch_label => x"AA1C",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(28), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(28),
      o_data_ready => o_data_ready(28),
      rd_data            => block_data(28),
      o_bits_stored      => block_data_dim(28),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(28),--
      std_discr_disable  => disable_ch(28), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(28), --

      std_discr_label    => ch_label(28) --
    );

    channel_27_i : std_discr_ch
    generic map (
      ch_label => x"AA1B",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(27), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(27),
      o_data_ready => o_data_ready(27),
      rd_data            => block_data(27),
      o_bits_stored      => block_data_dim(27),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(27),--
      std_discr_disable  => disable_ch(27), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(27), --

      std_discr_label    => ch_label(27) --
    );

    channel_26_i : std_discr_ch
    generic map (
      ch_label => x"AA1A",
      FIFO_len => FIFO_len
    )
    port map (
      clock              => clock_16MHz,
      reset              => reset,

      rd_op              => send_data_block(26), -- send ch_data_block
      wr_op              => data_ready,
      wr_data            => sense(26),
      o_data_ready => o_data_ready(26),
      rd_data            => block_data(26),
      o_bits_stored      => block_data_dim(26),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(26),--
      std_discr_disable  => disable_ch(26), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(26), --

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
      wr_data            => sense(25),
      o_data_ready => o_data_ready(25),
      rd_data            => block_data(25),
      o_bits_stored      => block_data_dim(25),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(25),--
      std_discr_disable  => disable_ch(25), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(25), --

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
      wr_data            => sense(24),
      o_data_ready => o_data_ready(24),
      rd_data            => block_data(24),
      o_bits_stored      => block_data_dim(24),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(24),--
      std_discr_disable  => disable_ch(24), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(24), --

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
      wr_data            => sense(23),
      o_data_ready => o_data_ready(23),
      rd_data            => block_data(23),
      o_bits_stored      => block_data_dim(23),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(23),--
      std_discr_disable  => disable_ch(23), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(23), --

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
      wr_data            => sense(22),
      o_data_ready => o_data_ready(22),
      rd_data            => block_data(22),
      o_bits_stored      => block_data_dim(22),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(22),--
      std_discr_disable  => disable_ch(22), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(22), --

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
      wr_data            => sense(21),
      o_data_ready => o_data_ready(21),
      rd_data            => block_data(21),
      o_bits_stored      => block_data_dim(21),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(21),--
      std_discr_disable  => disable_ch(21), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(21), --

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
      wr_data            => sense(20),
      o_data_ready => o_data_ready(20),
      rd_data            => block_data(20),
      o_bits_stored      => block_data_dim(20),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(20),--
      std_discr_disable  => disable_ch(20), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(20), --

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
      wr_data            => sense(19),
      o_data_ready => o_data_ready(19),
      rd_data            => block_data(19),
      o_bits_stored      => block_data_dim(19),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(19),--
      std_discr_disable  => disable_ch(19), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(19), --

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
      wr_data            => sense(18),
      o_data_ready => o_data_ready(18),
      rd_data            => block_data(18),
      o_bits_stored      => block_data_dim(18),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(18),--
      std_discr_disable  => disable_ch(18), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(18), --

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
      wr_data            => sense(17),
      o_data_ready => o_data_ready(17),
      rd_data            => block_data(17),
      o_bits_stored      => block_data_dim(17),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(17),--
      std_discr_disable  => disable_ch(17), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(17), --

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
      wr_data            => sense(16),
      o_data_ready => o_data_ready(16),
      rd_data            => block_data(16),
      o_bits_stored      => block_data_dim(16),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(16),--
      std_discr_disable  => disable_ch(16), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(16), --

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
      wr_data            => sense(15),
      o_data_ready => o_data_ready(15),
      rd_data            => block_data(15),
      o_bits_stored      => block_data_dim(15),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(15),--
      std_discr_disable  => disable_ch(15), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(15), --

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
      wr_data            => sense(14),
      o_data_ready => o_data_ready(14),
      rd_data            => block_data(14),
      o_bits_stored      => block_data_dim(14),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(14),--
      std_discr_disable  => disable_ch(14), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(14), --

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
      wr_data            => sense(13),
      o_data_ready => o_data_ready(13),
      rd_data            => block_data(13),
      o_bits_stored      => block_data_dim(13),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(13),--
      std_discr_disable  => disable_ch(13), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(13), --

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
      wr_data            => sense(12),
      o_data_ready => o_data_ready(12),
      rd_data            => block_data(12),
      o_bits_stored      => block_data_dim(12),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(12),--
      std_discr_disable  => disable_ch(12), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(12), --

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
      wr_data            => sense(11),
      o_data_ready => o_data_ready(11),
      rd_data            => block_data(11),
      o_bits_stored      => block_data_dim(11),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(11),--
      std_discr_disable  => disable_ch(11), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(11), --

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
      wr_data            => sense(10),
      o_data_ready => o_data_ready(10),
      rd_data            => block_data(10),
      o_bits_stored      => block_data_dim(10),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(10),--
      std_discr_disable  => disable_ch(10), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(10), --

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
      wr_data            => sense(9),
      o_data_ready => o_data_ready(9),
      rd_data            => block_data(9),
      o_bits_stored      => block_data_dim(9),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(9),--
      std_discr_disable  => disable_ch(9), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(9), --

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
      wr_data            => sense(8),
      o_data_ready => o_data_ready(8),
      rd_data            => block_data(8),
      o_bits_stored      => block_data_dim(8),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(8),--
      std_discr_disable  => disable_ch(8), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(8), --

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
      wr_data            => sense(7),
      o_data_ready => o_data_ready(7),
      rd_data            => block_data(7),
      o_bits_stored      => block_data_dim(7),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(7),--
      std_discr_disable  => disable_ch(7), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(7), --

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
      wr_data            => sense(6),
      o_data_ready => o_data_ready(6),
      rd_data            => block_data(6),
      o_bits_stored      => block_data_dim(6),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(6),--
      std_discr_disable  => disable_ch(6), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(6), --

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
      wr_data            => sense(5),
      o_data_ready => o_data_ready(5),
      rd_data            => block_data(5),
      o_bits_stored      => block_data_dim(5),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(5),--
      std_discr_disable  => disable_ch(5), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(5), --

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
      wr_data            => sense(4),
      o_data_ready => o_data_ready(4),
      rd_data            => block_data(4),
      o_bits_stored      => block_data_dim(4),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(4),--
      std_discr_disable  => disable_ch(4), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(4), --

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
      wr_data            => sense(3),
      o_data_ready => o_data_ready(3),
      rd_data            => block_data(3),
      o_bits_stored      => block_data_dim(3),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(3),--
      std_discr_disable  => disable_ch(3), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(3), --

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
      wr_data            => sense(2),
      o_data_ready => o_data_ready(2),
      rd_data            => block_data(2),
      o_bits_stored      => block_data_dim(2),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(2),--
      std_discr_disable  => disable_ch(2), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(2), --

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
      wr_data            => sense(1),
      o_data_ready => o_data_ready(1),
      rd_data            => block_data(1),
      o_bits_stored      => block_data_dim(1),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(1),--
      std_discr_disable  => disable_ch(1), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(1), --

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
      wr_data            => sense(0),
      o_data_ready => o_data_ready(0),
      rd_data            => block_data(0),
      o_bits_stored      => block_data_dim(0),
      std_discr_diag     => '0', --
      std_discr_o        => open,--
      set_config         => set_config(0),--
      std_discr_disable  => disable_ch(0), --
      std_discr_dir      => '0',--
      std_discr_sbit_en  => '0', --
      std_discr_ibit_en  => '0', --
      std_discr_sbit_alm => open, --
      std_discr_ibit_alm => open, --
      ch_unavailable     => ch_unavailable(0), --

      std_discr_label    => ch_label(0) --
    );

end architecture;
