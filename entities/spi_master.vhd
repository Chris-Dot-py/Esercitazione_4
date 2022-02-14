------------------------------------------------------------------------------------------
-- MODIFICHE DA FARE:
-- Il codice attualmente legge valori in ritardo di circa 90us.
-- sarebbe meglio leggere valori poco PRIMA del rising edge del clock da 10KHz
--
-- funzionamento base di std_discr_if:
-- soglie configurabili da 2V a 22V       [_]
-- frequenza di campionamento pari a 10KHz      [_]
-- std_discr_io riconfigurabile come ingresso/uscita     [_]

-- quando si configura l'holt, mando un impulso di avvio configurazione
-- seguito dal comando di settaggio dei sense banks psen
-- seguito dal comando del settaggio di isteresi e central value
------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_misc.all;
library std;
use std.textio.all;

library work;

------------------------------------------------------------------------------------------
-- this spi master is specific to HI-8435
------------------------------------------------------------------------------------------

-- OTTIMIZZAZIONE : mettere un UNICO ingressso da 8 byte
-- supponendo che prima dell'arrivo del segnale di configurazione
-- i byte da trasmettere via master sono gia pronti.
-- In due colpi di clock prelevo sia HI_threshold val e LO_threshold_val
-- al terzo mando il segnale di "set thresholds"
-- aggiungere un ingresso std_logic_vector che prenda convoglia tutti i segnali di comando
-- METTERE TUTTO POI IN UN RECORD!!!!
entity spi_master is
     generic(number_of_slaves : integer := 1);
     port (
          clock        : in  std_logic;
          reset        : in  std_logic;
          busy         : out std_logic;
          -- segnale di avvio per campionamento
          get_sample   : in  std_logic;
          slv_addr     : in  std_logic_vector(number_of_slaves-1 downto 0);
          --  command/configurations signals
          set_ctrl      : in std_logic;
          ctrl_reg     : in std_logic_vector(1 downto 0);
          set_psen : in std_logic;
          psen         : in std_logic_vector(3 downto 0);
          tm_data      : in std_logic_vector(3 downto 0);
          set_thresholds : in std_logic_vector(1 downto 0);
          -- siccome la risoluzione è di 0.5 raddoppio il range e poi divido per due il risultato
          HI_threshold : in integer range 6 to 44; -- max 22V min 3V
          LO_threshold : in integer range 4 to 42; -- max 21V min 2V
          -- 32 bit register as input for the 32 ch standard discrete IO
          sense        : out std_logic_vector(31 downto 0);
          -- spi bus
          sclk         : out std_logic;
          mosi         : out std_logic;
          miso         : in  std_logic;
          csn          : out std_logic_vector(number_of_slaves-1 downto 0)
     );
end entity spi_master;

architecture spi_master_arch of spi_master is
    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    -- mini ROM for operation codes
    type t_mini_ROM is array (0 to 14) of std_logic_vector(7 downto 0);
    constant c_op_codes : t_mini_ROM := ( 0 => x"02", 1  => x"04", 2  => x"3A",  3 => x"3C",
                                          4 => x"1E", 5  => x"82", 6  => x"84",  7 => x"BA",
                                          8 => x"BC", 9  => x"9E", 10 => x"90", 11 => x"92",
                                         12 => x"94", 13 => x"96", 14 => x"F8" );

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type states is (idle, send_op_code, configuation_mode, rd_from_slv, wr_to_slv);
    signal current_state : states;
    -- SPI COMMANDS
    signal spi_cmd : std_logic_vector(4 downto 0);

    --------------------------------------------------------------------------------------
    -- sostituire tutti questi registri con un UNICO registro da 8 byte.
    -- per ogni comando SPI me ne serve solo 1. Prendo quello di ingresso e lo salvo qui
    --------------------------------------------------------------------------------------
    -- registro valori
    signal r_ctrl_reg : std_logic_vector(7 downto 0);
    signal r_psen : std_logic_vector(7 downto 0);
    signal hyst_val : std_logic_vector(7 downto 0);
    signal center_val : std_logic_vector(7 downto 0);
    -- placeholder for serializer mosi
    signal op_code : std_logic_vector(7 downto 0);
    -- output wirings
    signal sense_w : std_logic_vector(31 downto 0);
    signal sclk_w  : std_logic;
    signal clk_internal  : std_logic;
    signal mosi_w  : std_logic;
    signal csn_w   : std_logic_vector(number_of_slaves-1 downto 0);
    -- base counter for internal clock @ 16.66..MHz
    signal cnt : std_logic_vector(1 downto 0);
    -- main timing counter for serial transmitted data
    signal timing_cnt_en : std_logic;
    signal timing_cnt : std_logic_vector(5 downto 0);
    -- value depends on the operation code
    signal term_cnt : integer range 0 to 63 := 42; -- 40 + 2 (for start and end margin)

