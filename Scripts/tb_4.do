vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/std_discr_if.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/HI_8345.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/packet_manager.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/spi_master.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/std_discr_ch.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/std_discr_if.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/top_32_std_discr_ch.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/packages/pkg_signals.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/testbenches/tb_4.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/testbenches/tb_output_analysis.vhd
vsim -gui work.tb_4
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
add wave -noupdate -radix hexadecimal /tb_4/clock
add wave -noupdate -radix hexadecimal /tb_4/reset
add wave -noupdate -radix hexadecimal /tb_4/config_mode
add wave -noupdate -radix hexadecimal /tb_4/config_done
add wave -noupdate -radix hexadecimal /tb_4/send_snf_data
add wave -noupdate -radix hexadecimal /tb_4/set_config
add wave -noupdate -group holt -radix hexadecimal /tb_4/HI_8345_i/sclk
add wave -noupdate -group holt -radix hexadecimal /tb_4/HI_8345_i/mosi
add wave -noupdate -group holt -radix hexadecimal /tb_4/HI_8345_i/miso
add wave -noupdate -group holt -radix hexadecimal /tb_4/HI_8345_i/csn
add wave -noupdate -group holt -radix hexadecimal /tb_4/HI_8345_i/current_state
add wave -noupdate -expand -group holt -expand -group {holt regs} -radix hexadecimal /tb_4/HI_8345_i/r_ctrl
add wave -noupdate -expand -group holt -expand -group {holt regs} -radix hexadecimal /tb_4/HI_8345_i/r_psen
add wave -noupdate -expand -group holt -expand -group {holt regs} -radix hexadecimal /tb_4/HI_8345_i/r_gohys
add wave -noupdate -expand -group holt -expand -group {holt regs} -radix hexadecimal /tb_4/HI_8345_i/r_gocval
add wave -noupdate -expand -group holt -expand -group {holt regs} -radix hexadecimal /tb_4/HI_8345_i/r_sohys
add wave -noupdate -expand -group holt -expand -group {holt regs} -radix hexadecimal /tb_4/HI_8345_i/r_socval
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/reset
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/receive_snf_data
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/packet_in
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/current_state
add wave -noupdate -group output_analyzer -radix unsigned /tb_4/tb_output_analysis_i/total_len
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/ch_label
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/data_block_dim
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/shift_register
add wave -noupdate -group output_analyzer -radix hexadecimal /tb_4/tb_output_analysis_i/data_block
add wave -noupdate -group packet_manager -radix hexadecimal /tb_4/std_discr_if_i/packet_manager_i/send_snf_data
add wave -noupdate -group packet_manager -radix hexadecimal /tb_4/std_discr_if_i/packet_manager_i/receive_snf_data
add wave -noupdate -group packet_manager -radix hexadecimal /tb_4/std_discr_if_i/packet_manager_i/packet_out
add wave -noupdate -group packet_manager -radix hexadecimal /tb_4/std_discr_if_i/packet_manager_i/current_state
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/send_snf_data
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/receive_snf_data
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/packet_out
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/config_mode
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/config_done
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/set_config
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/disable_ch
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/psen
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/HI_threshold
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/LO_threshold
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/busy_d
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/spi_cmd
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/rd_regs
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/data_byte_in
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/r_psen
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/r_HI_threshold
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/r_LO_threshold
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/send_data_block
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/o_data_ready
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/block_data
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/block_data_dim
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/ch_unavailable
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/ch_label
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/current_state
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/cnt
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/cnt_en
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/first_threshold_setup_done
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/data_byte_1_sent
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/SRes_done
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/config_done_w
add wave -noupdate -group std_discr_if -radix hexadecimal /tb_4/std_discr_if_i/samples_present
add wave -noupdate -group spi -group spi_bus -radix hexadecimal /tb_4/std_discr_if_i/spi_master_i/sclk
add wave -noupdate -group spi -group spi_bus -radix hexadecimal /tb_4/std_discr_if_i/spi_master_i/mosi
add wave -noupdate -group spi -group spi_bus -radix hexadecimal /tb_4/std_discr_if_i/spi_master_i/miso
add wave -noupdate -group spi -group spi_bus -radix hexadecimal /tb_4/std_discr_if_i/spi_master_i/csn
add wave -noupdate -group spi /tb_4/std_discr_if_i/spi_master_i/data_ready
add wave -noupdate -group spi -radix hexadecimal /tb_4/std_discr_if_i/busy
add wave -noupdate -group spi -radix hexadecimal /tb_4/std_discr_if_i/cnt
add wave -noupdate -group spi -radix hexadecimal /tb_4/std_discr_if_i/spi_master_i/sense
add wave -noupdate -group spi -radix hexadecimal /tb_4/std_discr_if_i/spi_master_i/current_state
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/rd_op
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/wr_op
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/wr_data
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/load_pulse
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/rd_data
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/o_bits_stored
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/set_config
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/std_discr_disable
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/ch_unavailable
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/std_discr_label
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/bit_FIFO(1)
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/bits_stored(1)
add wave -noupdate -group ch_32 -color cyan -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/wr_index
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/bit_FIFO(0)
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/bits_stored(0)
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/rd_op_d
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/wr_bit
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/send_data_block
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/FIFO_switch
add wave -noupdate -group ch_32 -radix hexadecimal /tb_4/std_discr_if_i/top_32_std_discr_ch_i/channel_31_i/r_config
run 250 us;
