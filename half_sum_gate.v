`timescale 1 ns/ 1 ps
module half_sum_gate(A,B,qS,qCout);
    input A,B;
    output qS,qCout;
    
    xor U1(qS,A,B);
    and U4(qCout,A,B);
endmodule
/*
module half_sum_gate_tb;
    reg A,B;
    wire qS,qCout;
    
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
endmodule
*/

