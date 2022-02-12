onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group inputs /tb_1/clock_w
add wave -noupdate -expand -group inputs /tb_1/reset_w
add wave -noupdate -expand -group inputs /tb_1/get_sample_w
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/busy
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/get_sample
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/slv_addr
add wave -noupdate -expand -group spi_master -radix hexadecimal /tb_1/spi_master_i/sense
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/sclk
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/mosi
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/miso
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/csn
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/current_state
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/get_sample_d0
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/get_sample_d1
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/send_get_samples_cmd
add wave -noupdate -expand -group spi_master -radix hexadecimal /tb_1/spi_master_i/data_byte
add wave -noupdate -expand -group spi_master -radix hexadecimal /tb_1/spi_master_i/sense_w
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/sclk_w
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/clk_internal
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/mosi_w
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/csn_w
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/cnt
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/timing_cnt_en
add wave -noupdate -expand -group spi_master -radix hexadecimal /tb_1/spi_master_i/timing_cnt
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/term_cnt
add wave -noupdate -expand -group spi_master /tb_1/spi_master_i/c_op_codes
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/current_state
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/op_code
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/data_byte_1
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/data_byte_0
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/cnt
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/term_cnt
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/tmp
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/shift_register
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/miso_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 292
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {912 ps}
