`timescale 1 ns/1 ps

module mul_sum(ai, xni, clk, rst, resprev,res);
    parameter SZin=8;
    input [SZin:0] ai, xni;
    input [2*(SZin+1)-1:0] resprev;//should be twice bigger than size(in);
    output [2*(SZin+1):0] res;//should be twice+1 bigger than size(in);
    wire [2*(SZin+1)-1:0] resi;
    input clk,rst;
    mul #(.LENin1(SZin+1), .LENin2(SZin+1)) mul1(.clk(clk),.nrst(rst),.in1(ai),.in2(xni),.res(resi));
    addr #(.SZin(2*(SZin+1)-1)) add_res(.in1(resi),.in2(resprev),.res(res));         
endmodule


module tst_mul_sum();
    parameter SZin=3;
    reg [SZin:0] ai, xni;
    reg [2*(SZin+1)-1:0] resprev;
    reg clk,rst;
    wire [2*(SZin+1):0] res;
    integer i;
    mul_sum #(.SZin(SZin)) ms(.ai(ai), .xni(xni), .clk(clk), .rst(rst), .resprev(resprev),.res(res));
    initial begin
        ai=0; xni=0; resprev=0; clk=0; rst=0;
        $monitor("clk=%b; rst=%b,ai=%d,xni=%d,resprev=%d,res=%d",clk,rst,ai,xni,resprev,res);
        #1 rst=1;
        for(i=0;i<20; i=i+1) begin
            @(negedge clk);
            if(!clk) begin//mul -- rising => set on 0 level;
                ai=$random; xni=$random; resprev=res;
                #3;
            end                
        end
        #2 $finish;
    end
    
    always # 2 clk=!clk;
    
endmodule