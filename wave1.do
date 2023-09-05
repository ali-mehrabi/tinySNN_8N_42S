onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/o_spike
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/o_spike
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/i_event
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/i_clk
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/o_result
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/o_index
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_h
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_g
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_f
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_e
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_d
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_c
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_b
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp4/i_a
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/w_pass_l1
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/r_stop_n
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/r_training_active
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/w_input_event_on
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/r_winner
add wave -noupdate -subitemconfig {{/network_tb/u_network_test/u_network/u_feast_train/r_w[1]} -expand} /network_tb/u_network_test/u_network/u_feast_train/r_w
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/r_ts
add wave -noupdate -expand /network_tb/u_network_test/u_network/u_feast_train/r_threshold
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/r_state
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/r_gas
add wave -noupdate /network_tb/u_network_test/u_network/u_feast_train/i_endof_epochs
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/w_rst
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/w_q1
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/r_state
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/r_rst
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/r_counter
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/i_spike
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/i_index
add wave -noupdate /network_tb/re
add wave -noupdate /network_tb/r_frame_clk
add wave -noupdate /network_tb/r_cnt
add wave -noupdate /network_tb/r_avg
add wave -noupdate -color Yellow -format Analog-Step -height 255 -itemcolor Yellow -max 40.0 /network_tb/avg
add wave -noupdate /network_tb/u_network_test/u_trainer/r_sample_frame
add wave -noupdate /network_tb/u_network_test/u_trainer/r_epochs
add wave -noupdate /network_tb/u_network_test/u_trainer/r_end_of_epochs
add wave -noupdate /network_tb/u_network_test/u_trainer/o_end_of_epochs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3057449 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 447
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
WaveRestoreZoom {4441530 ns} {25964731 ns}
