vcom C:/Users/christian.manuel/github/Esercitazione_4/packages/pkg_signals.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/packet_manager.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/HI_8345.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/packet_manager.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/spi_master.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/std_discr_ch.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/testbenches/tb_3.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/testbenches/tb_output_analysis.vhd
vsim -gui work.tb_3
configure wave -namecolwidth 314
configure wave -valuecolwidth 100
add wave -noupdate -group spi_master /tb_3/clock
add wave -noupdate -group spi_master /tb_3/reset
add wave -noupdate -group spi_master /tb_3/spi_master_i/busy
add wave -noupdate -group spi_master /tb_3/spi_master_i/spi_cmd
add wave -noupdate -group spi_master /tb_3/spi_master_i/rd_regs
add wave -noupdate -group spi_master /tb_3/spi_master_i/data_byte_in
add wave -noupdate -group spi_master /tb_3/spi_master_i/slv_addr
add wave -noupdate -group spi_master /tb_3/spi_master_i/sense
add wave -noupdate -group spi_master /tb_3/spi_master_i/data_ready
add wave -noupdate -group spi_master /tb_3/spi_master_i/sclk
add wave -noupdate -group spi_master /tb_3/spi_master_i/mosi
add wave -noupdate -group spi_master /tb_3/spi_master_i/miso
add wave -noupdate -group spi_master /tb_3/spi_master_i/csn
add wave -noupdate -group spi_master /tb_3/spi_master_i/clock_16MHz
add wave -noupdate -group spi_master /tb_3/spi_master_i/current_state
add wave -noupdate -group spi_master /tb_3/spi_master_i/r_data_byte_1
add wave -noupdate -group spi_master /tb_3/spi_master_i/r_data_byte_0
add wave -noupdate -group spi_master /tb_3/spi_master_i/r_hyst_val
add wave -noupdate -group spi_master /tb_3/spi_master_i/r_center_val
add wave -noupdate -group spi_master /tb_3/spi_master_i/op_code
add wave -noupdate -group spi_master /tb_3/spi_master_i/cnt
add wave -noupdate -group spi_master /tb_3/spi_master_i/clk_internal
add wave -noupdate -group spi_master /tb_3/spi_master_i/timing_cnt_en
add wave -noupdate -group spi_master /tb_3/spi_master_i/timing_cnt
add wave -noupdate -group spi_master /tb_3/spi_master_i/term_cnt
add wave -noupdate -group spi_master /tb_3/spi_master_i/sclk_w
add wave -noupdate -group spi_master /tb_3/spi_master_i/mosi_w
add wave -noupdate -group spi_master /tb_3/spi_master_i/sense_w
add wave -noupdate -group spi_master /tb_3/spi_master_i/data_ready_w
add wave -noupdate -group spi_master /tb_3/spi_master_i/c_op_codes
add wave -noupdate -group holt /tb_3/HI_8345_i/current_state
add wave -noupdate -group holt /tb_3/HI_8345_i/r_ctrl
add wave -noupdate -group holt /tb_3/HI_8345_i/srst
add wave -noupdate -group holt /tb_3/HI_8345_i/test
add wave -noupdate -group holt /tb_3/HI_8345_i/r_psen
add wave -noupdate -group holt /tb_3/HI_8345_i/r_tmdata
add wave -noupdate -group holt /tb_3/HI_8345_i/r_gohys
add wave -noupdate -group holt /tb_3/HI_8345_i/r_gocval
add wave -noupdate -group holt /tb_3/HI_8345_i/r_sohys
add wave -noupdate -group holt /tb_3/HI_8345_i/r_socval
add wave -noupdate -group holt /tb_3/HI_8345_i/r_SSB_0
add wave -noupdate -group holt /tb_3/HI_8345_i/r_SSB_1
add wave -noupdate -group holt /tb_3/HI_8345_i/r_SSB_2
add wave -noupdate -group holt /tb_3/HI_8345_i/r_SSB_3
add wave -noupdate -group holt /tb_3/HI_8345_i/c_sense_vals
add wave -noupdate -group holt /tb_3/HI_8345_i/op_code
add wave -noupdate -group holt /tb_3/HI_8345_i/data_byte_1
add wave -noupdate -group holt /tb_3/HI_8345_i/data_byte_0
add wave -noupdate -group holt /tb_3/HI_8345_i/cnt
add wave -noupdate -group holt /tb_3/HI_8345_i/term_cnt
add wave -noupdate -group holt /tb_3/HI_8345_i/shift_register
add wave -noupdate -group ch_32 /tb_3/ch_32_i/clock
add wave -noupdate -group ch_32 /tb_3/ch_32_i/ch_unavailable
add wave -noupdate -group ch_32 /tb_3/ch_32_i/load_pulse
add wave -noupdate -group ch_32 -radix hexadecimal -radixshowbase 0 /tb_3/ch_32_i/rd_data
add wave -noupdate -group ch_32 -radix unsigned -radixshowbase 0 /tb_3/ch_32_i/o_bits_stored
add wave -noupdate -group ch_32 /tb_3/ch_32_i/wr_data
add wave -noupdate -group ch_32 /tb_3/ch_32_i/send_data_block
add wave -noupdate -group ch_32 /tb_3/ch_32_i/wr_bit
add wave -noupdate -group ch_32 -radix hexadecimal -radixshowbase 0 /tb_3/ch_32_i/bit_FIFO(1)
add wave -noupdate -group ch_32 -radix unsigned -radixshowbase 0 /tb_3/ch_32_i/bits_stored(1)
add wave -noupdate -group ch_32 -color {Cornflower Blue} -radix unsigned -radixshowbase 0 /tb_3/ch_32_i/wr_index
add wave -noupdate -group ch_32 -radix hexadecimal -radixshowbase 0 /tb_3/ch_32_i/bit_FIFO(0)
add wave -noupdate -group ch_32 -radix unsigned -radixshowbase 0 /tb_3/ch_32_i/bits_stored(0)
add wave -noupdate -group ch_32 /tb_3/ch_32_i/FIFO_switch
add wave -noupdate -group ch_32 /tb_3/ch_32_i/r_config
add wave -noupdate -group ch_32 /tb_3/ch_32_i/std_discr_label
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/clock
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/reset
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/current_state
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/send_snf_data

