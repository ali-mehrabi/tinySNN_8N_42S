`timescale 1ns/10ps
module comparator_4in
#(parameter  p_width = 19)
(
input  i_clk,
input  i_rst_n,
input  [p_width-1:0]  i_a,
input  [p_width-1:0]  i_b,
input  [p_width-1:0]  i_c,
input  [p_width-1:0]  i_d,
output [p_width-1:0]  o_result,
output [3:0]          o_index
);

wire  [3:0]          w_l1, w_l2, w_index;
wire  [p_width-1:0]  w_l3,w_l4;
wire                 w_z;
wire                 w_t1, w_t2, w_t3;
reg   [3:0]          r_index;

assign      w_t1 = (i_a>=i_b)? 1:0; 
assign      w_t2 = (i_c>=i_d)? 1:0; 
assign      w_t3 = (w_l3 >= w_l4)? 1:0; 
assign      w_z  = (~(i_a | i_b | i_c | i_d))? 1:0;
assign      w_l1 = w_t1? 4'b0001:4'b0010;
assign      w_l2 = w_t2? 4'b0100:4'b1000;
assign      w_index =  w_z? 4'b0000:w_t3? w_l1:w_l2;
assign      w_l3 = w_t1? i_a:i_b;
assign      w_l4 = w_t2? i_c:i_d;
assign      o_result =  w_t3? w_l3:w_l4;
assign      o_index =   w_index;
/*
wire   w_clk_n;
assign w_clk_n = ~i_clk;
always @( posedge i_clk or negedge i_rst_n)
begin
if(!i_rst_n) 
  r_index <= 0;
else 
  r_index <= w_index;
end
*/
endmodule 