vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/HI_8345.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/entities/spi_master.vhd
vcom C:/Users/christian.manuel/github/Esercitazione_4/testbenches/tb_1.vhd
vsim -gui work.tb_1
configure wave -namecolwidth 207
configure wave -valuecolwidth 100
add wave -noupdate -expand -group inputs -label {clock ( 100 MHz )} /tb_1/clock
add wave -noupdate -expand -group inputs -label reset /tb_1/reset
add wave -noupdate -expand -group spi_bus -label spi_cmd /tb_1/spi_master_i/spi_cmd
add wave -noupdate -expand -group spi_bus -label data_byte_in -radix hexadecimal /tb_1/spi_master_i/data_byte_in
add wave -noupdate -expand -group spi_bus -label data_byte_1 -radix hexadecimal /tb_1/spi_master_i/r_data_byte_1
add wave -noupdate -expand -group spi_bus -label data_byte_0 -radix hexadecimal /tb_1/spi_master_i/r_data_byte_0
add wave -noupdate -expand -group spi_bus -label {sclk ( 16.666 MHz )} /tb_1/spi_master_i/sclk
add wave -noupdate -expand -group spi_bus -label mosi /tb_1/spi_master_i/mosi
add wave -noupdate -expand -group spi_bus -label miso /tb_1/spi_master_i/miso
add wave -noupdate -expand -group spi_bus -label csn /tb_1/spi_master_i/csn
add wave -noupdate -label busy /tb_1/spi_master_i/busy
add wave -noupdate -label {current state} /tb_1/spi_master_i/current_state
add wave -noupdate -label {timing cnt} -radix hexadecimal /tb_1/spi_master_i/timing_cnt
add wave -noupdate -expand -group spi_master -label {clock internal ( 16.666 MHz )} /tb_1/spi_master_i/clk_internal
add wave -noupdate -expand -group spi_master -label op_code -radix hexadecimal /tb_1/spi_master_i/op_code
add wave -noupdate -expand -group spi_master -label slave_address /tb_1/spi_master_i/slv_addr
add wave -noupdate -expand -group spi_master -label sense_in -radix hexadecimal /tb_1/spi_master_i/sense
add wave -noupdate -expand -group spi_master -label spi_cmd -radix hexadecimal /tb_1/spi_master_i/spi_cmd
add wave -noupdate -expand -group spi_master -label timing_cnt_en /tb_1/spi_master_i/timing_cnt_en
add wave -noupdate -expand -group spi_master -label cnt /tb_1/spi_master_i/cnt
add wave -noupdate -expand -group spi_master -label term_cnt /tb_1/spi_master_i/term_cnt
add wave -noupdate -expand -group {holt sensor} -label {sclk ( 16.666 MHz )} /tb_1/spi_master_i/sclk
add wave -noupdate -expand -group {holt sensor} -label op_code -radix hexadecimal /tb_1/HI_8345_i/op_code
add wave -noupdate -expand -group {holt sensor} -label data_byte_1 -radix hexadecimal /tb_1/HI_8345_i/data_byte_1
add wave -noupdate -expand -group {holt sensor} -label data_byte_0 -radix hexadecimal /tb_1/HI_8345_i/data_byte_0
add wave -noupdate -expand -group {holt sensor} -label cnt /tb_1/HI_8345_i/cnt
add wave -noupdate -expand -group {holt sensor} -label term_cnt /tb_1/HI_8345_i/term_cnt
add wave -noupdate -expand -group {holt sensor} -label {shift register} -radix hexadecimal /tb_1/HI_8345_i/shift_register
add wave -noupdate -expand -group {holt sensor} -label miso /tb_1/HI_8345_i/miso_w
add wave -noupdate -expand -group {holt sensor} -label {current state} /tb_1/HI_8345_i/current_state
WaveRestoreZoom {0 ps} {25 us}
run 52 us
