library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
library std;
use std.textio.all;
library work;

entity tb_output_analysis is
    port(
        clock : in std_logic;
        reset : in std_logic;

        receive_snf_data : in std_logic;
        packet_in : in std_logic
    );
end entity tb_output_analysis;

architecture tb_output_analysis_arch of tb_output_analysis is

    --------------------------------------------------------------------------------------
    -- constants
    --------------------------------------------------------------------------------------

    --------------------------------------------------------------------------------------
    -- signals
    --------------------------------------------------------------------------------------
    type t_states is (idle, rd_total_len, rd_data_blocks);
    signal current_state : t_states;

    signal total_len : std_logic_vector(15 downto 0);
    signal ch_label : std_logic_vector(15 downto 0);
    signal data_block_dim : std_logic_vector(3 downto 0);

    signal cnt : std_logic_vector(15 downto 0);
    signal i : integer range 0 to 2**16;
    signal j : integer range 0 to 63;

    signal shift_register : std_logic_vector(15 downto 0);
    signal data_block : std_logic_vector(9 downto 0);

begin
    --------------------------------------------------------------------------------------
    -- processes
    --------------------------------------------------------------------------------------
    p_shift_reg : process(clock, reset)
    begin
        if reset = '0' then
            shift_register <= (others => '0');
        elsif rising_edge(clock) then
            if receive_snf_data = '1' then
                shift_register(0) <= packet_in;
                for i in 0 to 14 loop
                    shift_register(i + 1) <= shift_register(i);
                end loop;
            end if;
        end if;
    end process;

    p_receive : process(clock, reset)
        file wr_file : text;
        variable L : line;
    begin
        if reset = '0' then
            current_state <= idle;
            cnt <= (others => '0');
            total_len <= (others => '1');
            ch_label <= (others => '0');
            data_block <= (others => '0');
            data_block_dim <= (others => '1');
        elsif rising_edge(clock) then
            case( current_state ) is

                when idle =>
                    if receive_snf_data = '1' then
                        current_state <= rd_total_len;
                    end if;

                when rd_total_len =>
                    cnt <= cnt + 1;
                    if cnt = 15 then
                        total_len <= shift_register;
                        current_state <= rd_data_blocks;
                        data_block <= (others => '0');

                        write(L, string'("Total length : "));
                        write(L, conv_integer(shift_register));
                        writeline(output, L);
                        i <= 0;
                        j <= 1;
                    end if;

                when rd_data_blocks =>
                    if cnt < total_len-1 then
                        if i < data_block_dim + x"13" then
                            if i = 15 then
                                ch_label <= shift_register;
                                write(L,string'("channel label : "));
                                hwrite(L, shift_register);
                                write(L,string'("; "), justified => left, field => 5);
                            elsif i = 19 then
                                data_block_dim <= shift_register(3 downto 0);
                                write(L,string'("dim : "));
                                hwrite(L, shift_register(3 downto 0));
                                write(L,string'("; "), justified => left, field => 5);
                            end if;
                            i <= i + 1;
                        else
                            data_block(9 downto (10 - conv_integer(data_block_dim))) <= shift_register(conv_integer(data_block_dim)-1 downto 0);
                            write(L,string'("data block : "));
                            hwrite(L, shift_register(conv_integer(data_block_dim)-1 downto 0));
                            write(L,string'("; "), justified => left, field => 5);
                            writeline(output, L);
                            i <= 0;
                            j <= j + 1;
                        end if;

                        cnt <= cnt + 1;
                    else
                        data_block(9 downto (10 - conv_integer(data_block_dim))) <= shift_register(conv_integer(data_block_dim)-1 downto 0);
                        write(L,string'("data block : "));
                        hwrite(L, shift_register(conv_integer(data_block_dim)-1 downto 0));
                        write(L,string'("; "), justified => left, field => 5);
                        writeline(output, L);

                        write(L, string'("Total data blocks : "));
                        write(L, j);
                        writeline(output, L);
                        writeline(output, L);
                        cnt <= (others => '0');
                        current_state <= idle;
                    end if;

                when others =>
                    current_state <= idle;
            end case;


        end if;
    end process;

end architecture;
