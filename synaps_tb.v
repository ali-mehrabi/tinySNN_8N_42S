`timescale  1ns/1ns
module synapse_tb();
parameter p_width = 6;
parameter p_resbit = 10;
parameter p_spike_num = 2;
wire                      w_sync;
wire [p_width+p_resbit+p_spike_num-1:0] w_cell_out;
reg                       r_clk;
reg  		              r_rst_n;
reg                       r_event;
reg  [p_width-1:0]        r_weight;


synapse
#(
.p_width(p_width),
.p_resbit(p_resbit),
.p_spike_num(p_spike_num)) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_event(r_event),
.i_weight(r_weight),
.o_sync(w_sync),
.o_do(w_cell_out)
);

always #2 r_clk <= ~r_clk;
initial 
begin 
  r_clk = 0;
  r_rst_n =0;
  r_weight = 0; 
  r_event = 0;

#10  r_rst_n = 1;
     r_weight = 'h3ff;
#20  r_event = 1;
#1   r_event = 0;

#500;
     r_weight = 'h0fe;
#25  r_event = 1;
#1   r_event = 0;

#500 r_weight = 'h10b;
#21 r_event = 1;
#1  r_event = 0;

#200 r_weight = 'ha4;
#22  r_event = 1;
#1   r_event = 0;

#200 r_weight = 'h7f;
#22  r_event = 1;
#1   r_event = 0;
#10  r_event = 1;
#1   r_event = 0;

#200 r_weight = 'h7f;
#22  r_event = 1;
#1   r_event = 0;
#22  r_event = 1;
#1   r_event = 0;
end


endmodule 