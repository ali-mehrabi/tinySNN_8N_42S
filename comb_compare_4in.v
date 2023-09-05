`timescale 1ns/10ps
module comp_4in
#(parameter  p_width = 19)
(
input  [p_width-1:0]  i_a,
input  [p_width-1:0]  i_b,
input  [p_width-1:0]  i_c,
input  [p_width-1:0]  i_d,
output [p_width-1:0]  o_result,
output [3:0]          o_index
);

wire   [3:0]  w_l1, w_l2, w_index;
wire          w_z;
wire   [p_width-1:0] w_l3,w_l4;
assign w_z = ((i_a | i_b | i_c | i_d)==0)? 1:0;
assign w_l1 = (i_a>=i_b)? 4'b0001:4'b0010;
assign w_l2 = (i_c>=i_d)? 4'b0100:4'b1000;
assign w_index = w_z? 4'b0000:(w_l3 >= w_l4)? w_l1:w_l2;
assign o_index = w_index;
assign w_l3 = (i_a>=i_b)? i_a:i_b;
assign w_l4 = (i_c>=i_d)? i_c:i_d;
assign o_result = (w_l3 >= w_l4)? w_l3:w_l4;
endmodule 