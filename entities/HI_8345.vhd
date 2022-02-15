library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;

------------------------------------------------------------------------------------------
-- add registers for the sanitization process
------------------------------------------------------------------------------------------
entity HI_8345 is
    port(
        sclk : in std_logic;
        mosi : in std_logic;
        miso : out std_logic;
        csn : in std_logic
    );
end entity HI_8345;

architecture HI_8345_arch of HI_8345 is
    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type t_states is (idle, rd_op_code, software_reset, wr_data, rd_data);
    signal current_state : t_states := idle;

    -- registers
    signal r_ctrl          : std_logic_vector(7 downto 0) := (others => '0');
        signal srst        : std_logic := r_ctrl(1);
        signal test        : std_logic := r_ctrl(0);
    signal r_psen          : std_logic_vector(7 downto 0) := (others => '0');
    signal r_tmdata        : std_logic_vector(7 downto 0) := (others => '0');
    signal r_gohys         : std_logic_vector(7 downto 0) := (others => '0');
    signal r_gocval        : std_logic_vector(7 downto 0) := (others => '0');
    signal r_sohys         : std_logic_vector(7 downto 0) := (others => '0');
    signal r_socval        : std_logic_vector(7 downto 0) := (others => '0');
    signal r_SSB_0         : std_logic_vector(7 downto 0) := x"DD";
    signal r_SSB_1         : std_logic_vector(7 downto 0) := x"CC";
    signal r_SSB_2         : std_logic_vector(7 downto 0) := x"BB";
    signal r_SSB_3         : std_logic_vector(7 downto 0) := X"AA";
    signal c_sense_vals : std_logic_vector(31 downto 0) := r_SSB_3 & r_SSB_2 & r_SSB_1 & r_SSB_0;

    signal op_code : std_logic_vector(7 downto 0) := (others => '0');
    signal data_byte_1 : std_logic_vector(7 downto 0) := (others => '0');
    signal data_byte_0 : std_logic_vector(7 downto 0) := (others => '0');

    signal cnt : integer range 0 to 63 := 0;
    signal term_cnt : integer range 0 to 63 := 40;

    signal shift_register : std_logic_vector(7 downto 0) := (others => '0');
    signal miso_w : std_logic := '0';

begin
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_acquire : process(sclk)
    begin
        if rising_edge(sclk) then
            if csn = '0' then
                -- shift register
                shift_register(0) <= mosi;
                for i in 0 to 6 loop
                    shift_register(i + 1) <= shift_register(i);
                end loop;
            else
                shift_register <= (others => '0');
            end if;
        end if;
    end process;

    --------------------------------------------------------------------------------------
    -- fsm
    --------------------------------------------------------------------------------------
    miso <= miso_w;
    p_fsm : process(sclk,csn)
    begin
        if csn = '1' then
            current_state <= idle;
            miso_w <= 'Z';
            cnt <= 0;
        elsif falling_edge(sclk) then
            --fsm
            case( current_state ) is
                when idle =>
                    current_state <= rd_op_code;
                    miso_w <= 'Z';
                when rd_op_code =>
                    if  cnt = 7 then
                        -- save op_cpode
                        op_code <= shift_register;
                        -- decode op_code
                        case( shift_register ) is
                            when x"3A" | x"3C" | x"BA" | x"BC" =>
                                term_cnt <= 24;
                            when x"F8" =>
                                term_cnt <= 40;
                            when others =>
                                term_cnt <= 16;
                        end case;
                        -- read or write
                        if shift_register(7) = '1' then         current_state <= rd_data;
                            case( shift_register ) is
                                when x"82" =>
                                    miso_w <= r_ctrl(7);
                                when x"84" =>
                                    miso_w <= r_psen(7);
                                when x"BA" =>
                                    miso_w <= r_gohys(7);
                                when x"BC" =>
                                    miso_w <= r_sohys(7);
                                when x"9E" =>
                                    miso_w <= r_tmdata(7);
                                when x"90" =>
                                    miso_w <= r_SSB_0(7);
                                when x"92" =>
                                    miso_w <= r_SSB_1(7);
                                when x"94" =>
                                    miso_w <= r_SSB_2(7);
                                when x"96" =>
                                    miso_w <= r_SSB_3(7);
                                when x"F8" =>
                                    miso_w <= c_sense_vals(31);
                                when others =>
                                    current_state <= idle;
                            end case;
                        elsif shift_register(7) = '0' then      current_state <= wr_data;
                        end if;
                    end if;

                when rd_data =>
                    if cnt < term_cnt - 1 then
                        case( op_code ) is
                            when x"82" =>
                                miso_w <= r_ctrl(14 - cnt);
                            when x"84" =>
                                miso_w <= r_psen(14 - cnt);
                            when x"BA" =>
                                if cnt < 15 then
                                    miso_w <= r_gohys(14 - cnt);
                                else
                                    miso_w <= r_gocval(22 - cnt);
                                end if;
                            when x"BC" =>
                                if cnt < 15 then
                                    miso_w <= r_sohys(14 - cnt);
                                else
                                    miso_w <= r_socval(22 - cnt);
                                end if;
                            when x"9E" =>
                                miso_w <= r_tmdata(14 - cnt);
                            when x"90" =>
                                miso_w <= r_SSB_0(14 - cnt);
                            when x"92" =>
                                miso_w <= r_SSB_1(14 - cnt);
                            when x"94" =>
                                miso_w <= r_SSB_2(14 - cnt);
                            when x"96" =>
                                miso_w <= r_SSB_3(14 - cnt);
                            when x"F8" =>
                                miso_w <= c_sense_vals(38 - cnt);
                            when others =>
                                current_state <= idle;
                        end case;
                    elsif cnt = term_cnt-1 then                  current_state <= idle;
                        miso_w <= 'Z';
                    end if;

                when wr_data =>
                    if cnt = 15 then
                            -- if r_ctrl(1) = '1' then
                            --     r_ctrl(0) <= '0';
                            --     r_psen <= (others => '0');
                            --     r_tmdata <= (others => '0');
                            --     r_gohys <= (others => '0');
                            --     r_gocval <= (others => '0');
                            --     r_sohys <= (others => '0');
                            --     r_socval <= (others => '0');
                            -- end if;
                                case( op_code ) is
                                    when x"02" =>
                                        r_ctrl <= shift_register;
                                    when x"04" =>
                                        r_psen <= shift_register;
                                    when x"3A" =>
                                        r_gohys <= shift_register;
                                    when x"3C" =>
                                        r_sohys <= shift_register;
                                    when x"1E" =>
                                        r_tmdata <= shift_register;
                                    when others =>
                                        current_state <= idle;
                                end case;
                    elsif cnt = term_cnt-1 then             current_state <= idle;
                        case( op_code ) is
                            when x"3A" =>
                                r_gocval <= shift_register;
                            when x"3C" =>
                                r_socval <= shift_register;
                            when others =>
                                current_state <= idle;
                        end case;
                    end if;

                when others =>
                    miso_w <= 'Z';
                    current_state <= idle;
            end case;

            -- software reset
            if r_ctrl(1) = '1' then
                r_ctrl(0) <= '0';
                r_psen <= (others => '0');
                r_tmdata <= (others => '0');
                r_gohys <= (others => '0');
                r_gocval <= (others => '0');
                r_sohys <= (others => '0');
                r_socval <= (others => '0');
            end if;

            -- counter
            if cnt < term_cnt then
                cnt <= cnt + 1;
            else
                cnt <= 0;
            end if;

        end if;
    end process;

end architecture;
