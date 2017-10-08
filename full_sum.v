`timescale 1 ns/ 1 ps
module full_sum(A,B,Cin,S,Cout);
    input A,B,Cin;
    output S,Cout;
    wire qS,qCout,qCout1;
    
    half_sum_gate gate_h(
       .A(A),
       .B(B),
       .qS(qS),
       .qCout(qCout)
       );
    half_sum_func func_h(
       .A(qS),
       .B(Cin),
       .qS(S),
       .qCout(qCout1)
       );
    or fin_Cout(Cout,qCout,qCout1);
endmodule

module full_sum_tb;
    reg A,B,Cin;
    wire S,Cout;
    
    initial begin
        A=0; B=0; Cin=0;
    end
    initial begin
       repeat(8) begin
           #10 {A,B,Cin}={A,B,Cin}+1;
       end
       #10 $finish(1);
   end
   full_sum sum(
      .A(A),
      .B(B),
      .Cin(Cin),
      .S(S),
      .Cout(Cout));
endmodule