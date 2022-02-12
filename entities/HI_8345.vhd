library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;

library work;

entity HI_8345 is
    port(
        sclk : in std_logic;
        mosi : in std_logic;
        miso : out std_logic;
        csn : in std_logic_vector(0 downto 0)
    );
end entity HI_8345;

architecture HI_8345_arch of HI_8345 is
    --------------------------------------------------------------------------------------
    -- component declarations
    --------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------
    constant c_sense_vals : std_logic_vector(31 downto 0) := x"AA" & x"BB" & x"CC" & x"DD";

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type t_states is (idle, rd_op_code, wr_data, rd_sense_vals);
    signal current_state : t_states := idle;

    signal op_code : std_logic_vector(7 downto 0) := (others => '0');
    signal data_byte_1 : std_logic_vector(7 downto 0) := (others => '0');
    signal data_byte_0 : std_logic_vector(7 downto 0) := (others => '0');

    signal cnt : integer range 0 to 63 := 0;
    signal term_cnt : integer range 0 to 63 := 40;
    signal tmp : integer range 0 to 63 := 0;

    signal shift_register : std_logic_vector(7 downto 0) := (others => '0');
    signal miso_w : std_logic := '0';
begin

    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_acquire : process(sclk)
    begin
        if rising_edge(sclk) then
            if csn(0) = '0' then
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
    p_fsm : process(sclk)
    begin
        if falling_edge(sclk) then
            --fsm
            case( current_state ) is
                when idle =>   current_state <= rd_op_code;
                    cnt <= 0;

                when rd_op_code =>
                    if  cnt = 7 then
                        -- save op_cpode
                        op_code <= shift_register;
                        -- decode oo_code
                        case( shift_register ) is
                            when x"3A" | x"3C" | x"BA" | x"BC" =>
                                term_cnt <= 24;

                            when x"F8" =>
                                term_cnt <= 40;

                            when others =>
                                term_cnt <= 16;
                        end case;
                        -- read or write
                        if shift_register(7) = '1' then         current_state <= rd_sense_vals;
                            miso_w <= c_sense_vals(31);
                        elsif shift_register(7) = '0' then      current_state <= wr_data;
                            miso_w <= c_sense_vals(31);
                        end if;
                    end if;

                when rd_sense_vals =>
                    if cnt < term_cnt-1 then
                        miso_w <= c_sense_vals(38 - cnt);
                    elsif cnt = term_cnt then                  current_state <= idle;
                    end if;

                when wr_data =>
                    if cnt = 14  then
                        data_byte_1 <= shift_register;
                    elsif cnt = term_cnt then                  current_state <= idle;
                        data_byte_0 <= shift_register;
                    end if;

                when others =>
                    current_state <= idle;
            end case;

            -- counter
            if cnt < term_cnt then
                cnt <= cnt + 1;
            else
                cnt <= 0;
            end if;

        end if;
    end process;

end architecture;
