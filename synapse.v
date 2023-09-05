`timescale 1ns/10ps
module synapse 
#(
parameter p_width = 8,
parameter p_resbit = 8)
(
input                           i_event,
input                           i_rst_n,
input                           i_clk,
input   [p_width-1:0]           i_weight,
output                          o_sync,
output  [p_width+p_resbit-1:0]  o_do
);

wire   w_clr;
wire   w_sync;
wire  [p_width+p_resbit-1:0]  w_do;
assign #1 o_do = w_do;
assign #1 o_sync = w_sync;

synchronizer u_sync
(
.i_event(i_event),
.i_clk(i_clk),
.i_clr(w_clr),
.o_syncout(w_sync)
);


wlif
#(.p_width(p_width),
  .p_nbit(p_resbit)) u_lif
(
.i_event(w_sync),
.i_rst_n(i_rst_n),
.i_clk(i_clk),
.i_weight(i_weight),
.o_clr(w_clr),
.o_do(w_do)
);

endmodule