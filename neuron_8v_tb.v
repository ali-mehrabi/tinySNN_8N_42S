`timescale  1ns/1ns
module neuron_8vs_tb();

parameter p_width = 8;
parameter p_resbit = 32;
parameter p_spike_num = 2; 
wire [8:1]           w_syncout;
wire [p_width+p_resbit+p_spike_num+2:0]   w_neuron_out;
wire [p_width+p_resbit+p_spike_num+2:0]   w_lv;
reg                  r_clk;
reg                  r_lclk;
reg  		         r_rst_n;
reg  [8:1]           r_event;
reg  [p_width-1:0]   r_weight; 
reg  [p_width+p_resbit+p_spike_num+2:0]   r_threshold; 


neuron_8vs
#(
.p_width(p_width),
.p_resbit(p_resbit),
.p_spike_num(p_spike_num)
) uut
(
.i_level_clk(r_lclk),
.i_base_clk(r_clk),
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

parameter dt_on = 9;
parameter dt_off = 1;

always #1 r_clk <= ~r_clk;
always #10 r_lclk <= ~r_lclk;
initial 
begin 
  r_clk = 0;
  r_lclk = 0;
  r_rst_n =0;
  r_weight = 0; 
  r_event = 0;
  r_threshold = 12'h3ff;

#10  r_rst_n = 1;
     r_weight = 'hff;

#999   r_event = 8'b00000001;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000010;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000100;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00001000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00010000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00100000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b01000000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b10000000;
#1    r_event = 8'b00000000;
#(dt_on+dt_on+20)   r_event = 8'b10000000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b01000000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00100000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00010000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00001000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000100;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000010;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000001;
#1    r_event = 8'b00000000;




#1200 r_event = 8'b10000000;
#1   r_event = 8'b00000000;
#dt_on   r_event = 8'b01000000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00100000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00010000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00001000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000100;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000010;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000001;
#1    r_event = 8'b00000000;
#(dt_on+dt_on+20)   r_event = 8'b00000001;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000010;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00000100;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00001000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00010000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b00100000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b01000000;
#1    r_event = 8'b00000000;
#dt_on   r_event = 8'b10000000;
#1    r_event = 8'b00000000;



#700  r_event = 8'b01000010;
#1    r_event = 8'b00000000;
#dt_on    r_event = 8'b00100100;
#1    r_event = 8'b00000000;
#dt_on    r_event = 8'b00011000;
#1    r_event = 8'b00000000;
end


endmodule 