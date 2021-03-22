/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*

module FU_LeftCircularShift_jamahl29(R, B, C, V, N, Z);
	input [7:0] B; 
	
	output [7:0] R;	
	output C, V, N, Z;
	
	assign R = { B[6:0], B[7] };	
	assign C = 1'b0;
	assign V = 1'b0;
	assign N = 1'b0;
	assign Z = 1'b0;
	
endmodule
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
module FU_RightCircularShift_jamahl29(R, B, C, V, N, Z);
	input [7:0] B;
	
	output [7:0] R;	
	output C, V, N, Z;
	
	assign R = { B[0], B[7:1] };
	assign C = 1'b0;
	assign V = 1'b0;
	assign N = 1'b0;
	assign Z = 1'b0;
	
endmodule
	
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module add_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;
	
   
   wire   w1;
   wire   w2;
   wire   w3;
   wire   w4;
   
   xor(w1, A, B);
   xor(S, Cin, w1);
   and(w2, A, B);   
   and(w3, A, Cin);
   and(w4, B, Cin);   
   or(Cout, w2, w3, w4);
endmodule // full_adder

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_add_jamahl29(S, C, V, N, Z, A, B);
	output [7:0] S;   // The 4-bit sum/difference.
   output 	C;   // The 1-bit carry/borrow status.
   output 	V;   // The 1-bit overflow status.
	output N, Z;
   input [7:0] 	A;   // The 4-bit augend/minuend.
   input [7:0] 	B;   // The 4-bit addend/subtrahend.
   wire 	Op;  // The operation: 0 => Add, 1=>Subtract.
   assign Op = 1'b0;
	
   wire 	C0; // The carry out bit of fa0, the carry in bit of fa1.
   wire 	C1; // The carry out bit of fa1, the carry in bit of fa2.
   wire 	C2; // The carry out bit of fa2, the carry in bit of fa3.
   wire 	C3; // The carry out bit of fa2, used to generate final carry/borrrow.
	wire C4, C5, C6, C7;
   
   wire 	B0; // The xor'd result of B[0] and Op
   wire 	B1; // The xor'd result of B[1] and Op
   wire 	B2; // The xor'd result of B[2] and Op
   wire 	B3; // The xor'd result of B[3] and Op
	wire B4, B5, B6, B7;

	
   // Looking at the truth table for xor we see that  
   // B xor 0 = B, and
   // B xor 1 = not(B).
   // So, if Op==1 means we are subtracting, then
   // adding A and B xor Op alog with setting the first
   // carry bit to Op, will give us a result of
   // A+B when Op==0, and A+not(B)+1 when Op==1.
   // Note that not(B)+1 is the 2's complement of B, so
   // this gives us subtraction.   
	
   xor(B0, B[0], Op);
   xor(B1, B[1], Op);
   xor(B2, B[2], Op);
   xor(B3, B[3], Op);
	xor(B4, B[4], Op);
	xor(B5, B[5], Op);
	xor(B6, B[6], Op);
	xor(B7, B[7], Op);
  
   
   add_adder fa0(S[0], C0, A[0], B0, Op);    // Least significant bit.
   add_adder fa1(S[1], C1, A[1], B1, C0);
   add_adder fa2(S[2], C2, A[2], B2, C1);
   add_adder fa3(S[3], C3, A[3], B3, C2);    // Most significant bit.
	add_adder fa4(S[4], C4, A[4], B4, C3);
	add_adder fa5(S[5], C5, A[5], B5, C4);
	add_adder fa6(S[6], C6, A[6], B6, C5);
	add_adder fa7(S[7], C7, A[7], B7, C6);
	
	xor(C, C7, Op);     // Carry = C3 for addition, Carry = not(C3) for subtraction.
   xor(V, C7, C6);     // If the two most significant carry output bits differ, then we have an overflow.
	assign N = (S[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( S == 8'b00000000 ) ? 1'b1 : 1'b0;
	
endmodule // ripple_carry_adder_subtractor

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_subtractor_jamahl29(S, C, V, N, Z, A, B);
   output [7:0] S;   // The 4-bit sum/difference.
   output 	C;   // The 1-bit carry/borrow status.
   output 	V;   // The 1-bit overflow status.
	output N, Z;
   input [7:0] 	A;   // The 4-bit augend/minuend.
   input [7:0] 	B;   // The 4-bit addend/subtrahend.
   wire 	Op;  // The operation: 0 => Add, 1=>Subtract.
   assign Op = 1'b1;
	
   wire 	C0; // The carry out bit of fa0, the carry in bit of fa1.
   wire 	C1; // The carry out bit of fa1, the carry in bit of fa2.
   wire 	C2; // The carry out bit of fa2, the carry in bit of fa3.
   wire 	C3; // The carry out bit of fa2, used to generate final carry/borrrow.
	wire C4, C5, C6, C7;
   
   wire 	B0; // The xor'd result of B[0] and Op
   wire 	B1; // The xor'd result of B[1] and Op
   wire 	B2; // The xor'd result of B[2] and Op
   wire 	B3; // The xor'd result of B[3] and Op
	wire B4, B5, B6, B7;

	
   // Looking at the truth table for xor we see that  
   // B xor 0 = B, and
   // B xor 1 = not(B).
   // So, if Op==1 means we are subtracting, then
   // adding A and B xor Op alog with setting the first
   // carry bit to Op, will give us a result of
   // A+B when Op==0, and A+not(B)+1 when Op==1.
   // Note that not(B)+1 is the 2's complement of B, so
   // this gives us subtraction.   
	
   xor(B0, B[0], Op);
   xor(B1, B[1], Op);
   xor(B2, B[2], Op);
   xor(B3, B[3], Op);
	xor(B4, B[4], Op);
	xor(B5, B[5], Op);
	xor(B6, B[6], Op);
	xor(B7, B[7], Op);
   
   
   sub_adder fa0(S[0], C0, A[0], B0, Op);    // Least significant bit.
   sub_adder fa1(S[1], C1, A[1], B1, C0);
   sub_adder fa2(S[2], C2, A[2], B2, C1);
   sub_adder fa3(S[3], C3, A[3], B3, C2);    // Most significant bit.
	sub_adder fa4(S[4], C4, A[4], B4, C3);
	sub_adder fa5(S[5], C5, A[5], B5, C4);
	sub_adder fa6(S[6], C6, A[6], B6, C5);
	sub_adder fa7(S[7], C7, A[7], B7, C6);
	
	xor(C, C7, Op);     // Carry = C3 for addition, Carry = not(C3) for subtraction.
	//assign C = (C7 != 0 && C7 ) ? 1'b1 : 1'b0;
   xor(V, C7, C6);     // If the two most significant carry output bits differ, then we have an overflow.
	assign N = (S[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( S == 8'b00000000 ) ? 1'b1 : 1'b0;
	
endmodule // ripple_carry_adder_subtractor
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module sub_adder(S, Cout, A, B, Cin);
   output S;
   output Cout;
   input  A;
   input  B;
   input  Cin;
	
   
   wire   w1;
   wire   w2;
   wire   w3;
   wire   w4;
   
   xor(w1, A, B);
   xor(S, Cin, w1);
   and(w2, A, B);   
   and(w3, A, Cin);
   and(w4, B, Cin);   
   or(Cout, w2, w3, w4);
endmodule // full_adder


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module FU_halfadder_jamahl29(A, B, R, cout);
	input A, B;
	output R, cout;
		
	and and1(cout, A, B);
	xor xor1(R, A, B);

endmodule
	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module FU_incrementer_jamahl29(A, R, C, V, N, Z);
	input [7:0] A;
	output [7:0] R;
	wire cout;
	output C, V, N, Z;
	wire [7:0]cin;
	assign cin = 8'b00000001;
	wire [7:0] w;
	
	FU_halfadder_jamahl29 inc1(A[0], cin, R[0], w[1]);
	FU_halfadder_jamahl29 inc2(A[1], w[1], R[1], w[2]);
	FU_halfadder_jamahl29 inc3(A[2], w[2], R[2], w[3]);
	FU_halfadder_jamahl29 inc4(A[3], w[3], R[3], w[4]);
	FU_halfadder_jamahl29 inc5(A[4], w[4], R[4], w[5]);
	FU_halfadder_jamahl29 inc6(A[5], w[5], R[5], w[6]);
	FU_halfadder_jamahl29 inc7(A[6], w[6], R[6], w[7]);
	FU_halfadder_jamahl29 inc8(A[7], w[7], R[7], cout);
	
	assign C = (cout == 1'b1) ? 1'b1 : 1'b0;
	assign V = (A == 8'b01111111) ? 1'b1 : 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;
	
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_negate_jamahl29(A, R, C, V, N, Z);
	input [7:0] A;
	output [7:0] R;
	wire cout;
	output C, V, N, Z;
	wire [7:0]cin;
	assign cin = 8'b00000001;
	wire [7:0] w;
	wire AN;
	wire A0, A1, A2, A3, A4, A5, A6, A7;
	
	not (A0,A[0]);
	not (A1,A[1]);
	not (A2,A[2]);
	not (A3,A[3]);
	not (A4,A[4]);
	not (A5,A[5]);
	not (A6,A[6]);
	not (A7,A[7]);
	
	FU_halfadder_jamahl29 neg1(A0, cin, R[0], w[1]);
	FU_halfadder_jamahl29 neg2(A1, w[1], R[1], w[2]);
	FU_halfadder_jamahl29 neg3(A2, w[2], R[2], w[3]);
	FU_halfadder_jamahl29 neg4(A3, w[3], R[3], w[4]);
	FU_halfadder_jamahl29 neg5(A4, w[4], R[4], w[5]);
	FU_halfadder_jamahl29 neg6(A5, w[5], R[5], w[6]);
	FU_halfadder_jamahl29 neg7(A6, w[6], R[6], w[7]);
	FU_halfadder_jamahl29 neg8(A7, w[7], R[7], cout);
	
	assign C = (cout == 1'b1) ? 1'b1 : 1'b0;
	assign V = (~A == 8'b01111111) ? 1'b1 : 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_bitnand_jamahl29(A, B, R, C, V, N, Z);
	input [7:0]A, B;
	output [7:0] R;
	output C, V, N, Z;
	
	assign R = ~(A & B);

	assign C = 1'b0;
	assign V = 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;
	
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_bitxnor_jamahl29(A, B, R, C, V, N, Z);
	input [7:0]A, B;
	output [7:0] R;
	output C, V, N, Z;
	
	assign R = ~(A ^ B);
	
	assign C = 1'b0;
	assign V = 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;

endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_bitnot_jamahl29(A, R, C, V, N, Z);
	input [7:0]A;
	output [7:0] R;
	output C, V, N, Z;

	assign R = ~A;
	
	assign C = 1'b0;
	assign V = 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;


endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_Bmult4_jamahl29( B, R, C, V, N, Z);
	input [7:0] B;
	output [7:0] R;
	output C, V, N, Z;
	
	assign R = B << 2;
	
	assign C = 1'b0;
	assign V = 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;

endmodule*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_Bdiv16_jamahl29( B, R, C, V, N, Z);
	input [7:0] B;
	output [7:0] R;
	output C, V, N, Z;
	wire [7:0] compB;
	not notB(compB, B)
	
	assign R = (B[7] == 1'b1) ? { 4'b1111 , B[7:4] } : { 4'b0000 , B[7:4] };
	
	assign C = 1'b0;
	assign V = 1'b0;
	assign N = (R[7] == 1'b1) ? 1'b1 : 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;
	
endmodule/*

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module FU_Bmod16_jamahl29( B, R, C, V, N, Z);
	input [7:0] B;
	output [7:0] R;
	output C, V, N, Z;
	
	assign R = {4'b0000 , B[3:0] };

	assign C = 1'b0;
	assign V = 1'b0;
	assign N = 1'b0;
	assign Z = ( R == 8'b00000000 ) ? 1'b1 : 1'b0;
	
endmodule
*/