begin
    --------------------------------------------------------------------------------------
    -- 100MHz clock processes
    --------------------------------------------------------------------------------------
    -- base counter for producing the 16.666...MHz spi slave clock
    p_sclk_counter : process(clock,reset)
    begin
        if reset = '0' then
            cnt <= (others => '0');
        elsif rising_edge(clock) then
            if cnt = 2 then
                cnt <= (others => '0');
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;

    sclk <= sclk_w;
    p_gen_sclk : process(clock, reset)
    begin
        if reset = '0' then
            sclk_w <= '0';
            sclk_w <= '0';
        elsif rising_edge(clock) then
            -- produces the internal clock used in this spi master
            if cnt = 2 then
                if clk_internal = '0' then
                    clk_internal <= '1';
                else
                    clk_internal <= '0';
                end if;
            end if;

            -- the internal clock is used as sclk
            if timing_cnt > 1 AND timing_cnt < term_cnt then
                if cnt = 2 then
                    if sclk_w = '0' then
                        sclk_w <= '1';
                    else
                        sclk_w <= '0';
                    end if;
                end if;
            else
                sclk_w <= '0';
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------------
    -- slow internal clock (16.666..MHz) processes
    --------------------------------------------------------------------------------------
    busy <= or_reduce(timing_cnt);  -- SPI is busy when sending data.
    -- process for the main timing counter when sending spi commands
    p_timing_counter : process(clk_internal, reset)
    begin
        if reset = '0' then
            timing_cnt <= (others => '0');
        elsif rising_edge(clk_internal) then
            if timing_cnt_en = '1' then -- enable is handled in the fsm
                if timing_cnt < term_cnt then
                    timing_cnt <= timing_cnt + 1;
                else
                    timing_cnt <= (others => '0');
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------------
    -- da sostituire con un unico registro DATA_BYTE.
    -- gli altri registri sono ridondanti
    --------------------------------------------------------------------------------------
    p_save_inputs : process(clk_internal, reset)
    begin
        if reset = '0' then
            r_psen <= (others => '0');
            r_ctrl_reg <= (others => '0');
        elsif rising_edge(clk_internal) then
            r_psen(3 downto 0) <= psen;
            r_ctrl_reg(1 downto 0) <= ctrl_reg;
        end if;
    end process;

    --------------------------------------------------------------------------------------
    -- fsm
    --------------------------------------------------------------------------------------
    sense <= sense_w; -- wiring
    mosi <= mosi_w; -- wiring
    -- spi cmd register
    spi_cmd(4) <= set_ctrl;
    spi_cmd(3) <= set_thresholds(1);
    spi_cmd(2) <= set_thresholds(0); -- eet_thresholds
    spi_cmd(1) <= set_psen;
    spi_cmd(0) <= get_sample;
    -- Hysteresis and center value
    hyst_val <= conv_std_logic_vector((HI_threshold - LO_threshold)/2, hyst_val'length);
    center_val <= conv_std_logic_vector((HI_threshold + LO_threshold)/2, center_val'length);
    p_fsm : process(clk_internal, reset)
    begin
        if reset = '0' then
            current_state <= idle;
            timing_cnt_en <= '0';
            sense_w <= (others => '0');
            op_code <= (others => '0');
            mosi_w <= '0';
        elsif rising_edge(clk_internal) then
            case( current_state ) is
                ----
                ---- decodificare il segnale che arriva
                when idle =>
                    -- se arriva un comando attivo il contatore
                    if or_reduce(spi_cmd) = '1' then        current_state <= send_op_code;
                        timing_cnt_en <= '1';
                    end if;

                    -- decodifica registro spi_cmd
                    case( spi_cmd ) is
                        when "00001" =>
                            op_code <= c_op_codes(14); -- x"F8"
                        when "00010" =>
                            op_code <= c_op_codes(1); -- x"04"
                        when "00100" =>
                            op_code <= c_op_codes(2); -- x"3A"
                        when "01000" =>
                            op_code <= c_op_codes(3); --x"3C"
                        when "10000" =>
                            op_code <= c_op_codes(0); --x"02"
                        when others =>
                            -- ogni bit del registro corrisponde ad un comando
                            -- se me ne arrivano due contemporaneamente è invalid
                            current_state <= idle;
                    end case;
                ----
                ----
                when send_op_code =>
                    -- serialize op_code
                    if timing_cnt > 0 AND timing_cnt < 9 then
                        mosi_w <= op_code(8 - conv_integer(timing_cnt));
                    end if;
                    -- in base all'op_code, la durata della comunicazione tra
                    -- master e slave varia
                    case( op_code ) is
                        when x"3A" | x"3C" | x"BA" | x"BC" =>
                            term_cnt <= 26; -- 24 + 2
                            if timing_cnt >= 9 then
                                if op_code(7) = '0' then           current_state <= wr_to_slv;
                                    case( op_code ) is
                                        when x"3A" | x"3C" =>
                                            mosi_w <= hyst_val(7);
                                        when others =>
                                            mosi_w <= '0';
                                    end case;
                                elsif op_code(7) = '1' then        current_state <= rd_from_slv;
                                    sense_w(0) <= miso;
                                end if;
                            end if;

                        when x"F8" =>
                            term_cnt <= 42; -- 40 + 2
                            if timing_cnt >= 9 then       current_state <= rd_from_slv;
                                sense_w(0) <= miso;
                            end if;

                        when others =>
                            term_cnt <= 18; -- 16 + 2
                            if timing_cnt >= 9 then
                                if op_code(7) = '0' then           current_state <= wr_to_slv;
                                    case( op_code ) is
                                        when x"04" =>
                                            mosi_w <= r_psen(7);
                                        when x"02" =>
                                            mosi_w <= r_ctrl_reg(7);
                                        when others =>
                                            mosi_w <= '0';
                                    end case;
                                elsif op_code(7) = '1' then        current_state <= rd_from_slv;
                                    sense_w(0) <= miso;
                                end if;
                            end if;
                    end case;
                ----
                ----
                when rd_from_slv =>
                    if timing_cnt < term_cnt then
                        sense_w(0) <= miso;
                        for i in 0 to 30 loop
                            sense_w(i+1) <= sense_w(i);
                        end loop;
                    elsif timing_cnt = term_cnt then           current_state <= idle;
                        timing_cnt_en <= '0';
                    end if;
                ----
                ---- add code for holt configuration
                when wr_to_slv =>
                    if timing_cnt < term_cnt-1 then
                        case( op_code ) is
                            when x"04" =>
                                mosi_w <= r_psen(16 - conv_integer(timing_cnt));
                            when x"3A" | x"3C" =>
                                if timing_cnt < term_cnt - 9 then
                                    mosi_w <= hyst_val(16 - conv_integer(timing_cnt));
                                else
                                    mosi_w <= center_val(24 - conv_integer(timing_cnt));
                                end if;
                            when x"02" =>
                                mosi_w <= r_ctrl_reg(16 - conv_integer(timing_cnt));
                            when others =>
                                mosi_w <= '0';
                        end case;
                    elsif timing_cnt = term_cnt then           current_state <= idle;
                        timing_cnt_en <= '0';
                    end if;
                ----
                ----
                when others =>
                    current_state <= idle;
            end case;

        end if;
    end process;

    --------------------------------------------------------------------------------------
    -- slave management
    --------------------------------------------------------------------------------------
    csn <= csn_w;
    one_slave : if (number_of_slaves = 1) generate
        csn_w(0) <= not or_reduce(timing_cnt) when slv_addr = "0" else
                    'Z';
    end generate one_slave;

    -- two_slaves : if (number_of_slaves = 2) generate
    -- end generate two_slaves;
    --
    -- three_slaves : if (number_of_slaves = 3) generate
    -- end generate three_slaves;
    --
    -- four_slaves : if (number_of_slaves = 4) generate
    -- end generate four_slaves;

end architecture;
