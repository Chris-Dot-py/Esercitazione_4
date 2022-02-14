library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;

entity tb_1 is
end entity tb_1;

architecture tb_1_arch of tb_1 is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------
    component spi_master
    generic (
      number_of_slaves : integer := 1
    );
    port (
      clock        : in  std_logic;
      reset        : in  std_logic;
      busy         : out std_logic;
      set_psen   : in  std_logic;
      set_ctrl      : in std_logic;
      ctrl_reg     : in  std_logic_vector(1 downto 0);
      psen         : in  std_logic_vector(3 downto 0);
      tm_data      : in  std_logic_vector(3 downto 0);
      set_thresholds : in std_logic_vector(1 downto 0);
      HI_threshold : in integer range 1 to 10;
      LO_threshold : in integer range 1 to 10;
      get_sample   : in  std_logic;
      slv_addr     : in  std_logic_vector(number_of_slaves-1 downto 0);
      sense        : out std_logic_vector(31 downto 0);
      sclk         : out std_logic;
      mosi         : out std_logic;
      miso         : in  std_logic;
      csn          : out std_logic_vector(number_of_slaves-1 downto 0)
    );
    end component spi_master;


    component HI_8345
    port (
      sclk : in  std_logic;
      mosi : in  std_logic;
      miso : out std_logic;
      csn  : in  std_logic_vector
    );
    end component HI_8345;

    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    constant c_number_of_slaves : integer range 0 to 3 := 1;

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    signal clock_w        : std_logic;
    signal reset_w        : std_logic;
    signal busy_w         : std_logic;
    signal set_psen_W   : std_logic;
    signal set_ctrl_w     : std_logic := '0';
    signal ctrl_reg_w     : std_logic_vector(1 downto 0) := "10";
    signal psen_w         : std_logic_vector(3 downto 0) := "1010";
    signal tm_data_w      : std_logic_vector(3 downto 0);
    signal set_thresholds_w : std_logic_vector(1 downto 0) := "00";
    signal HI_threshold_w   : integer range 6 to 44 := 21;
    signal LO_threshold_w   : integer range 4 to 42 := 9;
    signal get_sample_w   : std_logic;
    signal slv_addr_w     : std_logic_vector(c_number_of_slaves-1 downto 0) := "0";
    signal sense_w        : std_logic_vector(31 downto 0);
    signal sclk_w         : std_logic;
    signal mosi_w         : std_logic;
    signal miso_w         : std_logic;
    signal csn_w          : std_logic_vector(c_number_of_slaves-1 downto 0);


begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    spi_master_i : spi_master
    generic map (
      number_of_slaves => c_number_of_slaves
    )
    port map (
      clock        => clock_w,
      reset        => reset_w,
      busy         => busy_w,
      set_psen   => set_psen_w,
      set_ctrl => set_ctrl_w,
      ctrl_reg     => ctrl_reg_w,
      psen         => psen_w,
      tm_data      => tm_data_w,
      set_thresholds => set_thresholds_w,
      HI_threshold => HI_threshold_w,
      LO_threshold => LO_threshold_w,
      get_sample   => get_sample_w,
      slv_addr     => slv_addr_w,
      sense        => sense_w,
      sclk         => sclk_w,
      mosi         => mosi_w,
      miso         => miso_w,
      csn          => csn_w
    );


    HI_8345_i : HI_8345
    port map (
      sclk => sclk_w,
      mosi => mosi_w,
      miso => miso_w,
      csn  => csn_w
    );

    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_gen_clk_100MHz : process
    begin
        clock_w <= '0';
        wait for 5 ns;
        clock_w <= '1';
        wait for 5 ns;
    end process;

    --------------------------------------------------------------------------------------
    -- suppongo che prima di mandare l'impulso del comando, ho gia i dati pronti da passare
    -- al master da serializzare
    --------------------------------------------------------------------------------------
    p_signals : process
    begin
        set_psen_W <= '0';
        get_sample_w <= '0';
        set_ctrl_w <= '0';

        -- get sample
        wait for 400 ns;
        get_sample_w <= '1';
        wait until rising_edge(busy_w);
        get_sample_w <= '0';
        -- set psen
        wait until falling_edge(busy_w);
        wait for 3 us;
        set_psen_W <= '1';
        wait until rising_edge(busy_w);
        set_psen_W <= '0';
        -- set thresholds
        wait until falling_edge(busy_w);
        wait for 3 us;
        set_thresholds_w <= "01";
        wait until rising_edge(busy_w);
        set_thresholds_w <= "00";
        -- set thresholds
        wait until falling_edge(busy_w);
        wait for 3 us;
        set_thresholds_w <= "10";
        wait until rising_edge(busy_w);
        set_thresholds_w <= "00";
        -- set ctrl
        wait until falling_edge(busy_w);
        wait for 3 us;
        set_ctrl_w <= '1';
        wait until rising_edge(busy_w);
        set_ctrl_w <= '0';
        wait;
    end process;

    p_gen_rst : process
    begin
        reset_w <= '0';
        wait for 2 ns;
        reset_w <= '1';
        wait;
    end process;

end architecture;
