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
      --  command/configurations signals
      set_threshold : in std_logic;
      -- set_inout    : in std_logic; -- '0' for input '1' for output
      get_sample   : in  std_logic;
      HI_threshold : in  integer range 1 to 10;
      LO_threshold : in  integer range 1 to 10;
      -- trigger_type : t_trigger_type; --  {edge, level}
      -- level_threshold_samples : integer range 1 to 500;
      slv_addr     : in  std_logic_vector(number_of_slaves-1 downto 0);
      -- 32 bit register as input for the 32 ch standard discrete IO
      sense        : out std_logic_vector(31 downto 0);
      -- spi bus
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
    signal clock_w         : std_logic;
    signal reset_w         : std_logic;
    signal busy_w          : std_logic;
    signal set_threshold_w : std_logic;
    signal get_sample_w    : std_logic;
    signal HI_threshold_w  : integer range 1 to 10;
    signal LO_threshold_w  : integer range 1 to 10;
    signal slv_addr_w      : std_logic_vector(c_number_of_slaves-1 downto 0) := "0";
    signal sense_w         : std_logic_vector(31 downto 0);
    signal sclk_w          : std_logic;
    signal mosi_w          : std_logic;
    signal miso_w          : std_logic;
    signal csn_w           : std_logic_vector(c_number_of_slaves-1 downto 0);

begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
         spi_master_i : spi_master
      generic map (
        number_of_slaves => c_number_of_slaves
      )
      port map (
        clock         => clock_w,
        reset         => reset_w,
        busy          => busy_w,
        set_threshold => set_threshold_w,
        get_sample    => get_sample_w,
        HI_threshold  => HI_threshold_w,
        LO_threshold  => LO_threshold_w,
        slv_addr      => slv_addr_w,
        sense         => sense_w,
        sclk          => sclk_w,
        mosi          => mosi_w,
        miso          => miso_w,
        csn           => csn_w
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

    p_gen_rst : process
    begin
        reset_w <= '0';
        wait for 2 ns;
        reset_w <= '1';
        wait;
    end process;

end architecture;
