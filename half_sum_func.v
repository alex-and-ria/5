`timescale 1 ns/ 1 ps
module half_sum_func(A,B,qS,qCout);
    input A,B;
    output qS,qCout;
    reg qS,qCout;
    
    always@(A or B) begin
       qS<=A^B;
       qCout<=A&B;
   end
endmodule


module half_sum_tb;
    reg A,B;
    wire qS,qCout,qS1,qCout1;
    
    initial begin
        A=0; B=1'b0;
        #10 B=1'b1;
        #10 {A,B}=2'b10;
        #10 {A,B}=2'b11;
        #10 $finish(1);
    end
    
   half_sum_gate tst(
      .A(A),
      .B(B),
      .qS(qS),
      .qCout(qCout));
   half_sum_func tst1(
      .A(A),
      .B(B),
      .qS(qS1),
      .qCout(qCout1));
endmodule
   