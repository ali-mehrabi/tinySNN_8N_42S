onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/i_clk
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/i_event
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/o_spike
add wave -noupdate -divider mvavg
add wave -noupdate /network_tb/w_cnt_clk
add wave -noupdate /network_tb/w_avg_clk
add wave -noupdate /network_tb/re
add wave -noupdate /network_tb/r_flg
add wave -noupdate -radix unsigned /network_tb/r_cnt
add wave -noupdate /network_tb/r_avg
add wave -noupdate -color Red -format Analog-Step -height 200 -itemcolor Red -max 26.0 -radix unsigned /network_tb/avg
add wave -noupdate /network_tb/w_avg_clk
add wave -noupdate /network_tb/r_delay
add wave -noupdate /network_tb/r_frame_clk
add wave -noupdate /network_tb/r_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 12} {106485 ns} 0} {{Cursor 13} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 490
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
WaveRestoreZoom {0 ns} {10059776 ns}
