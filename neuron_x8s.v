module neuron_8s
#(
parameter p_width = 8,
parameter p_resbit = 8,
parameter p_spike_num = 2
)
(
input                                            i_level_clk,
input                                            i_base_clk,
input                                            i_rst_n,
input   [8:1]                                    i_event,
input   [p_width-1:0]                            i_weight_1,
input   [p_width-1:0]                            i_weight_2,
input   [p_width-1:0]                            i_weight_3,
input   [p_width-1:0]                            i_weight_4,
input   [p_width-1:0]                            i_weight_5,
input   [p_width-1:0]                            i_weight_6,
input   [p_width-1:0]                            i_weight_7,
input   [p_width-1:0]                            i_weight_8,
input   [p_width+p_resbit+p_spike_num+2:0]       i_threshold,
output  [8:1]                                    o_syncout,
output  [p_width+p_resbit+p_spike_num+2:0]       o_sv,
output  [p_width+p_resbit+p_spike_num+2:0]       o_neuron_out
);

wire [p_width+p_resbit+p_spike_num-1:0]          w_synapse_out[8:1];
wire [p_width+p_resbit+p_spike_num+2:0]          w_add_value;
wire [8:1]          w_syncout;
wire [8:1]          w_clr;
wire [p_width-1:0]  w_weight[8:1]; 

genvar i;
assign o_neuron_out = (w_add_value > i_threshold)? w_add_value:{(p_width+p_resbit+p_spike_num+3){1'h0}};
assign w_treshold_cross = (w_add_value > i_threshold)? 1:0;

assign o_sv = w_add_value;
assign o_syncout = w_syncout;
assign w_weight[1] = i_weight_1;
assign w_weight[2] = i_weight_2;
assign w_weight[3] = i_weight_3;
assign w_weight[4] = i_weight_4;
assign w_weight[5] = i_weight_5;
assign w_weight[6] = i_weight_6;
assign w_weight[7] = i_weight_7;
assign w_weight[8] = i_weight_8;

csa_adder_8in
#(.p_input_width(p_width+p_resbit+p_spike_num)) u_adder
( 	.i_a(w_synapse_out[1]),
	.i_b(w_synapse_out[2]),
	.i_c(w_synapse_out[3]),
	.i_d(w_synapse_out[4]),
	.i_e(w_synapse_out[5]),
	.i_f(w_synapse_out[6]),
	.i_g(w_synapse_out[7]),
	.i_h(w_synapse_out[8]),
	.o_s(w_add_value)
);

generate
for(i=1;i<=8;i=i+1)
begin: synapse_in
synapse
#(
.p_width(p_width),
.p_resbit(p_resbit),
.p_spike_num(p_spike_num)
) u_synapse
(
.i_clk(i_level_clk),
.i_base_clk(i_base_clk),
.i_rst_n(i_rst_n),
.i_event(i_event[i]),
.i_weight(w_weight[i]),
.o_sync(w_syncout[i]),
.o_do(w_synapse_out[i])
);
end
endgenerate

endmodule

