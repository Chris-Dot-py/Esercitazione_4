onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group inputs -label {clock ( 100 MHz )} /tb_2/clock
add wave -noupdate -expand -group inputs -label reset /tb_2/reset
add wave -noupdate -group spi_bus -label spi_cmd /tb_2/spi_master_i/spi_cmd
add wave -noupdate -group spi_bus -label rd_regs /tb_2/spi_master_i/rd_regs
add wave -noupdate -group spi_bus -label data_byte_in -radix hexadecimal /tb_2/spi_master_i/data_byte_in
add wave -noupdate -group spi_bus -label data_byte_1 -radix hexadecimal /tb_2/spi_master_i/r_data_byte_1
add wave -noupdate -group spi_bus -label data_byte_0 -radix hexadecimal /tb_2/spi_master_i/r_data_byte_0
add wave -noupdate -group spi_bus -label {sclk ( 16.666 MHz )} /tb_2/spi_master_i/sclk
add wave -noupdate -group spi_bus -label mosi /tb_2/spi_master_i/mosi
add wave -noupdate -group spi_bus -label miso /tb_2/spi_master_i/miso
add wave -noupdate -group spi_bus -label csn /tb_2/spi_master_i/csn
add wave -noupdate -label busy /tb_2/spi_master_i/busy
add wave -noupdate -label data_ready /tb_2/spi_master_i/data_ready
add wave -noupdate -label {current state} /tb_2/spi_master_i/current_state
add wave -noupdate -label {timing cnt} -radix hexadecimal /tb_2/spi_master_i/timing_cnt
add wave -noupdate -expand -group spi_master -label {clock internal ( 16.666 MHz )} /tb_2/spi_master_i/clk_internal
add wave -noupdate -expand -group spi_master -label op_code -radix hexadecimal /tb_2/spi_master_i/op_code
add wave -noupdate -expand -group spi_master -label slave_address /tb_2/spi_master_i/slv_addr
add wave -noupdate -expand -group spi_master -label sense_in -radix hexadecimal /tb_2/spi_master_i/sense
add wave -noupdate -expand -group spi_master -label spi_cmd -radix hexadecimal /tb_2/spi_master_i/spi_cmd
add wave -noupdate -expand -group spi_master -label timing_cnt_en /tb_2/spi_master_i/timing_cnt_en
add wave -noupdate -expand -group spi_master -label cnt /tb_2/spi_master_i/cnt
add wave -noupdate -expand -group spi_master -label term_cnt /tb_2/spi_master_i/term_cnt
add wave -noupdate -group {holt sensor} -label {sclk ( 16.666 MHz )} /tb_2/spi_master_i/sclk
add wave -noupdate -group {holt sensor} -label op_code -radix hexadecimal /tb_2/HI_8345_i/op_code
add wave -noupdate -group {holt sensor} -label data_byte_1 -radix hexadecimal /tb_2/HI_8345_i/data_byte_1
add wave -noupdate -group {holt sensor} -label data_byte_0 -radix hexadecimal /tb_2/HI_8345_i/data_byte_0
add wave -noupdate -group {holt sensor} -label cnt /tb_2/HI_8345_i/cnt
add wave -noupdate -group {holt sensor} -label term_cnt /tb_2/HI_8345_i/term_cnt
add wave -noupdate -group {holt sensor} -label {shift register} -radix hexadecimal /tb_2/HI_8345_i/shift_register
add wave -noupdate -group {holt sensor} -label miso /tb_2/HI_8345_i/miso_w
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_ctrl -radix hexadecimal /tb_2/HI_8345_i/r_ctrl
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_psen -radix hexadecimal /tb_2/HI_8345_i/r_psen
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_tm_data -radix hexadecimal /tb_2/HI_8345_i/r_tmdata
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_gohys -radix hexadecimal /tb_2/HI_8345_i/r_gohys
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_gocval -radix hexadecimal /tb_2/HI_8345_i/r_gocval
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_sohys -radix hexadecimal /tb_2/HI_8345_i/r_sohys
add wave -noupdate -group {holt sensor} -group {holt regs} -label r_socval -radix hexadecimal /tb_2/HI_8345_i/r_socval
add wave -noupdate -group {holt sensor} -group {holt regs} -label SSB0 -radix hexadecimal /tb_2/HI_8345_i/r_SSB_0
add wave -noupdate -group {holt sensor} -group {holt regs} -label SSB1 -radix hexadecimal /tb_2/HI_8345_i/r_SSB_1
add wave -noupdate -group {holt sensor} -group {holt regs} -label SSB2 -radix hexadecimal /tb_2/HI_8345_i/r_SSB_2
add wave -noupdate -group {holt sensor} -group {holt regs} -label SSB3 -radix hexadecimal /tb_2/HI_8345_i/r_SSB_3
add wave -noupdate -group {holt sensor} -label {current state} /tb_2/HI_8345_i/current_state
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/ch_unavailable_w
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/wr_data
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/load_pulse
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/unloading_done
add wave -noupdate -expand -group std_discr_ch -color Orange -radix hexadecimal -radixshowbase 0 /tb_2/std_discr_ch_i/rd_data
add wave -noupdate -expand -group std_discr_ch -color Orange -radix unsigned -radixshowbase 0 /tb_2/std_discr_ch_i/o_bits_stored
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/send_data_block
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/wr_bit
add wave -noupdate -expand -group std_discr_ch /tb_2/std_discr_ch_i/FIFO_switch
add wave -noupdate -expand -group std_discr_ch -radix hexadecimal -radixshowbase 0 /tb_2/std_discr_ch_i/bit_FIFO(0)
add wave -noupdate -expand -group std_discr_ch -radix unsigned -radixshowbase 0 /tb_2/std_discr_ch_i/bits_stored(0)
add wave -noupdate -expand -group std_discr_ch -color {Cornflower Blue} -radix unsigned -radixshowbase 0 /tb_2/std_discr_ch_i/wr_index
add wave -noupdate -expand -group std_discr_ch -radix hexadecimal -radixshowbase 0 /tb_2/std_discr_ch_i/bit_FIFO(1)
add wave -noupdate -expand -group std_discr_ch -radix unsigned -radixshowbase 0 /tb_2/std_discr_ch_i/bits_stored(1)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46887686 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 294
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
WaveRestoreZoom {200 ns} {84200 ns}
