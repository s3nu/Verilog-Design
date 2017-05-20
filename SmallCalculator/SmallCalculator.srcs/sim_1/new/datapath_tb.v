`timescale 1ns / 1ps

module datapath_tb();
    reg clk, we, rea, reb, s2;
    reg [1:0] wa, raa, rab, s1, c;
    reg [2:0] in1, in2;
    wire [2:0] out;
    
    DP DUT(.clk(clk), .we(we), .rea(rea), .reb(reb), .s2(s2),
           .wa(wa), .raa(raa), .rab(rab), .s1(s1), .c(c),
           .in1(in1), .in2(in2), .out(out));
    
task cycle;
    begin
        clk=0;
        #5;
        clk=1;
        #5;
    end
endtask

integer i=0;
integer j=0;
integer k=0;
reg [2:0] expected;

initial
    begin
        we=1;
        cycle;
        $display("Testing normal functionality");
        raa=1;
        rab=2;
        for(i=0; i<8; i=i+1)
        begin
            wa=1;
            in1=i;
            s1=3;
            cycle;
            for(j=0; j<8; j=j+1)
            begin
                wa=2;
                in2=j;
                rea=0;
                reb=0;
                s1=2;
                s2=1;
                cycle;
                for(k=0; k<4; k=k+1)
                begin
                    s1=2;
                    wa=2;
                    rea=1;
                    reb=1;
                    c=k;
                    raa=1;
                    rab=2;
                    cycle;
                    
                    case(c)
                        2'b00:  expected = in1 + in2;   
                        2'b01:  expected = in1 - in2;   
                        2'b10:  expected = in1 & in2;   
                        default:  expected = in1 ^ in2; // 2'b11;
                    endcase
                    cycle;
                    
                    if(out!=expected)
                    begin
                        $display ("Error: output does not equal expected");
                        $stop;
                    end
                    
                    s1=0;
                    wa=3;
                    cycle;
                    
                   if(DUT.U1.RegFile[3]!=expected)
                    begin
                        $display("error with r3");
                        $stop;
                    end;
                    
                end
            end
        end
        
        $display("Testing s2 = 0");
        in1=3;  in2=2;
        rea=0;  reb=0;
        wa=1;
        c=0;
        s1=3;
        cycle;
        
        wa=2;
        rea=1;  reb=1;
        s2=0;
        cycle;
        
        if(out!=0)
        begin
            $display("Error s2 not set properly");
            $stop;
        end
        
        $display("Testing s1 = 1");
        in1=3;  in2=2;
        rea=0;  reb=0;
        wa=1;
        c=0;
        s1=1;
        cycle;
        
        wa=2;
        rea=1;  reb=1;
        s2=1;
        cycle;
        
        if(out!=in1)
        begin
            $display("Error s1 not set properly");
            $stop;
        end
        $display("Success");
        $stop;
    end
endmodule

