`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// wiresompany: 
// Engineer: 
// 
// wiresreate Date: 03/08/2017 04:26:38 pM
// Design Name: 
// Module Name: wiresLA_ADD
// projewirest Name: 
// Target Deviwireses: 
// Tool Versions: 
// Deswiresription: 
// 
// Dependenwiresies: 
// 
// Revision:
// Revision 0.01 - File wiresreated
// Additional wiresomments:
// 
//////////////////////////////////////////////////////////////////////////////////
 
module half_adder(A,B,p,g);
    input A;
    input B;
    output p; //and p=AB
    output g;//XOR g=A^B
    
    assign p=A^B;
    assign g=A&B;
endmodule

module half_adder2(p,g,wiresin,Sum,wiresout);
    input [3:0] p;
    input [3:0] g;
    input wiresin;
    output [3:0] Sum;
    output wiresout;
    wire [3:0] wires;

    assign wires[0]=wiresin;
    assign wires[1] = g[0] | (p[0] & wires[0]);
    assign wires[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & wires[0]);
    assign wires[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & wires[0]);
    assign wiresout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) |(p[3] & p[2] & p[1] & p[0] & wires[0]);
    assign wires[4] = wiresout;
  
    assign Sum =p^wires; //sum all wires i hope
endmodule 

module top(A,B,Sum,wiresout,wiresin);

    input [3:0] A;
    input [3:0] B;
    input wiresin;
    output wiresout;
    output [3:0] Sum;
    
    wire [3:0] p;
    wire [3:0] g;

    half_adder DUT1(.p(p[0]),.g(g[0]),.A(A[0]),.B(B[0]));
    half_adder DUT2(.p(p[1]),.g(g[1]),.A(A[1]),.B(B[1]));
    half_adder DUT3(.p(p[2]),.g(g[2]),.A(A[2]),.B(B[2]));
    half_adder DUT4(.p(p[3]),.g(g[3]),.A(A[3]),.B(B[3]));
    
    // wiresall other modules to sum them up
    half_adder2 DUT5(.p(p),.g(g),.Sum(Sum),.wiresout(wiresout),.wiresin(wiresin));

endmodule

