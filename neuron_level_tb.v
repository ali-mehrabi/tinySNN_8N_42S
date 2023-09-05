module neuron_level_tb();

parameter p_width = 8;
parameter p_shift = 8;
parameter p_n = 4;

reg  [42:1]           r_event;
reg                   r_rst_n;
reg                   r_clk; 
reg  [p_n*42*p_width-1: 0]        r_weight;
reg  [p_n*(p_width+p_shift+6)-1:0]  r_threshold; 
wire [42:1]                       w_sync;
wire [4:1]                        w_spike;
wire [p_width+p_shift+5:0]        w_neuronout; 
integer i;



always #1 r_clk <= ~ r_clk;

initial 
begin 
  r_clk = 0;
  r_rst_n = 0;
  r_threshold = {22'h01, 22'h01, 22'h01, 22'h01};
  r_weight = {(p_n*42*p_width){1'b1}};
  r_event = 0;  
 
  #10  r_rst_n  = 1;
  r_threshold = {22'hfffff, 22'h1e01b, 22'hfffff, 22'hfffff};
  #50  
  r_event[1] = 1;
  r_event[2] = 1;
  #1
  r_event[1] = 0;
  r_event[2] = 0;
  
  #500  r_threshold = {22'hfffff, 22'hfffff, 22'h5dc00, 22'hfffff};
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
  
  
  #1000  r_threshold = {22'hfffff, 22'hfffff, 22'hfffff, 22'h9c430};
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
#1000  r_threshold = {22'hff, 22'hfffff, 22'hfffff, 22'hfffff};
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

neuron_level
#(.p_width(p_width),
  .p_shift(p_shift),
  .p_n(4)) uut
(
.i_clk(r_clk),
.i_rst_n(r_rst_n),
.i_event(r_event),
.i_weight(r_weight),
.i_threshold(r_threshold),
.o_sync(w_sync),
.o_spike(w_spike)
);


endmodule