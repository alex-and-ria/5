`timescale 1 ns/1 ps
module mul(clk,nrst,in1,in2,res);
    parameter LENin1=8;
    parameter LENin2=8;
    parameter LENres=2*((LENin1>LENin2)? LENin1:LENin2);
    input [LENin1-1:0] in1;
    input [LENin2-1:0] in2;
    input clk,nrst;
    output reg [LENres-1:0] res;
   always @(negedge nrst or posedge clk) begin
       if(!nrst) res<=0;
       else res<=in1*in2;
   end 
endmodule

module mul_tst();
    parameter LENin1=2;
    parameter LENin2=3;
    parameter LENres=2*((LENin1>LENin2)? LENin1:LENin2);
    reg [LENin1-1:0] in1;
    reg [LENin2-1:0] in2;
    reg clk,nrst;
    wire [LENres-1:0] res;
    mul #(.LENin1(LENin1),.LENin2(LENin2)) tst_elem(.clk(clk),.nrst(nrst),.in1(in1),.in2(in2),.res(res));
    
    initial begin
        in1<=0; in2<=0; clk<=0; nrst<=0;//clear mul;
        $monitor("time=%g,in1=%h, in2=%h,res=%h",$time,in1,in2,res);
        #20 $finish;
    end
    
    always @(negedge clk) begin
        nrst<= $random;
        in1<=$random;
        in2<=$random;
    end
    
    always #1 clk=!clk;
    
endmodule