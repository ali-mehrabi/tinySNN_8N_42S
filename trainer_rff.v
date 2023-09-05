// Does network training for 100 epochs with sample_eT1 dataset and then 
// injects sample_eT1... sample_eT4 datasets to the network.
module auto_trainer
#(
parameter  p_test_len = 9000,
parameter  p_spike_delay = 3,
parameter  p_pattern_delay = 100,
parameter  p_epochs = 100
)
(
input         i_clk,
input         i_rst_n,
output        o_end_of_epochs,
output [42:1] o_test_vector
);

parameter   p_sample_len = 8;
reg                                r_end_of_epochs;
reg   [2:0]                        r_state; 
reg   [$clog2(p_test_len-1):0]     r_address; 
reg   [42:1]                       r_data;
reg   [$clog2(p_pattern_delay):0]  r_counter;
reg   [$clog2(p_epochs):0]         r_epochs;
reg   [42:1]                       r_ram1[p_test_len-1:0]; 
reg   [42:1]                       r_ram2[p_test_len-1:0]; 
reg   [42:1]                       r_ram3[p_test_len-1:0]; 
reg   [42:1]                       r_ram4[p_test_len-1:0]; 
reg   [1:0]                        r_sample_frame;
reg   [$clog2(p_epochs):0]         r_epochs_num;
assign o_test_vector = r_data;
assign o_end_of_epochs = r_end_of_epochs;

initial 
begin 
  $readmemh("sample_eT1.mem", r_ram1);
  $readmemh("sample_eT2.mem", r_ram2);
  $readmemh("sample_eT3.mem", r_ram3);
  $readmemh("sample_eT4.mem", r_ram4);  
end
always @(posedge ~i_clk or negedge i_rst_n) 
begin 
if(!i_rst_n) 
  begin
    r_state   <= 0; 
	r_data    <= 0; 
	r_counter <= 0;
	r_address <= 0;
	r_epochs  <= 1;
	r_end_of_epochs <= 0;
	r_sample_frame <= 0;
	r_epochs_num <= p_epochs;
  end
else 
   case(r_state) 
    0:begin 
	    if(r_counter < p_pattern_delay) 
		   r_counter <= r_counter+1;
		else 
		  begin
		    r_counter <= 0;
			r_state <= 1;
		  end
	  end
	1:begin
	    if (r_sample_frame ==0) 
           r_data <= r_ram1[r_address];
		else if (r_sample_frame ==1)
		   r_data <= r_ram2[r_address];
		else if (r_sample_frame ==2)
		   r_data <= r_ram3[r_address];
		else if (r_sample_frame ==3)
		   r_data <= r_ram4[r_address];
		r_state <= 2;
      end	
	2:begin
		r_data <= 0;
	    if(r_counter < p_spike_delay) 
		   r_counter <= r_counter+1;
		else 
		  begin
		    r_counter <= 0;
			r_state <= 3;
		  end
	  end	  
	3:begin
		if(r_address < (p_test_len-1)) 
           begin		
			 r_address <= r_address+1;
			 r_state <= 1;
		   end
	    else
		  begin
		   if(r_epochs < r_epochs_num) 
		     begin
		       r_epochs <= r_epochs+1;
			   r_address <= 0;
		       r_state <= 0;
		     end
		   else
		     begin
   		       r_end_of_epochs <=1;		 
			   r_state <= 4;
			 end
		  end	
	  end	  
	4:begin
	    r_epochs <= 1;
		r_address <= 0;
	    r_sample_frame <= r_sample_frame+1;
		r_epochs_num <= 50;
		r_state <= 0;
	  end
   endcase
end

endmodule