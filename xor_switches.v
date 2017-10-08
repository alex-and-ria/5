`timescale 1 ns/ 1 ps
module my_xor(a_in,b_in,f_out);
    input a_in,b_in;
    output f_out;
    wire bp1,bp2,bn1,bn2,tmpout,not_a,not_b;
    
    //xmos(output,input,control);
    supply1 vdd;
    supply0 gnd;
    my_not m_not(.inp(a_in),.outp(not_a));
    my_not m_not1(.inp(b_in),.outp(not_b));
    pmos p1(bp1,vdd,a_in);
    pmos p2(tmpout,bp1,b_in);
    pmos p3(bp2,vdd,not_a);
    pmos p4(tmpout,bp2,not_b);
    nmos n1(tmpout,bn1,not_a);
    nmos n2(bn1,gnd,b_in);
    nmos n3(tmpout,bn2,a_in);
    nmos n4(bn2,gnd,not_b);
    my_not m_not2(.inp(tmpout),.outp(f_out));
endmodule

module my_xor_tb;
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
   my_xor m_xor(.a_in(ain),.b_in(bin),.f_out(fout));
endmodule
