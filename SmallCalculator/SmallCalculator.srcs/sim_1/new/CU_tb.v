`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/19/2017 12:45:40 PM
// Design Name: 
// Module Name: CU_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CU_tb();
reg go, clk;
reg[1:0] op;
wire [1:0] s1, wa, raa, rab, c;
wire we, rea, reb, s2, done;
wire [3:0] cs;
integer i;

CU DUT(.go(go), .clk(clk), .op(op), .s1(s1), .wa(wa), .raa(raa), .rab(rab),
       .c(c), .we(we), .rea(rea), .reb(reb), .s2(s2), .done(done), .cs(cs));

task cycle;
    begin
        clk=0;
        #5;
        clk=1;
        #5;
    end
endtask

parameter S0_test = 15'b01_00_0_0_0_00_00_00_0_0;
parameter S1_test = 15'b11_01_1_0_0_00_00_00_0_0;
parameter S2_test = 15'b10_10_1_0_0_00_00_00_0_0;
parameter S3_test = 15'b01_00_0_0_0_00_00_00_0_0;
parameter S4_test = 15'b00_11_1_1_1_01_10_00_0_0;
parameter S5_test = 15'b00_11_1_1_1_01_10_01_0_0;
parameter S6_test = 15'b00_11_1_1_1_01_10_10_0_0;
parameter S7_test = 15'b00_11_1_1_1_01_10_11_0_0;
parameter S8_test = 15'b01_00_0_0_0_11_11_10_1_1;

initial
begin

clk=0;
go=0;

for(i =0; i<4; i=i+1)
    begin
    op=i;
    cycle;
    if(cs!=0)
        begin
        $display("Error with go operation");
        $stop;
        end
    
    if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S0_test)
        begin
        $display("Error initializing state 0");
        $stop;
        end
    
    go=1;
    cycle;
    
    if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S1_test)
        begin
        $display("Error changing from state 0 to state 1");
        $stop;
        end

    go=0;
    cycle;
    
    if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S2_test)
        begin
        $display("Error changing from state 1 to state 2");
        $stop;
        end
    cycle;
        
    if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S3_test)
        begin
        $display("Error changing from state 2 to state 3");
        $stop;
        end
    cycle;
    
    case(op)
        2'b00: if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S4_test)
            begin
            $display("Error transitioning to State 4");
            $stop;
            end
        2'b01: if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S5_test)
            begin
            $display("Error transitioning to State 5");
            $stop;
            end
        2'b10: if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S6_test)
            begin
            $display("Error transitioning to State 6");
            $stop;
            end
        2'b11: if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S7_test)
            begin
            $display("Error transitioning to State 7");
            $stop;
            end
    endcase
    cycle;
    
    if({s1, wa, we, rea, reb, raa, rab, c, s2, done}!= S8_test)
        begin
        $display("Error transitioning to State 8");
        $stop;
        end
        
    $display("Success");
    $stop;
    end
end
endmodule

