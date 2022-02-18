onerror {resume}
quietly WaveActivateNextPane {} 0
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
add wave -noupdate -group spi_master /tb_3/spi_master_i/csn_w
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
add wave -noupdate -group ch_32 /tb_3/ch_32_i/unloading_done
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
add wave -noupdate -group ch_31 /tb_3/ch_31_i/clock
add wave -noupdate -group ch_31 /tb_3/ch_31_i/ch_unavailable
add wave -noupdate -group ch_31 /tb_3/ch_31_i/load_pulse
add wave -noupdate -group ch_31 /tb_3/ch_31_i/unloading_done
add wave -noupdate -group ch_31 -radix hexadecimal -radixshowbase 0 /tb_3/ch_31_i/rd_data
add wave -noupdate -group ch_31 -radix unsigned -radixshowbase 0 /tb_3/ch_31_i/o_bits_stored
add wave -noupdate -group ch_31 /tb_3/ch_31_i/wr_data
add wave -noupdate -group ch_31 /tb_3/ch_31_i/send_data_block
add wave -noupdate -group ch_31 /tb_3/ch_31_i/wr_bit
add wave -noupdate -group ch_31 -radix hexadecimal -radixshowbase 0 /tb_3/ch_31_i/bit_FIFO(1)
add wave -noupdate -group ch_31 -radix unsigned -radixshowbase 0 /tb_3/ch_31_i/bits_stored(1)
add wave -noupdate -group ch_31 -color {Cornflower Blue} -radix unsigned -radixshowbase 0 /tb_3/ch_31_i/wr_index
add wave -noupdate -group ch_31 -radix hexadecimal -radixshowbase 0 /tb_3/ch_31_i/bit_FIFO(0)
add wave -noupdate -group ch_31 -radix unsigned -radixshowbase 0 /tb_3/ch_31_i/bits_stored(0)
add wave -noupdate -group ch_31 /tb_3/ch_31_i/FIFO_switch
add wave -noupdate -group ch_31 /tb_3/ch_31_i/r_config
add wave -noupdate -group ch_31 /tb_3/ch_31_i/std_discr_label
add wave -noupdate -group ch_30 /tb_3/ch_30_i/clock
add wave -noupdate -group ch_30 /tb_3/ch_30_i/ch_unavailable
add wave -noupdate -group ch_30 /tb_3/ch_30_i/load_pulse
add wave -noupdate -group ch_30 /tb_3/ch_30_i/unloading_done
add wave -noupdate -group ch_30 -radix hexadecimal -radixshowbase 0 /tb_3/ch_30_i/rd_data
add wave -noupdate -group ch_30 -radix unsigned -radixshowbase 0 /tb_3/ch_30_i/o_bits_stored
add wave -noupdate -group ch_30 /tb_3/ch_30_i/wr_data
add wave -noupdate -group ch_30 /tb_3/ch_30_i/send_data_block
add wave -noupdate -group ch_30 /tb_3/ch_30_i/wr_bit
add wave -noupdate -group ch_30 -radix hexadecimal -radixshowbase 0 /tb_3/ch_30_i/bit_FIFO(1)
add wave -noupdate -group ch_30 -radix unsigned -radixshowbase 0 /tb_3/ch_30_i/bits_stored(1)
add wave -noupdate -group ch_30 -color {Cornflower Blue} -radix unsigned -radixshowbase 0 /tb_3/ch_30_i/wr_index
add wave -noupdate -group ch_30 -radix hexadecimal -radixshowbase 0 /tb_3/ch_30_i/bit_FIFO(0)
add wave -noupdate -group ch_30 -radix unsigned -radixshowbase 0 /tb_3/ch_30_i/bits_stored(0)
add wave -noupdate -group ch_30 /tb_3/ch_30_i/FIFO_switch
add wave -noupdate -group ch_30 /tb_3/ch_30_i/r_config
add wave -noupdate -group ch_30 /tb_3/ch_30_i/std_discr_label
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/clock
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/reset
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/current_state
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/send_snf_data
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/send_data_block(31)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block(31)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block_dim(31)
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/send_data_block(30)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block(30)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block_dim(30)
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/send_data_block(29)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block(29)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block_dim(29)
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/send_data_block(28)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block(28)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block_dim(28)
add wave -noupdate -expand -group packet_manager -radix hexadecimal /tb_3/packet_manager_i/send_data_block(27)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block(27)
add wave -noupdate -expand -group packet_manager -radix hexadecimal -radixshowbase 0 /tb_3/packet_manager_i/ch_data_block_dim(27)
add wave -noupdate -expand -group packet_manager -radix unsigned -radixshowbase 0 /tb_3/packet_manager_i/total_len
add wave -noupdate -expand -group packet_manager -radix unsigned -radixshowbase 0 /tb_3/packet_manager_i/send_packet_placeholder
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/cnt_en
add wave -noupdate -expand -group packet_manager /tb_3/packet_manager_i/cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20653301 ps} 0} {{Cursor 2} {19285000 ps} 1}
quietly wave cursor active 1
configure wave -namecolwidth 314
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {15672643 ps} {23022643 ps}