add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/ch_unavailable
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/send_data_block
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/load_pulse


add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_label
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/block_data
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/block_data_dim

add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block_dim

add wave -noupdate -expand -group packet_manager -radix unsigned -radixshowbase 0 /tb_3/packet_manager_i/total_len
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/send_packet_placeholder
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/cnt_en
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/total_data_blocks
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/index
add wave -noupdate -expand -group packet_manager -radix unsigned /tb_3/packet_manager_i/cnt
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/i
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/j
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/receive_snf_data
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/packet_out

add wave -noupdate -expand -group {output analysis} /tb_3/tb_output_analysis_i/receive_snf_data
add wave -noupdate -expand -group {output analysis} /tb_3/tb_output_analysis_i/packet_in
add wave -noupdate -expand -group {output analysis} /tb_3/tb_output_analysis_i/current_state
add wave -noupdate -expand -group {output analysis} -radix unsigned -radixshowbase 0 /tb_3/tb_output_analysis_i/total_len
add wave -noupdate -expand -group {output analysis} -radix hexadecimal -radixshowbase 0 /tb_3/tb_output_analysis_i/ch_label
add wave -noupdate -expand -group {output analysis} -radix hexadecimal -radixshowbase 0 /tb_3/tb_output_analysis_i/data_block_dim
add wave -noupdate -expand -group {output analysis} -radix unsigned -radixshowbase 0 /tb_3/tb_output_analysis_i/cnt
add wave -noupdate -expand -group {output analysis} -radix unsigned -radixshowbase 0 /tb_3/tb_output_analysis_i/i
add wave -noupdate -expand -group {output analysis} -radix unsigned -radixshowbase 0 /tb_3/tb_output_analysis_i/j
add wave -noupdate -expand -group {output analysis} -radix hexadecimal -radixshowbase 0 /tb_3/tb_output_analysis_i/shift_register
add wave -noupdate -expand -group {output analysis} -radix hexadecimal -radixshowbase 0 /tb_3/tb_output_analysis_i/data_block
run 100 us
