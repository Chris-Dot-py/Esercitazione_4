vcom C:/Users/Christian/github/Esercitazione_4/entities/HI_8345.vhd
vcom C:/Users/Christian/github/Esercitazione_4/entities/spi_master.vhd
vcom C:/Users/Christian/github/Esercitazione_4/testbenches/tb_1.vhd
vsim -gui work.tb_1
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
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/current_state
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/op_code
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/data_byte_1
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/data_byte_0
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/cnt
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/term_cnt
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/tmp
add wave -noupdate -expand -group {holt sensor} -radix hexadecimal /tb_1/HI_8345_i/shift_register
add wave -noupdate -expand -group {holt sensor} /tb_1/HI_8345_i/miso_w
run 15 us
