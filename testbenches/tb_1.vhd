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
      set_config   : in  std_logic;
      ctrl_reg     : in  std_logic_vector(1 downto 0);
      psen         : in  std_logic_vector(3 downto 0);
      tm_data      : in  std_logic_vector(3 downto 0);
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
    signal set_config_w   : std_logic;
    signal ctrl_reg_w     : std_logic_vector(1 downto 0);
    signal psen_w         : std_logic_vector(3 downto 0) := "1010";
    signal tm_data_w      : std_logic_vector(3 downto 0);
    signal HI_threshold_w   : integer range 1 to 10;
    signal LO_threshold_w   : integer range 1 to 10;
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
      set_config   => set_config_w,
      ctrl_reg     => ctrl_reg_w,
      psen         => psen_w,
      tm_data      => tm_data_w,
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

    p_gen_clk_10KHz : process
    begin
        get_sample_w <= '0';
        wait for 5 us;
        get_sample_w <= '1';
        wait for 5 us;
    end process;

    p_set_config : process
    begin
        set_config_w <= '0';
        wait until falling_edge(busy_w);
        set_config_w <= '1';
        wait for 61 ns;
        set_config_w <= '0';
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
