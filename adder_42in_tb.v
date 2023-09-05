module  adder_42in_tb();
parameter p_input_width = 16;

reg [p_input_width-1:0] r_a[10:1];
wire [p_input_width+5:0] w_s;

initial 
begin
r_a[1] = 16'h0001;
r_a[2] = 16'h0001;
r_a[3] = 16'h0001;
r_a[4] = 16'h0001;
r_a[5] = 16'h0001;
r_a[6] = 16'h0001;
r_a[7] = 16'h0001;
r_a[8] = 16'h0001;
r_a[9] = 16'h0001;
r_a[10] = 16'h0001;
#10
r_a[1] = 16'hffff;
r_a[2] = 16'hffff;
r_a[3] = 16'hffff;
r_a[4] = 16'hffff;
r_a[5] = 16'hffff;
r_a[6] = 16'hffff;
r_a[7] = 16'hffff;
r_a[8] = 16'hffff;
r_a[9] = 16'hffff;
r_a[10] = 16'hffff;
#10
r_a[1] = 16'hf001;
r_a[2] = 16'h0f01;
r_a[3] = 16'h0001;
r_a[4] = 16'h00f1;
r_a[5] = 16'h000f;
r_a[6] = 16'h00f1;
r_a[7] = 16'h0ff1;
r_a[8] = 16'hfff1;
r_a[9] = 16'hf00f;
r_a[10] = 16'habcd;

#100
r_a[1] = 16'h01ef;
r_a[2] = 16'habcd;
r_a[3] = 16'h6789;
r_a[4] = 16'h2345;
r_a[5] = 16'hdef1;
r_a[6] = 16'h9abc;
r_a[7] = 16'h5678;
r_a[8] = 16'h1234;
r_a[9] = 16'hef00;
r_a[10] = 16'habcd;

end


adder_42in
#(.p_input_width(p_input_width)) uut
(
.i_a01(r_a[1]),
.i_a02(r_a[2]),
.i_a03(r_a[3]),
.i_a04(r_a[4]),
.i_a05(r_a[5]),
.i_a06(r_a[6]),
.i_a07(r_a[7]),
.i_a08(r_a[8]),
.i_a09(r_a[9]),
.i_a10(r_a[10]),
.i_a11(r_a[1]),
.i_a12(r_a[2]),
.i_a13(r_a[3]),
.i_a14(r_a[4]),
.i_a15(r_a[5]),
.i_a16(r_a[6]),
.i_a17(r_a[7]),
.i_a18(r_a[8]),
.i_a19(r_a[9]),
.i_a20(r_a[10]),
.i_a21(r_a[1]),
.i_a22(r_a[2]),
.i_a23(r_a[3]),
.i_a24(r_a[4]),
.i_a25(r_a[5]),
.i_a26(r_a[6]),
.i_a27(r_a[7]),
.i_a28(r_a[8]),
.i_a29(r_a[9]),
.i_a30(r_a[10]),
.i_a31(r_a[1]),
.i_a32(r_a[2]),
.i_a33(r_a[3]),
.i_a34(r_a[4]),
.i_a35(r_a[5]),
.i_a36(r_a[6]),
.i_a37(r_a[7]),
.i_a38(r_a[8]),
.i_a39(r_a[9]),
.i_a40(r_a[10]),
.i_a41(r_a[1]),
.i_a42(r_a[2]),
.o_s(w_s)
);





endmodule