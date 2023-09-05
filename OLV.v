module neuron_level
#(parameter p_width = 8,
  parameter p_shift = 8,
  parameter p_n = 4)
(
input  i_clk,
input  i_rst_n,
input  [42:1]                         i_event,
input  [p_n*42*p_width-1: 0]          i_weight,
input  [p_n*(p_width+p_shift+6)-1:0]  i_threshold,
output [42:1]     o_sync,
output [p_n:1]    o_spike
);

parameter p_thr_width = p_width+p_shift+6;
parameter p_s = 42;
genvar i;
genvar j;

wire [p_width-1:0]              w_weight[p_n:1][p_s:1];
wire [(p_width+p_shift+6)-1:0]  w_threshold[p_n:1];
wire [(p_width+p_shift+6)-1:0]  w_neuronout[p_n:1];
wire [p_s:1]                    w_sync[p_n:1];
wire [p_n:1]                    w_index;
wire [p_n:1]                    w_spike_out;
wire                            w_is_event;

assign o_spike = w_spike_out;
assign w_is_event = (i_event == 0)? 0:1;
assign o_sync = w_sync[1];

generate
for(i=1;i<= p_n;i=i+1)
begin: gen_wi
  for(j=1;j<= p_s;j=j+1)
    begin: gen_w_ts_j
      assign  w_weight[i][j] = i_weight[(i-1)*(p_s*p_width)+j*p_width-1:(i-1)*(p_s*p_width)+(j-1)*p_width];
	 end	
end

for(i=1;i<= p_n;i=i+1)
begin :gen_th_i
  assign  w_threshold[i] = i_threshold[i*(p_thr_width)-1:(i-1)*(p_thr_width)];
  //assign  o_sv[i*p_thr_width-1:(i-1)*p_thr_width] = w_sv[i];
end


for(i=1;i<= p_n;i=i+1)
begin :gen_neuron_i
neuron42s
#(.p_width(p_width),
  .p_shift(p_shift)) uut
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_event(i_event),
.i_weight01(w_weight[i][1]),
.i_weight02(w_weight[i][2]),
.i_weight03(w_weight[i][3]),
.i_weight04(w_weight[i][4]),
.i_weight05(w_weight[i][5]),
.i_weight06(w_weight[i][6]),
.i_weight07(w_weight[i][7]),
.i_weight08(w_weight[i][8]),
.i_weight09(w_weight[i][9]),
.i_weight10(w_weight[i][10]),
.i_weight11(w_weight[i][11]),
.i_weight12(w_weight[i][12]),
.i_weight13(w_weight[i][13]),
.i_weight14(w_weight[i][14]),
.i_weight15(w_weight[i][15]),
.i_weight16(w_weight[i][16]),
.i_weight17(w_weight[i][17]),
.i_weight18(w_weight[i][18]),
.i_weight19(w_weight[i][19]),
.i_weight20(w_weight[i][20]),
.i_weight21(w_weight[i][21]),
.i_weight22(w_weight[i][22]),
.i_weight23(w_weight[i][23]),
.i_weight24(w_weight[i][24]),
.i_weight25(w_weight[i][25]),
.i_weight26(w_weight[i][26]),
.i_weight27(w_weight[i][27]),
.i_weight28(w_weight[i][28]),
.i_weight29(w_weight[i][29]),
.i_weight30(w_weight[i][30]),
.i_weight31(w_weight[i][31]),
.i_weight32(w_weight[i][32]),
.i_weight33(w_weight[i][33]),
.i_weight34(w_weight[i][34]),
.i_weight35(w_weight[i][35]),
.i_weight36(w_weight[i][36]),
.i_weight37(w_weight[i][37]),
.i_weight38(w_weight[i][38]),
.i_weight39(w_weight[i][39]),
.i_weight40(w_weight[i][40]),
.i_weight41(w_weight[i][41]),
.i_weight42(w_weight[i][42]),
.i_threshold(w_threshold[i]),
.o_sync(w_sync[i]),
.o_neuronout(w_neuronout[i])
);
end

for(i=1;i<= 4;i=i+1)
  begin:gen_pulse
	pulse upul(
	  .i_index(w_index[i]),
	  .i_spike(w_is_event),
	  .i_clk(i_clk),
	  .i_rst_n(i_rst_n),
	  .o_spike(w_spike_out[i])
	);
  end
endgenerate

comparator_4in 
#(.p_width(p_thr_width)) u_comp4
(   .i_clk(i_clk),
    .i_rst_n(i_rst_n),
	.i_a(w_neuronout[1]),
	.i_b(w_neuronout[2]),
	.i_c(w_neuronout[3]),
	.i_d(w_neuronout[4]),
	.o_result(),
	.o_index(w_index)
);


endmodule