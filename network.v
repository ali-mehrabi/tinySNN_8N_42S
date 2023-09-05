`timescale 1ns/1ns
module  network
(
input         i_clk,
input         i_rst_n,
output [8:1]  o_output_spike
);

parameter p_width = 8;
parameter p_shift = 8;
parameter p_n = 8;
parameter p_s = 42;
parameter p_deltaT = 'hff;
parameter p_eta = 8; 
parameter p_default_thr = 'hf000;
parameter p_default_w = 'hff;
// training spikes parameters
parameter p_test_len = 9000;
parameter p_spike_delay = 3;
parameter p_pattern_delay = 100;
parameter p_epochs = 100; 
  
wire  [42:1] w_test_vector;
wire         w_epochs;
wire  [8:1]  w_output_spike;

feast_network
#(
	.p_width(p_width),
	.p_shift(p_shift),
	.p_n(p_n),
	.p_s(p_s),
	.p_deltaT(p_deltaT),
	.p_eta(p_eta), 
	.p_default_thr(p_default_thr),
	.p_default_w(p_default_w)
) u_network
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_event(w_test_vector),
	.i_endof_epochs(w_epochs),
	.o_spike(o_output_spike)
);

auto_trainer #(
	.p_test_len(p_test_len),
	.p_spike_delay(p_spike_delay),
	.p_pattern_delay(p_pattern_delay),
	.p_epochs(p_epochs)
) u_trainer 
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.o_end_of_epochs(w_epochs),
	.o_test_vector(w_test_vector)
);





endmodule