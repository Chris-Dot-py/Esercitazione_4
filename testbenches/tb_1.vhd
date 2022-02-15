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
      clock         : in  std_logic;
      reset         : in  std_logic;
      busy          : out std_logic;
      spi_cmd       : in  std_logic_vector(7 downto 0);
      rd_regs       : in  std_logic_vector(7 downto 0);
      data_byte_in  : in  std_logic_vector(7 downto 0);
      data_byte_out : out std_logic_vector(7 downto 0);
      slv_addr      : in  std_logic_vector(number_of_slaves-1 downto 0);
      sense         : out std_logic_vector(31 downto 0);
      sclk          : out std_logic;
      mosi          : out std_logic;
      miso          : in  std_logic;
      csn           : out std_logic_vector(number_of_slaves-1 downto 0)
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
    signal HI_threshold   : integer range 6 to 44 := 21;
    signal LO_threshold   : integer range 4 to 42 := 9;

    signal clock          : std_logic;
    signal reset          : std_logic;
    signal busy           : std_logic;
    signal spi_cmd        : std_logic_vector(7 downto 0);
    signal rd_regs        : std_logic_vector(7 downto 0);
    signal data_byte_in     : std_logic_vector(7 downto 0) := "00000000";
    signal data_byte_out     : std_logic_vector(7 downto 0);
    signal slv_addr       : std_logic_vector(c_number_of_slaves-1 downto 0):= "0";


    signal sense          : std_logic_vector(31 downto 0); -- to remove

    signal sclk           : std_logic;
    signal mosi           : std_logic;
    signal miso           : std_logic;
    signal csn            : std_logic_vector(c_number_of_slaves-1 downto 0);

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

