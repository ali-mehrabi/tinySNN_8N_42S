`timescale  1ns/1ns
module neuron_8s_tb();

parameter p_width = 8;
parameter p_resbit = 10;
parameter p_spike_num = 2; 
wire [8:1]           w_syncout;
wire [p_width+p_resbit+p_spike_num+2:0]   w_neuron_out;
wire [p_width+p_resbit+p_spike_num+2:0]   w_lv;
reg                  r_clk;
reg  		     r_rst_n;
reg  [8:1]           r_event;
reg  [p_width-1:0]   r_weight; 
reg  [p_width+p_resbit+p_spike_num+2:0]   r_threshold; 


neuron_8s
#(
.p_width(p_width),
.p_resbit(p_resbit),
.p_spike_num(p_spike_num)
) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_event(r_event),
.i_weight_1(r_weight),
.i_weight_2(r_weight),
.i_weight_3(r_weight),
.i_weight_4(r_weight),
.i_weight_5(r_weight),
.i_weight_6(r_weight),
.i_weight_7(r_weight),
.i_weight_8(r_weight),
.i_threshold(r_threshold),
.o_syncout(w_syncout),
.o_sv(w_lv),
.o_neuron_out(w_neuron_out)
);


always #1 r_clk <= ~r_clk;
initial 
begin 
  r_clk = 0;
  r_rst_n =0;
  r_weight = 0; 
  r_event = 0;
  r_threshold = 12'h3ff;

#10  r_rst_n = 1;
     r_weight = 'hff;
#20  r_event = 8'b01010101;
#1   r_event = 8'b00000000;

#1500    r_weight = 'hfe;
#25  r_event = 8'b00001111;
#1   r_event = 8'b00000000;

#2500 r_weight = 'h1b;
#21  r_event = 8'b10001001;
#1  r_event = 8'b00000000;

#2000 r_weight = 'ha4;
#22   r_event = 8'b11111111;
#1    r_event = 8'b00000000;

#2000 r_weight = 'h7f;
#22   r_event = 8'b00110011;
#1    r_event = 8'b00000000;
end


endmodule 