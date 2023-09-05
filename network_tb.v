`timescale 1ns/1ns
module  network_tb();
reg         r_clk;
reg         r_rst_n;
wire  [8:1] w_output_spike;
wire  w_cnt_clk;
wire  w_avg_clk;
reg  [7:0] r_cnt;
reg  [7:0] r_avg, avg;
reg r_flg;
parameter p_avg = 199;

network u_network_test
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.o_output_spike(w_output_spike)
);

initial
begin 
     r_clk = 0;
     r_rst_n = 0;
#10  r_rst_n = 1; 
end


reg [1:0]  r_state;
reg        r_frame_clk; 
reg [1:0]  r_delay;
wire       w_rst;
always #8 r_clk = ~ r_clk;

assign w_cnt_clk = (u_network_test.u_network.i_event != 0)? 1:0;
assign w_avg_clk = (u_network_test.u_network.o_spike != 0)? 1:0;

always @(posedge w_cnt_clk or negedge r_rst_n) 
begin
  if(!r_rst_n) 
    begin
      r_cnt <= 0; 
	  r_flg <= 0;
    end	 
  else if(r_cnt <p_avg) 
    begin
      r_cnt <= r_cnt+1; 
	  r_flg <= 1;
	end
  else 
    begin
      r_cnt <= 0;
      r_flg <= 0;
	end
end
assign w_rst = r_rst_n & !r_frame_clk; 
always @(posedge w_avg_clk or negedge w_rst) 
begin
  if(!w_rst) 
   r_avg <= 0; 
  else  
   r_avg <= r_avg+1; 
end

always @(posedge r_clk or negedge r_rst_n) 
begin
  if(!r_rst_n) 
    begin
      r_state <= 0;	
	  r_frame_clk <= 0;
	  r_delay <= 0;
	end
  else 
    case(r_state) 
      0:begin
	      if((r_cnt == p_avg)  && w_cnt_clk)
		    begin
		      r_state <= 1;
			end  
	    end
	  1:begin
	      if(r_delay == 3) 
		     r_state <= 2;
		  else 
   		    r_delay <= r_delay+1;
	    end
      2:begin
	      r_frame_clk <= 1;
		  r_state <= 3;
	    end
	  3:begin
	      r_frame_clk <= 0;
		  r_state <= 0;
	    end
    endcase		
end


always @(posedge r_frame_clk)
begin
  avg <= r_avg[7:1];
end
endmodule