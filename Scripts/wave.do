onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group inputs -label {clock ( 100 MHz )} /tb_1/clock
add wave -noupdate -expand -group inputs -label reset /tb_1/reset
add wave -noupdate -expand -group spi_bus -label spi_cmd /tb_1/spi_master_i/spi_cmd
add wave -noupdate -expand -group spi_bus -label rd_regs /tb_1/spi_master_i/rd_regs
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
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_ctrl -radix hexadecimal /tb_1/HI_8345_i/r_ctrl
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_psen -radix hexadecimal /tb_1/HI_8345_i/r_psen
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_tm_data -radix hexadecimal /tb_1/HI_8345_i/r_tmdata
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_gohys -radix hexadecimal /tb_1/HI_8345_i/r_gohys
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_gocval -radix hexadecimal /tb_1/HI_8345_i/r_gocval
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_sohys -radix hexadecimal /tb_1/HI_8345_i/r_sohys
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label r_socval -radix hexadecimal /tb_1/HI_8345_i/r_socval
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label SSB0 -radix hexadecimal /tb_1/HI_8345_i/r_SSB_0
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label SSB1 -radix hexadecimal /tb_1/HI_8345_i/r_SSB_1
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label SSB2 -radix hexadecimal /tb_1/HI_8345_i/r_SSB_2
add wave -noupdate -expand -group {holt sensor} -group {holt regs} -label SSB3 -radix hexadecimal /tb_1/HI_8345_i/r_SSB_3
add wave -noupdate -expand -group {holt sensor} -label {current state} /tb_1/HI_8345_i/current_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 207
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
WaveRestoreZoom {12785 ns} {37785 ns}
