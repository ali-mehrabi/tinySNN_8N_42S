module  adder_42in
#(parameter p_input_width = 16)
(
input  [p_input_width-1:0]  i_a01,
input  [p_input_width-1:0]  i_a02,
input  [p_input_width-1:0]  i_a03,
input  [p_input_width-1:0]  i_a04,
input  [p_input_width-1:0]  i_a05,
input  [p_input_width-1:0]  i_a06,
input  [p_input_width-1:0]  i_a07,
input  [p_input_width-1:0]  i_a08,
input  [p_input_width-1:0]  i_a09,
input  [p_input_width-1:0]  i_a10,
input  [p_input_width-1:0]  i_a11,
input  [p_input_width-1:0]  i_a12,
input  [p_input_width-1:0]  i_a13,
input  [p_input_width-1:0]  i_a14,
input  [p_input_width-1:0]  i_a15,
input  [p_input_width-1:0]  i_a16,
input  [p_input_width-1:0]  i_a17,
input  [p_input_width-1:0]  i_a18,
input  [p_input_width-1:0]  i_a19,
input  [p_input_width-1:0]  i_a20,
input  [p_input_width-1:0]  i_a21,
input  [p_input_width-1:0]  i_a22,
input  [p_input_width-1:0]  i_a23,
input  [p_input_width-1:0]  i_a24,
input  [p_input_width-1:0]  i_a25,
input  [p_input_width-1:0]  i_a26,
input  [p_input_width-1:0]  i_a27,
input  [p_input_width-1:0]  i_a28,
input  [p_input_width-1:0]  i_a29,
input  [p_input_width-1:0]  i_a30,
input  [p_input_width-1:0]  i_a31,
input  [p_input_width-1:0]  i_a32,
input  [p_input_width-1:0]  i_a33,
input  [p_input_width-1:0]  i_a34,
input  [p_input_width-1:0]  i_a35,
input  [p_input_width-1:0]  i_a36,
input  [p_input_width-1:0]  i_a37,
input  [p_input_width-1:0]  i_a38,
input  [p_input_width-1:0]  i_a39,
input  [p_input_width-1:0]  i_a40,
input  [p_input_width-1:0]  i_a41,
input  [p_input_width-1:0]  i_a42,
output [p_input_width+5:0]  o_s
);

wire [p_input_width+1:0]  w_s[10:1];
wire [p_input_width+3:0]  w_s2[13:11];
wire [p_input_width+3:0]  w_s3;
wire [p_input_width+4:0]  w_c3;

wire [p_input_width-1:0]  i_a[10:1];
wire [p_input_width-1:0]  i_b[10:1];
wire [p_input_width-1:0]  i_c[10:1];
wire [p_input_width-1:0]  i_d[10:1];

assign i_a[1] = i_a01;
assign i_a[2] = i_a02;
assign i_a[3] = i_a03;
assign i_a[4] = i_a04;
assign i_a[5] = i_a05;
assign i_a[6] = i_a06;
assign i_a[7] = i_a07;
assign i_a[8] = i_a08;
assign i_a[9] = i_a09;
assign i_a[10] = i_a10;
assign i_b[1] = i_a11;
assign i_b[2] = i_a12;
assign i_b[3] = i_a13;
assign i_b[4] = i_a14;
assign i_b[5] = i_a15;
assign i_b[6] = i_a16;
assign i_b[7] = i_a17;
assign i_b[8] = i_a18;
assign i_b[9] = i_a19;
assign i_b[10] = i_a20;
assign i_c[1] = i_a21;
assign i_c[2] = i_a22;
assign i_c[3] = i_a23;
assign i_c[4] = i_a24;
assign i_c[5] = i_a25;
assign i_c[6] = i_a26;
assign i_c[7] = i_a27;
assign i_c[8] = i_a28;
assign i_c[9] = i_a29;
assign i_c[10] = i_a30;
assign i_d[1] = i_a31;
assign i_d[2] = i_a32;
assign i_d[3] = i_a33;
assign i_d[4] = i_a34;
assign i_d[5] = i_a35;
assign i_d[6] = i_a36;
assign i_d[7] = i_a37;
assign i_d[8] = i_a38;
assign i_d[9] = i_a39;
assign i_d[10] = i_a40;


genvar i;

generate
for(i =1; i<=10; i=i+1)
begin:u_gen_adder
	csa_adder_4in
	#(.p_input_width(p_input_width)) u_adder_s1i
	(
	.i_a(i_a[i]),
	.i_b(i_b[i]),
	.i_c(i_c[i]),
	.i_d(i_d[i]),
	.o_s(w_s[i])
	);
end
endgenerate

csa_adder_4in
	#(.p_input_width(p_input_width+2)) u_adder_s21
	(
	.i_a(w_s[1]),
	.i_b(w_s[2]),
	.i_c(w_s[3]),
	.i_d(w_s[4]),
	.o_s(w_s2[11])
	);

csa_adder_4in
	#(.p_input_width(p_input_width+2)) u_adder_s22
	(
	.i_a(w_s[5]),
	.i_b(w_s[6]),
	.i_c(w_s[7]),
	.i_d(w_s[8]),
	.o_s(w_s2[12])
	);

wire [p_input_width+1:0] w_i_a41, w_i_a42;
assign  w_i_a41 = {2'b0, i_a41};
assign  w_i_a42 = {2'b0, i_a42};
csa_adder_4in
	#(.p_input_width(p_input_width+2)) u_adder_s23
	(
	.i_a(w_s[9]),
	.i_b(w_s[10]),
	.i_c(w_i_a41),
	.i_d(w_i_a42),
	.o_s(w_s2[13])
	);
	
assign w_s3 = w_s2[11]^w_s2[12]^w_s2[13]; 
assign w_c3 = {((w_s2[11] & w_s2[12]) | (w_s2[12] & w_s2[13]) | (w_s2[11] & w_s2[13])), 1'b0};
assign o_s = {2'b0, w_s3} + {1'b0, w_c3}; 

endmodule
