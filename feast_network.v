module feast_network
#(
  parameter p_width = 8,
  parameter p_shift = 8,
  parameter p_n = 8,
  parameter p_s = 42,
  parameter p_deltaT = 'hff,
  parameter p_eta = 4, 
  parameter p_default_thr = 'hf000,
  parameter p_default_w = 'hff)
(
input                                  i_clk,
input                                  i_rst_n,
input  [p_s:1]                         i_event,
input                                  i_endof_epochs,
output [p_n:1]                         o_spike
);


wire [p_s:1]                         w_sync;
wire [p_n*(p_width+p_shift+6)-1:0]   w_sv;
wire [p_n*(p_s*p_width)-1:0]         w_weight;
wire [p_n*(p_width+p_shift+6)-1:0]   w_threshold;


OLV
#(  .p_width(p_width),
	.p_shift(p_shift),
	.p_n(p_n),
	.p_s(p_s)) u_feast
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_event(i_event),
	.i_weight(w_weight),
	.i_threshold(w_threshold),
	.o_sync(w_sync),
	.o_sv(w_sv),
	.o_spike(o_spike)
);

OLV_train
#(
	.p_width(p_width),
	.p_resbit(p_shift),
	.p_n(p_n),
	.p_s(p_s),
	.p_deltaT(p_deltaT),
	.p_eta(p_eta), 
	.p_default_thr(p_default_thr),
	.p_default_w(p_default_w)
  ) u_feast_train
(
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_lvl_spikeout(o_spike),
	.i_sv(w_sv),
	.i_syncout(w_sync),
	.i_endof_epochs(i_endof_epochs),
	.o_weights(w_weight),
	.o_thresholds(w_threshold)
);

endmodule