module delayed_reset
( 
input   i_d,
input   i_clk,
input   i_rst_n,
output  o_q
);
reg [2:0] r_counter;

wire  w_q_out1; 
//wire  w_q_out2; 
//wire  w_q_out3;
wire  w_q_bar_out3;

wire  w_clear;
wire  w_set;
wire  w_reset;
assign  w_set = (r_counter == 5)? 1:0;
assign  w_clear = w_set | ~i_rst_n; 
//assign  w_clear = w_q_out3 | ~i_rst_n;
assign  o_q = ~w_clear ;//w_q_bar_out3;
assign w_reset = i_rst_n & w_clear;

flipflop u1
( 
.i_d(1'b1),
.i_clk(i_d),
.i_clr(w_clear),
.o_q(w_q_out1),
.o_qb()
);

always @(posedge i_clk) 
begin
if(!w_q_out1)
  r_counter <= 0;
else if(w_q_out1)
  r_counter <= r_counter+1;
end

endmodule