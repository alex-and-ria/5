`timescale 1 ns/ 1 ps
module my_not(inp,outp);
   input inp;
   output outp;
   
   supply1 vdd;
   supply0 gnd;
   pmos p1(outp,vdd,inp);
   nmos n1(outp,gnd,inp);
endmodule