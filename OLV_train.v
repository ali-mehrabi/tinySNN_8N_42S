`timescale 1ns/10ps
module OLV_train
#(
parameter p_width = 8,
parameter p_resbit = 8,
parameter p_n = 8,
parameter p_s = 42,
parameter p_deltaT = 'hff,
parameter p_eta = 8, 
parameter p_default_thr = 'h3f000,
parameter p_default_w = 'hff)
(
 input                                  i_clk,
 input                                  i_rst_n,
 input  [p_n:1]                         i_lvl_spikeout,
 input  [p_s:1]                         i_syncout,
 input                                  i_endof_epochs, 
 input  [p_n*(p_width+p_resbit+6)-1:0]  i_sv,
 output [p_n*(p_s*p_width)-1:0]         o_weights,
 output [p_n*(p_width+p_resbit+6)-1:0]  o_thresholds
);

parameter p_thr_width = p_width+p_resbit+6;
parameter p_wait_clks = 10;
parameter p_pass_lvl_1 = 2;
parameter p_z = 8-$clog2(p_eta);
genvar    i;
genvar    j;
integer   s;
integer   n;

wire  [p_n*(p_s*p_width)-1:0] w_weights;
wire                          w_input_event_on;
wire                          w_pass_l1;
wire                          w_spikeout;
wire  [p_thr_width-1:0]       w_sv[p_n:1];
wire  [p_thr_width-1:0]       w_lv[p_n:1];
wire  [p_width-1:0]           w_ts[p_s:1];
reg   [p_width-1:0]           r_w[p_n:1][p_s:1];
reg   [p_thr_width-1:0] 	  r_threshold[p_n:1];
reg   [p_width-1:0]           r_ts[p_s:1];
//reg                       	  r_gas;
reg                       	  r_training_active;
reg   [p_n:1]                 r_winner;
reg   [2:0]                	  r_state;
reg                      	  r_stop_n;
reg   [$clog2(p_wait_clks):0] r_counter;


function [p_width-1:0] calwt;
input [p_width-1:0]     a;
input [p_width-1:0]     b;
reg   [(p_width+8)-1:0] c;
begin
  c = {a,8'b0}- {a, {p_z{1'b0}}} + {b, {p_z{1'b0}}} ;
  calwt = c[(p_width+8)-1:8];
end	
endfunction	

function [p_thr_width-1:0] calth;
input [p_thr_width-1:0] a,b; 
reg   [p_thr_width+8-1:0] c;
begin
  c = {a,8'b0}- {a,{p_z{1'b0}}} + {b, {p_z{1'b0}}};
  calth = c[(p_thr_width+8)-1:8]; 
end	
endfunction	

assign w_spikeout = i_lvl_spikeout[1] ^ i_lvl_spikeout[2] ^ i_lvl_spikeout[3] ^ i_lvl_spikeout[4];

generate

for(i=1;i<= p_n;i=i+1)
begin: gen_w_lv
  assign  w_sv[i] = i_sv[i*(p_thr_width)-1: (i-1)*(p_thr_width)];
end

for(i=1;i<= p_n;i=i+1)
  begin: gen_lv_reg
	lv_reg
	#(.p_width(p_thr_width)) u_lv
	(
		.i_spike(i_lvl_spikeout[i]),
		.i_rst_n(i_rst_n),
		.i_sv(w_sv[i]),
		.o_lv(w_lv[i])
	);
  end
  
for(i=1;i<= p_s;i=i+1)
  begin:gen_tracer
    tracer
	#(.p_width(p_width))  u_trace
	(
	.i_event(i_syncout[i]),
	.i_rst_n(i_rst_n),
	.i_clk(i_clk),
	.o_trace(w_ts[i])
	);
  end
  
for(j=1; j<=p_n; j=j+1)
  begin
	for(i=1; i<=p_s; i=i+1)
	  begin
		assign w_weights[((j-1)*p_s+i)*p_width - 1 : ((j-1)*p_s + i-1)*p_width] = r_w[j][i];
	  end
  end
 
for(i=1;i<=p_n;i=i+1) 
  begin:gen_latch_r_winner
	always @(posedge i_lvl_spikeout[i] or negedge r_stop_n) 
	begin
	  if(!r_stop_n)
		  r_winner[i] <= 1'b0;
	  else 
		  r_winner[i] <= 1'b1; 
	end 
  end
 
endgenerate


always @(posedge w_spikeout or negedge i_rst_n)
   begin	
	 if(!i_rst_n)
		begin
		  for(s = 1; s<= p_s; s=s+1)
		     r_ts[s] <= {(p_width){1'b0}};		
		end
	  else
		begin
		  for(s = 1; s<= p_s; s=s+1)
		     r_ts[s] <= w_ts[s];	
		end
   end

assign #1 w_input_event_on  = (i_syncout == 0) ? 0:1;
assign #3 o_thresholds = {r_threshold[8], r_threshold[7],r_threshold[6], r_threshold[5],r_threshold[4], r_threshold[3],r_threshold[2], r_threshold[1]};
assign #2 w_pass_l1 = (r_counter >= p_pass_lvl_1)? 1:0;
assign #3 o_weights = w_weights;
always @(posedge i_clk or negedge i_rst_n) 
begin
  if(!i_rst_n)
     r_stop_n <= 1'b0;
  else 
    if(r_counter >= p_wait_clks) 
      #1 r_stop_n <= 1'b0;
    else
      #1 r_stop_n <= 1'b1; 
end

always @(posedge w_input_event_on or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_training_active <= 1'b0;
  else
    r_training_active <= 1'b1;
end

always @(posedge ~i_clk or negedge r_stop_n)
begin 
   if(!r_stop_n)
     r_counter <= 0;
   else if(r_training_active && !i_endof_epochs)
     r_counter <= r_counter +1; 
end	
//modified for unsupervised learning i_gas =1 
/*always @(posedge w_input_event_on or negedge r_stop_n)
begin
  if(!r_stop_n)
    r_gas <= 1'b0;
  else 
    r_gas <= 1'b1;
end*/

//main state machine
always@(posedge i_clk or negedge i_rst_n)
begin 
  if(!i_rst_n)
    begin
	for(n=1; n<=p_n; n=n+1)
	  begin
	    r_threshold[n] <= p_default_thr;
	    for(s=1; s<=p_s; s=s+1)
		  begin
	        r_w[n][s] <= p_default_w;
          end
	  end	  
	  r_state <= 0;
	end  
  else
     case(r_state)
	  0:begin
	      if(w_pass_l1) 
		    r_state<= 1;
	    end	 
	  1:begin
		  for(n=1; n<=p_n; n=n+1)
			begin			
			  if(r_winner[n])
				begin
				   r_threshold[n] <= calth(r_threshold[n] ,w_lv[n]);
				  for(s=1; s<=p_s; s=s+1)
					begin
					  r_w[n][s] <= calwt(r_w[n][s], r_ts[s]);
					end
				end
			end
		  if (r_winner == 0)
		   begin
			for(n=1; n<=p_n; n=n+1)
			  begin
				r_threshold[n] <= (r_threshold[n]> p_deltaT)? (r_threshold[n] - p_deltaT):0;
			  end	
		   end		  
		   r_state <= 2;			
	    end
	  2:begin
	    if(!r_stop_n) 
		    r_state <= 0;
	    end
      endcase
end	
  
endmodule