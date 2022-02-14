onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group inputs -label {clock ( 100 MHz )} /tb_1/clock_w
add wave -noupdate -expand -group inputs -label reset /tb_1/reset_w
add wave -noupdate -expand -group inputs -label set_ctrl /tb_1/spi_master_i/set_ctrl
add wave -noupdate -expand -group inputs -label get_sample /tb_1/spi_master_i/get_sample
add wave -noupdate -expand -group inputs -label set_thresholds(1) /tb_1/spi_master_i/set_thresholds(1)
add wave -noupdate -expand -group inputs -label set_thresholds(0) /tb_1/spi_master_i/set_thresholds(0)
add wave -noupdate -expand -group inputs -label hyst_val -radix hexadecimal /tb_1/spi_master_i/hyst_val
add wave -noupdate -expand -group inputs -label center_val -radix hexadecimal /tb_1/spi_master_i/center_val
add wave -noupdate -expand -group inputs -label set_psen_w /tb_1/set_psen_W
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24999639 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {25327528 ps}
