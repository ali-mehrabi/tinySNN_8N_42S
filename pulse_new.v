module pulse_new(
input      [8:1] i_index,
input            i_spike,
input            i_clk,
input            i_rst_n,
output     [8:1] o_spike
);

parameter  p_pass_delay = 3;
wire       w_q1, w_q2;
wire       w_is_spike;
wire       w_is_spike_latched;
reg       r_rst;
reg [1:0] r_state;
reg [2:0] r_counter;


assign o_spike = (r_state==1)? i_index:0; 
assign w_rst = ~r_rst ;
assign w_is_spike = (i_index == 0) ? 0:1;


flipflop u_i_spike_latch
( 
	.i_d(1'b1),
	.i_clk(i_spike),
	.i_clr(r_rst),
	.o_q(w_q1),
	.o_qb()
);

flipflop u_index_latch
( 
	.i_d(w_is_spike),
	.i_clk(i_clk),
	.i_clr(r_rst),
	.o_q(w_is_spike_latched),
	.o_qb()
);

always@(posedge i_clk or negedge w_rst)
begin
  if(!w_rst) 
    r_counter <= 3'b0;
  else if(w_q1)
    r_counter <= r_counter +1;
end

always@(posedge i_clk or negedge i_rst_n)
begin
  if(!i_rst_n) 
    begin
      r_rst <= 1; 
	  r_state <= 0; 
	  r_counter <= 3'b0;
	end
  else
    begin
       case(r_state)
	    0:begin
		    r_rst <= 0;
		    if(w_is_spike_latched & w_q1)
			  r_state <= 1;
			else if (r_counter >=3'b010)
			  r_state <= 2;
		  end
	    1:begin
		    r_rst <= 1;
		  end
	    2:begin
		    r_state <= 0;
			r_rst <= 1;
		  end		  
       endcase		  
    end	
end

endmodule

