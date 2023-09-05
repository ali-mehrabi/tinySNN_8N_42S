`timescale 1ns/1ns
module neuron42s_tb();

parameter p_width = 8;
parameter p_shift = 8;
reg  [42:1]           r_event;
reg                   r_rst_n;
reg                   r_clk; 
reg  [42*p_width-1:0] r_weight;
reg  [p_width+p_shift+5:0] r_threshold; 
wire [42:1] w_sync;
wire [p_width+p_shift+5:0] w_neuronout,w_sv; 
integer i;

always #5 r_clk <= ~ r_clk;

initial 
begin 
  r_clk = 0;
  r_rst_n = 0;
  r_threshold = 22'h01;
  r_weight = {42{8'hff}};
  
  for(i=0; i<=42; i=i+1)
  begin
   r_event[i] = 1'b0;
  end
  
  #10  r_rst_n  = 1;
  
  #50  
  r_event[1] = 1;
  r_event[2] = 1;
  #1
  r_event[1] = 0;
  r_event[2] = 0;
  
  #500  
  r_event[1] = 1;
  r_event[2] = 1;
  r_event[10] = 1;
  r_event[20] = 1;
  r_event[30] = 1;
  r_event[40] = 1;
  #1
  r_event[1] = 0;
  r_event[2] = 0; 
  r_event[10] = 0;
  r_event[20] = 0;
  r_event[30] = 0;
  r_event[40] = 0; 
  
  #1000  
  r_event[1] = 1;
  r_event[2] = 1;
  r_event[10] = 1;
  r_event[20] = 1;
  r_event[30] = 1;
  r_event[40] = 1;
  r_event[11] = 1;
  r_event[22] = 1;
  r_event[33] = 1;
  r_event[42] = 1;
  #1
  r_event[1] = 0;
  r_event[2] = 0; 
  r_event[10] = 0;
  r_event[20] = 0;
  r_event[30] = 0;
  r_event[40] = 0; 
  r_event[11] = 0;
  r_event[22] = 0;
  r_event[33] = 0;
  r_event[42] = 0; 
#1000
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0; 
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
#10
  r_event[1] = 1;
  #1 r_event[1] = 0;
  
end


neuron42s
#(.p_width(p_width),
  .p_shift(p_shift)) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_event(r_event),
.i_weight(r_weight),
.i_threshold(r_threshold),
.o_sv(w_sv),
.o_sync(w_sync),
.o_neuronout(w_neuronout)
);
endmodule
