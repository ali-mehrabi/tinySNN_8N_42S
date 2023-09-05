`timescale 1ns/10ps 
module comparator_8in
#(parameter  p_width = 19)
(
input  i_clk,
input  i_rst_n,
input  [p_width-1:0]  i_a,
input  [p_width-1:0]  i_b,
input  [p_width-1:0]  i_c,
input  [p_width-1:0]  i_d,
input  [p_width-1:0]  i_e,
input  [p_width-1:0]  i_f,
input  [p_width-1:0]  i_g,
input  [p_width-1:0]  i_h,
output [p_width-1:0]  o_result,
output [7:0]          o_index
);

wire  [3:0]  w_l1, w_l2; 
wire  [7:0]  w_index;
reg   [7:0]  r_index;
wire  [p_width-1:0] w_l3,w_l4;


comp_4in
#(.p_width(p_width)) u1
(
.i_a(i_a),
.i_b(i_b),
.i_c(i_c),
.i_d(i_d),
.o_result(w_l3),
.o_index(w_l1)
);

comp_4in
#(.p_width(p_width)) u2
(
.i_a(i_e),
.i_b(i_f),
.i_c(i_g),
.i_d(i_h),
.o_result(w_l4),
.o_index(w_l2)
);
wire w_z, w_gt; 
wire   w_clk_n;
assign w_clk_n = ~i_clk;
assign #2 w_gt = (w_l3 >= w_l4)? 1'b1:1'b0;
assign #2 w_z  = ((w_l3 | w_l4)==0 )? 1:0; 
assign  o_result = w_gt? w_l3:w_l4;
assign  w_index  = w_z? 0: w_gt? {4'b0000, w_l1}:{w_l2, 4'b0000};
assign  o_index = r_index;

always @(posedge i_clk or negedge i_rst_n)
begin
if(!i_rst_n) 
  r_index <= 0;
else 
  r_index <= w_index;
end

endmodule 