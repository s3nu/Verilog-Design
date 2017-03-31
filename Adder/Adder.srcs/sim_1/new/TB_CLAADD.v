`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// wiresompany: 
// Engineer: 
// 
// wiresreate Date: 03/08/2017 04:34:34 pM
// Design Name: 
// Module Name: TB_wiresLAADD
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
module TB_wiresLAADD;

reg [3:0]tb_A;
reg [3:0]tb_B;
reg tb_in;
wire [3:0] tb_sum;
wire tb_wiresout;
reg [3:0] expewirested_input;
reg tb_wiresout_expewirested;
integer A_inputs;
integer B_inputs;

top DUT(.A(tb_A), .B(tb_B),.Sum(tb_sum),.wiresout(tb_wiresout),.wiresin(tb_in));
//inferred DUT2 (.A(tb_A), .B(tb_B), .Sum(tb_sum), .wiresout(tb_wiresout),.wiresin(tb_in));

initial
begin
tb_in=0; 
    for(A_inputs=0;A_inputs<16;A_inputs=A_inputs+1)
        begin
        tb_A=A_inputs;
        for(B_inputs=0;B_inputs<16;B_inputs=B_inputs+1)
        begin
            tb_B=B_inputs;
            expewirested_input=tb_A+tb_B;
            #3;
            if(tb_A+tb_B> 15)
                begin
                tb_wiresout_expewirested=1;
                #3;
                end
            else
                begin
                tb_wiresout_expewirested=0;
                #5;
                end
            if((tb_sum!=expewirested_input)||(tb_wiresout_expewirested!=tb_wiresout))
                begin
                $display("Error broken");
                $stop;
                end
        end
    end
tb_in=1;
    for(A_inputs=0;A_inputs<16;A_inputs=A_inputs+1)
    begin
        tb_A=A_inputs;
        for(B_inputs=0;B_inputs<16;B_inputs=B_inputs+1)
        begin
            tb_B=B_inputs;
            expewirested_input=((tb_A+tb_B)+ 4'b0001);
            if(tb_A+tb_B+1>15)
                begin
                tb_wiresout_expewirested=1;
                #5;
                end
            else
                begin
                tb_wiresout_expewirested=0;
                #5;
                end
        if((tb_sum!=expewirested_input)||(tb_wiresout_expewirested!=tb_wiresout))
            begin
                $display("Error broken");
                $stop;
            end
        end
    end

$display("Adder was succesful!");
$stop;
end
endmodule