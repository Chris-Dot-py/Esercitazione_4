------------------------------------------------------------------------------------------
-- this spi master is specific to HI-8435
-- NOTE: between "spi_cmd" and "rd_regs" ONLY ONE can be active each time.
--
-- PORTARE FUORI DIVISORE CLOCK
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

entity spi_master is
    generic(number_of_slaves : integer := 1);
    port (
        clock        : in  std_logic;
        reset        : in  std_logic;
        busy         : out std_logic;
        spi_cmd      : in std_logic_vector(7 downto 0); -- registro per comandi
        rd_regs      : in std_logic_vector(7 downto 0); -- registro per comandi di lettura
        data_byte_in : in std_logic_vector(7 downto 0); -- registro per dati da trasmettere
        slv_addr     : in  std_logic_vector(number_of_slaves-1 downto 0); -- indirizzo slave
        sense        : out std_logic_vector(31 downto 0);   -- da sistemare -> data_byte_out
        data_ready   : out std_logic;
        -- spi bus
        sclk         : out std_logic;
        mosi         : out std_logic;
        miso         : in  std_logic;
        csn          : out std_logic;

        -- temporary: to be revised
        clock_16MHz : out std_logic
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
    type states is (idle, send_op_code, set_cenhys, rd_from_slv, wr_to_slv);
    signal current_state : states;
    -- registro placeholder per calcolo cenhys
    signal r_data_byte_1 : std_logic_vector(7 downto 0);
    signal r_data_byte_0 : std_logic_vector(7 downto 0);
    signal r_hyst_val : std_logic_vector(7 downto 0);
    signal r_center_val : std_logic_vector(7 downto 0);
    -- placeholder op_code
    signal op_code : std_logic_vector(7 downto 0);
    -- base counter for internal clock @ 16.66..MHz
    signal cnt : std_logic_vector(1 downto 0);
    signal clk_internal  : std_logic;
    -- main timing counter for serial transmitted data
    signal timing_cnt_en : std_logic;
    signal timing_cnt : std_logic_vector(5 downto 0);
    signal term_cnt : integer range 0 to 63 := 42; -- 40 + 2
    -- output wirings
    signal sclk_w  : std_logic;
    signal mosi_w  : std_logic;
    signal csn_w   : std_logic_vector(number_of_slaves-1 downto 0);

    signal sense_w : std_logic_vector(31 downto 0);
    signal data_ready_w : std_logic;

begin
    --------------------------------------------------------------------------------------
    -- 100MHz clock processes
    --------------------------------------------------------------------------------------
    -- base counter for producing the 16.666...MHz spi slave clock
    clock_16MHz <= clk_internal;
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
    data_ready <= data_ready_w;
    p_timing_counter : process(clk_internal, reset)
    begin
        if reset = '0' then
            timing_cnt <= (others => '0');
        elsif rising_edge(clk_internal) then
            if timing_cnt_en = '1' then -- enable is handled in the fsm
                if timing_cnt < term_cnt then
                    timing_cnt <= timing_cnt + 1;

                    data_ready_w <= '0';
                else
                    if op_code = x"F8" then
                        data_ready_w <= '1';
                    end if;
                    timing_cnt <= (others => '0');
                end if;
            else
                data_ready_w <= '0';
                timing_cnt <= (others => '0');
            end if;
        end if;
    end process;

    -- active low chip select
    csn <= not or_reduce(timing_cnt) when slv_addr = "0" else
                    'Z';


    --------------------------------------------------------------------------------------
    -- fsm
    --------------------------------------------------------------------------------------

    sense <= sense_w; -- wiring
    mosi <= mosi_w;
    p_fsm : process(clk_internal, reset)
    begin
        if reset = '0' then
            current_state <= idle;
            timing_cnt_en <= '0';
            op_code <= (others => '0');
            r_data_byte_1 <= (others => '0');
            r_data_byte_0 <= (others => '0');
            mosi_w <= '0';


            sense_w <= (others => '0');
        elsif rising_edge(clk_internal) then
            case( current_state ) is
                --======
                when idle =>
                --======
                    -- se arriva un comando attivo il contatore
                    if or_reduce(spi_cmd) = '1' then        current_state <= send_op_code;
                        timing_cnt_en <= '1';
                        -- decodifica registro spi_cmd
                        case( spi_cmd ) is
                            when "10000000" =>
                                op_code <= c_op_codes(0); -- x"02"
                            when "01000000" =>
                                op_code <= c_op_codes(1); -- x"04"
                            when "00100000" =>
                                op_code <= c_op_codes(2); -- x"3A"
                                r_data_byte_1 <= data_byte_in;
                            when "00010000" =>
                                op_code <= c_op_codes(3); --x"3C"
                                r_data_byte_1 <= data_byte_in;
                            when "00001000" =>
                                op_code <= c_op_codes(4); --x"1E"
                            when "00000100" =>
                                op_code <= c_op_codes(9); --x"9E"
                            when "00000010" =>
                                op_code <= c_op_codes(14); --x"F8"
                            when others =>
                                -- ogni bit del registro corrisponde ad un comando
                                -- se me ne arrivano due contemporaneamente è invalid
                                current_state <= idle;
                        end case;
                    elsif or_reduce(rd_regs) = '1' then     current_state <= send_op_code;
                        timing_cnt_en <= '1';
                        case( rd_regs ) is
                            when "10000000" =>
                                op_code <= c_op_codes(5); -- x"82"
                            when "01000000" =>
                                op_code <= c_op_codes(6); -- x"84"
                            when "00100000" =>
                                op_code <= c_op_codes(7); -- x"BA"
                                r_data_byte_1 <= data_byte_in;
                            when "00010000" =>
                                op_code <= c_op_codes(8); --x"BC"
                                r_data_byte_1 <= data_byte_in;
                            when "00001000" =>
                                op_code <= c_op_codes(10); --x"90"
                            when "00000100" =>
                                op_code <= c_op_codes(11); --x"92"
                            when "00000010" =>
                                op_code <= c_op_codes(12); --x"94"
                            when "00000001" =>
                                op_code <= c_op_codes(13); --x"96"
                            when others =>
                                -- ogni bit del registro corrisponde ad un comando
                                -- se me ne arrivano due contemporaneamente è invalid
                                current_state <= idle;
                        end case;
                    end if;

                --======
                when send_op_code =>
                --======
                    -- calculate center val and hysteresis
                    if op_code = x"3A" OR op_code = x"3C" then
                        r_data_byte_0 <= data_byte_in;
                        r_hyst_val <= conv_std_logic_vector((conv_integer(r_data_byte_1 - r_data_byte_0))/2, r_hyst_val'length);
                        r_center_val <= conv_std_logic_vector((conv_integer(r_data_byte_1 + r_data_byte_0))/2, r_center_val'length);
                    end if;
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
                                            mosi_w <= r_hyst_val(7);
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
                                        when x"04" | x"02" | x"1E" =>
                                            mosi_w <= data_byte_in(7);
                                        when x"3A" | x"3C" =>
                                            mosi_w <= r_hyst_val(7);
                                        when others =>
                                            mosi_w <= '0';
                                    end case;
                                elsif op_code(7) = '1' then        current_state <= rd_from_slv;


                                    sense_w(0) <= miso;
                                end if;
                            end if;
                    end case;

                --======
                when rd_from_slv =>
                --======
                    if timing_cnt < term_cnt then
                        -- shift register
                        sense_w(0) <= miso;
                        for i in 0 to 30 loop
                            sense_w(i+1) <= sense_w(i);
                        end loop;
                    elsif timing_cnt = term_cnt then           current_state <= idle;
                        timing_cnt_en <= '0';
                    end if;

                --======
                when wr_to_slv =>
                --======
                    if timing_cnt < term_cnt-1 then
                        -- serialize to mosi
                        case( op_code ) is
                            when x"04" | x"02" | x"1E" =>
                                mosi_w <= data_byte_in(16 - conv_integer(timing_cnt));
                            when x"3A" | x"3C" =>
                                if timing_cnt < term_cnt - 9 then
                                    mosi_w <= r_hyst_val(16 - conv_integer(timing_cnt));
                                else
                                    mosi_w <= r_center_val(24 - conv_integer(timing_cnt));
                                end if;
                            when others =>
                                mosi_w <= '0';
                        end case;
                    elsif timing_cnt = term_cnt then           current_state <= idle;
                        timing_cnt_en <= '0';
                    end if;

                --======
                when others =>
                --======
                    current_state <= idle;
            end case;

        end if;
    end process;

end architecture;
