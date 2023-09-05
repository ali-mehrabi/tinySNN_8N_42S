module neuron42s
#(parameter p_width = 8,
  parameter p_shift = 8, 
  parameter p_s = 42)
(
input  i_clk,
input  i_rst_n,
input  [42:1] i_event,
input  [p_s*p_width-1: 0]     i_weight,
input  [p_width+p_shift+5:0]  i_threshold,
output [p_width+p_shift+5:0]  o_sv,
output [42:1] o_sync,
output [p_width+p_shift+5:0]  o_neuronout
);
parameter p_wadder = p_width+p_shift;
parameter p_wth = p_width+p_shift+6;

wire [p_wth-1:0] w_s;
wire [p_width+p_shift-1:0] w_synout[42:1];
wire [p_width-1:0] w_weight[42:1];

assign o_neuronout = (w_s >= i_threshold)? w_s:0;
assign o_sv = w_s;

genvar i;

generate
for(i=1;i<=42;i=i+1)
  begin:gen_synapse_i
    synapse 
	#(
		.p_width(p_width),
		.p_resbit(p_shift)) u_synapse
	(
		.i_event(i_event[i]),
		.i_rst_n(i_rst_n),
		.i_clk(i_clk),
		.i_weight(i_weight[i*p_width-1 : (i-1)*p_width]),
		.o_sync(o_sync[i]),
		.o_do(w_synout[i])
	);
end
endgenerate

adder_42in
#(.p_input_width(p_wadder)) u_adder_42S
(
.i_a01(w_synout[1]),
.i_a02(w_synout[2]),
.i_a03(w_synout[3]),
.i_a04(w_synout[4]),
.i_a05(w_synout[5]),
.i_a06(w_synout[6]),
.i_a07(w_synout[7]),
.i_a08(w_synout[8]),
.i_a09(w_synout[9]),
.i_a10(w_synout[10]),
.i_a11(w_synout[11]),
.i_a12(w_synout[12]),
.i_a13(w_synout[13]),
.i_a14(w_synout[14]),
.i_a15(w_synout[15]),
.i_a16(w_synout[16]),
.i_a17(w_synout[17]),
.i_a18(w_synout[18]),
.i_a19(w_synout[19]),
.i_a20(w_synout[20]),
.i_a21(w_synout[21]),
.i_a22(w_synout[22]),
.i_a23(w_synout[23]),
.i_a24(w_synout[24]),
.i_a25(w_synout[25]),
.i_a26(w_synout[26]),
.i_a27(w_synout[27]),
.i_a28(w_synout[28]),
.i_a29(w_synout[29]),
.i_a30(w_synout[30]),
.i_a31(w_synout[31]),
.i_a32(w_synout[32]),
.i_a33(w_synout[33]),
.i_a34(w_synout[34]),
.i_a35(w_synout[35]),
.i_a36(w_synout[36]),
.i_a37(w_synout[37]),
.i_a38(w_synout[38]),
.i_a39(w_synout[39]),
.i_a40(w_synout[40]),
.i_a41(w_synout[41]),
.i_a42(w_synout[42]),
.o_s(w_s)
);

endmodule