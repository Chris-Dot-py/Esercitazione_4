library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;

entity tb_4 is
end entity tb_4;

architecture tb_4_arch of tb_4 is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------
    component std_discr_if
    port (
      clock            : in  std_logic;
      reset            : in  std_logic;
      sclk             : out std_logic;
      mosi             : out std_logic;
      miso             : in  std_logic;
      csn              : out std_logic;
      send_snf_data    : in  std_logic;
      receive_snf_data : out std_logic;
      packet_out       : out std_logic;
      config_mode      : in  std_logic;
      config_done      : out std_logic;
      set_config       : in  std_logic_vector(31 downto 0);
      disable_ch       : in  std_logic_vector(31 downto 0);
      psen             : in  std_logic_vector(3 downto 0);
      HI_threshold     : in  std_logic_vector(7 downto 0);
      LO_threshold     : in  std_logic_vector(7 downto 0)
    );
    end component std_discr_if;

    component HI_8345
    port (
      sclk : in  std_logic;
      mosi : in  std_logic;
      miso : out std_logic;
      csn  : in  std_logic
    );
    end component HI_8345;

    component tb_output_analysis
    port (
      clock            : in  std_logic;
      reset            : in  std_logic;
      receive_snf_data : in  std_logic;
      packet_in        : in  std_logic
    );
    end component tb_output_analysis;

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    signal clock            : std_logic;
    signal reset            : std_logic;
    signal sclk             : std_logic;
    signal mosi             : std_logic;
    signal miso             : std_logic;
    signal csn              : std_logic;
    signal send_snf_data    : std_logic; -- to simulate
    signal receive_snf_data : std_logic;
    signal packet_out       : std_logic;
    signal config_mode      : std_logic; -- to simulate
    signal config_done      : std_logic;
    signal disable_ch       : std_logic_vector(31 downto 0) := (others => '0');
    signal set_config       : std_logic_vector(31 downto 0) := (others => '1');
    signal psen             : std_logic_vector(3 downto 0) := x"A";
    signal HI_threshold     : std_logic_vector(7 downto 0) := x"15";
    signal LO_threshold     : std_logic_vector(7 downto 0) := x"09";

begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    std_discr_if_i : std_discr_if
    port map (
      clock            => clock, --
      reset            => reset, --
      sclk             => sclk, --
      mosi             => mosi, --
      miso             => miso, --
      csn              => csn, --
      send_snf_data    => send_snf_data,
      receive_snf_data => receive_snf_data,
      packet_out       => packet_out,
      config_mode      => config_mode,
      config_done      => config_done,
      set_config       => set_config,
      -- disable_ch       => (31 => '0', 0 => '0', 15 => '0', others => '1'),
        disable_ch       => disable_ch,
      psen             => psen,
      HI_threshold     => HI_threshold,
      LO_threshold     => LO_threshold
    );

    HI_8345_i : HI_8345
    port map (
    sclk => sclk, --
    mosi => mosi, --
    miso => miso, --
    csn  => csn --
    );

    tb_output_analysis_i : tb_output_analysis
    port map (
      clock            => clock, --
      reset            => reset, --
      receive_snf_data => receive_snf_data,
      packet_in        => packet_out
    );

    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_clock : process
    begin
        clock <= '0';
        wait for 5 ns;
        clock <= '1';
        wait for 5 ns;
    end process;

    p_reset : process
    begin
        reset <= '0';
        wait for 2 ns;
        reset <= '1';
        wait;
    end process;

    p_stimuli : process
    begin
        send_snf_data <= '0';
        config_mode <= '0';

        wait for 100 ns;
        config_mode <= '1';
        set_config <= (others => '1');
        disable_ch <= (others => '0');
        wait until rising_edge(config_done);
        config_mode <= '0';
        wait for 60 us;

        send_snf_data <= '1';
        wait for 100 ns;
        send_snf_data <= '0';
        wait for 54 us;

        send_snf_data <= '1';
        wait for 100 ns;
        send_snf_data <= '0';
        wait for 54 us;

        send_snf_data <= '1';
        wait for 100 ns;
        send_snf_data <= '0';

        wait;
    end process;

end architecture;
