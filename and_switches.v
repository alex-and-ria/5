`timescale 1 ns/ 1 ps
module my_and(a_in,b_in,f_out);
    input a_in,b_in;
    output f_out;
    wire bnmos,tmpout;
    
    supply1 vdd;
    supply0 gnd;
    pmos p1(tmpout,vdd,a_in);
    pmos p2(tmpout,vdd,b_in);
    nmos n1(tmpout,bnmos,a_in);
    nmos n2(bnmos,gnd,b_in);
    my_not m_not(.inp(tmpout),.outp(f_out));
    
endmodule

module my_and_tb;
    reg ain,bin;
    wire fout;
    initial begin
       ain=0; bin=0;
   end
   initial begin
      repeat(4) begin
         #10 {ain,bin}={ain,bin}+1;
      end
      #10 $finish(1);
   end
   my_and m_and(.a_in(ain),.b_in(bin),.f_out(fout));
endmodule