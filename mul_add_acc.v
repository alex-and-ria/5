`timescale 1 ns/1 ps


module mul_add_acc (ina,inxni,clk,rst, res);
    parameter SZin=7;
    input [SZin:0] ina;
    input [SZin:0] inxni;
    input clk,rst;
    output [2*(SZin+1):0] res;
    reg [2*(SZin+1)-1:0] resprev;
    integer i;
    mul_sum #(.SZin(SZin)) ms(.ai(ina), .xni(inxni), .clk(clk), .rst(rst), .resprev(resprev),.res(res));
    
    initial begin
        #1 resprev<=0;
    end
    
    always @(negedge clk) begin
        resprev<=res;
    end   
endmodule

module tst_mul_add_acc();
    parameter SZin=3;
    parameter SZN=5;
    reg [SZin:0] ina,inxni;
    reg clk,rst;
    wire [2*(SZin+1):0] res;
    integer i;
    mul_add_acc #(.SZin(SZin),.SZN(SZN)) mul_add(.ina(ina),.inxni(inxni),.clk(clk),.rst(rst),.res(res));
    
    initial begin
        ina=0; inxni=0; clk=0; rst=0;
        $monitor("clk=%b; rst=%b,ai=%d,xni=%d,resprev=%d,res=%d",clk,rst,ina,inxni,mul_add.resprev,res);
        #1 rst=1;
        for(i=0;i<SZN;i=i+1) begin
            @(negedge clk);
            ina=ina+1;
            inxni=ina+inxni+1;
            #3;
        end
        #2 $finish;
    end
    
    always #2 clk=!clk;
    
endmodule