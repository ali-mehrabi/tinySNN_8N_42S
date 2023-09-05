`timescale  1ns/1ns

module wlif_tb();
parameter p_width= 8;
parameter p_resbit = 6;

reg                   r_event;
reg                   r_rst_n;
reg                   r_clk; 
reg  [p_width-1:0]    r_weight;
wire                  w_clr;
wire [p_width-1:0]    w_do;


wlif
#(.p_width(p_width),
  .p_nbit(p_resbit)
) uut
(
.i_event(r_event),
.i_rst_n(r_rst_n),
.i_clk(r_clk),
.i_weight(r_weight),
.o_clr(w_clr),
.o_do(w_do)
);


always #1 r_clk <= ~r_clk;
initial 
begin 
  r_clk = 0;
  r_rst_n = 0;
  r_weight = 0; 
  r_event = 0;

#10  r_rst_n = 1;
     r_weight = 'h3ff;
#20  r_event = 1;
#2   r_event = 0;

#200;
#25  r_event = 1;
#2   r_event = 0;

#500 r_weight = 'h10b;
#21  r_event = 1;
#2   r_event = 0;


#500 r_weight = 'ha4;
#22  r_event = 1;
#2   r_event = 0;
#4  r_event = 1;
#2   r_event = 0;


#500 r_weight = 'hf4;
#23  r_event = 1;
#2   r_event = 0;
#16  r_event = 1;
#2   r_event = 0;


#400 r_weight = 'hf4;
#50   r_event = 1;
#2    r_event = 0;
#40   r_event = 1;
#2    r_event = 0;
#50   r_event = 1;
#2    r_event = 0;
#100  r_event = 1;
#2    r_event = 0;
#200  r_event = 1;
#2    r_event = 0;
#40   r_event = 1;
#2    r_event = 0;
#300  r_event = 1;
#2    r_event = 0;
#500  r_event = 1;
#2    r_event = 0;
#50   r_event = 1;
#2    r_event = 0;
#50   r_event = 1;
#2    r_event = 0;
#50   r_event = 1;
#2    r_event = 0;
#50   r_event = 1;
#2    r_event = 0;
#50   r_event = 1;
#2    r_event = 0;
#800  r_event = 1;
#2    r_event = 0;
#5   r_event = 1;
#2    r_event = 0;
#5   r_event = 1;
#2    r_event = 0;
#5   r_event = 1;
#2    r_event = 0;
#5   r_event = 1;
#2    r_event = 0;
#5   r_event = 1;
#2    r_event = 0;
end


endmodule 