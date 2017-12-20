`timescale 1 ns/1 ps

module addr(in1,in2,res);
    parameter SZin=8;
    parameter SZres=SZin+1;
    input [SZin:0] in1;
    input [SZin:0] in2;
    output wire [SZres:0] res;
    wire [SZres-1:0] carry;
    
    genvar i;
    for(i=0;i<SZres;i=i+1) begin
        if(i==0) begin//first iterarion;
           add_1_bit add0(in1[0],in2[0],1'b0,res[0],carry[0]);
        end else begin
            if(i==SZres-1) begin
                add_1_bit addf(in1[i],in2[i],carry[i-1],res[i],res[i+1]);
            end else begin
                add_1_bit addi(in1[i],in2[i],carry[i-1],res[i],carry[i]);
            end
        end
    end     
endmodule

module tst_addrs();
    parameter SZin=3;
    parameter SZres=SZin+1;
    reg [SZin:0] in1;
    reg [SZin:0] in2;
    wire [SZres:0] res;
    integer i;
    
    addr #(.SZin(SZin)) add_tstr(.in1(in1),.in2(in2),.res(res));
    initial begin//test addr;
        #1 in1=0; in2=0;
        for(i=0;i<32;i=i+1) begin
            #1 in1=$random;
            in2=$random;
        end
        $finish;
    end
    
endmodule