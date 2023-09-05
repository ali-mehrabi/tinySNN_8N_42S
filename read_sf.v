module read_samples_from_file();

reg        r_clk;
reg        r_start;
reg        r_rst_n; 
reg [42:1] r_data;
reg [42:1] mem[9000:0];
integer  i;
initial 
begin
r_clk = 0;
r_rst_n = 0;
r_data = 0;
r_start = 0;
i=0;
#50  r_start = 1;
#500
r_rst_n = 1;
end

initial 
begin
//if(r_start == 1) 
   $readmemh("sample_eT1.mem", mem);
end

always #1 r_clk = ~r_clk;

always @(negedge r_clk) 
begin
  if( r_rst_n == 1)
    begin
	  if(i <9000) 
		begin
		   r_data = mem[i];
		   i <= i+1;
		end
	end
end
endmodule