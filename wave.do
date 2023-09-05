onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /network_tb/u_network_test/u_network/i_clk
add wave -noupdate /network_tb/u_network_test/u_network/o_spike
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/i_event
add wave -noupdate -divider u_adder
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[1]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[2]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[3]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[4]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[5]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[6]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[7]/u_neuron/u_adder42/o_s}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[8]/u_neuron/u_adder42/o_s}
add wave -noupdate -divider u_neuron
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[1]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[2]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[3]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[4]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[5]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[6]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[7]/u_neuron/o_neuronout}
add wave -noupdate {/network_tb/u_network_test/u_network/u_feast/gen_neuron_i[8]/u_neuron/o_neuronout}
add wave -noupdate -divider u_comp8
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/o_index
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/o_result
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/r_index
add wave -noupdate -divider upul
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/o_spike
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/i_spike
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/upul/i_index
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/w_z
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/w_l4
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/w_l3
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/w_l2
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/w_l1
add wave -noupdate -divider {New Divider}
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/u1/o_result
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/u1/o_index
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/u2/o_result
add wave -noupdate /network_tb/u_network_test/u_network/u_feast/u_comp8/u2/o_index
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2964 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 559
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
WaveRestoreZoom {0 ns} {49 ns}