begin
    --------------------------------------------------------------------------------------
    -- instantiations
    --------------------------------------------------------------------------------------
    spi_master_i : spi_master
    generic map (
        number_of_slaves => c_number_of_slaves
    )
    port map (
        clock         => clock,
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
        data_byte_out => data_byte_out,
        slv_addr      => slv_addr,
        sense         => sense,
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

    --------------------------------------------------------------------------------------
    -- suppongo che prima di mandare l'impulso del comando, ho gia i dati pronti da passare
    -- al master da serializzare
    --------------------------------------------------------------------------------------
    p_signals : process
    begin
        set_psen <= '0';
        rd_all_ssb <= '0';
        set_ctrl <= '0';
        data_byte_in <= "00000000";

        -- rd ssb 3
        wait for 400 ns;
        wait for 3 us;
        rd_r_SSB3 <= '1';
        wait until rising_edge(busy);
        rd_r_SSB3 <= '0';

        -- rd ssb 2
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_SSB2 <= '1';
        wait until rising_edge(busy);
        rd_r_SSB2 <= '0';

        -- rd ssb 1
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_SSB1 <= '1';
        wait until rising_edge(busy);
        rd_r_SSB1 <= '0';

        -- rd ssb 0
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_SSB0 <= '1';
        wait until rising_edge(busy);
        rd_r_SSB0 <= '0';

        -- get sample
        wait until falling_edge(busy);
        wait for 3 us;
        rd_all_ssb <= '1';
        wait until rising_edge(busy);
        rd_all_ssb <= '0';

        -- set ctrl
        wait until falling_edge(busy);
        wait for 3 us;
        data_byte_in <= "00000010";
        set_ctrl <= '1';
        wait until rising_edge(busy);
        set_ctrl <= '0';
        -- rd ctrl reg
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_ctrl <= '1';
        wait until rising_edge(busy);
        rd_r_ctrl <= '0';

        -- set psen
        wait until falling_edge(busy);
        wait for 3 us;
        data_byte_in <= "00001010";
        set_psen <= '1';
        wait until rising_edge(busy);
        set_psen <= '0';
        -- rd psen
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_psen <= '1';
        wait until rising_edge(busy);
        rd_r_psen <= '0';

        -- set tmdata
        wait until falling_edge(busy);
        wait for 3 us;
        data_byte_in <= x"AA";
        set_tmdata <= '1';
        wait until rising_edge(busy);
        set_tmdata <= '0';
        -- rd tmdata
        wait until falling_edge(busy);
        wait for 3 us;
        rd_tmdata <= '1';
        wait until rising_edge(busy);
        rd_tmdata <= '0';

        -- set gocenhys
        wait until falling_edge(busy);
        wait for 3 us;
        set_gocenhys <= '1';
        data_byte_in <= conv_std_logic_vector(HI_threshold, data_byte_in'length);
        wait for 60 ns; -- 60 ns
        wait until rising_edge(clock);
        set_gocenhys <= '0';
        data_byte_in <= conv_std_logic_vector(LO_threshold, data_byte_in'length);
        -- rd gocenhys
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_gocenhys <= '1';
        wait until rising_edge(busy);
        rd_r_gocenhys <= '0';

        -- set socenhys
        wait until falling_edge(busy);
        wait for 3 us;
        set_socenhys <= '1';
        data_byte_in <= conv_std_logic_vector(24, data_byte_in'length);
        wait for 60 ns; -- 60 ns
        wait until rising_edge(clock);
        set_socenhys <= '0';
        data_byte_in <= conv_std_logic_vector(12, data_byte_in'length);
        -- rd socenhys
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_socenhys <= '1';
        wait until rising_edge(busy);
        rd_r_socenhys <= '0';

        -- set ctrl
        wait until falling_edge(busy);
        wait for 3 us;
        data_byte_in <= "00000000";
        set_ctrl <= '1';
        wait until rising_edge(busy);
        set_ctrl <= '0';
        -- rd ctrl reg
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_ctrl <= '1';
        wait until rising_edge(busy);
        rd_r_ctrl <= '0';

        -- set psen
        wait until falling_edge(busy);
        wait for 3 us;
        data_byte_in <= "00001010";
        set_psen <= '1';
        wait until rising_edge(busy);
        set_psen <= '0';
        -- rd psen
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_psen <= '1';
        wait until rising_edge(busy);
        rd_r_psen <= '0';

        -- set tmdata
        wait until falling_edge(busy);
        wait for 3 us;
        data_byte_in <= x"AA";
        set_tmdata <= '1';
        wait until rising_edge(busy);
        set_tmdata <= '0';
        -- rd tmdata
        wait until falling_edge(busy);
        wait for 3 us;
        rd_tmdata <= '1';
        wait until rising_edge(busy);
        rd_tmdata <= '0';

        -- set gocenhys
        wait until falling_edge(busy);
        wait for 3 us;
        set_gocenhys <= '1';
        data_byte_in <= conv_std_logic_vector(HI_threshold, data_byte_in'length);
        wait for 60 ns; -- 60 ns
        wait until rising_edge(clock);
        set_gocenhys <= '0';
        data_byte_in <= conv_std_logic_vector(LO_threshold, data_byte_in'length);
        -- rd gocenhys
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_gocenhys <= '1';
        wait until rising_edge(busy);
        rd_r_gocenhys <= '0';

        -- set socenhys
        wait until falling_edge(busy);
        wait for 3 us;
        set_socenhys <= '1';
        data_byte_in <= conv_std_logic_vector(24, data_byte_in'length);
        wait for 60 ns; -- 60 ns
        wait until rising_edge(clock);
        set_socenhys <= '0';
        data_byte_in <= conv_std_logic_vector(12, data_byte_in'length);
        -- rd socenhys
        wait until falling_edge(busy);
        wait for 3 us;
        rd_r_socenhys <= '1';
        wait until rising_edge(busy);
        rd_r_socenhys <= '0';

        wait;
    end process;

    p_gen_rst : process
    begin
        reset <= '0';
        wait for 2 ns;
        reset <= '1';
        wait;
    end process;

end architecture;
