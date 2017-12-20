`timescale 1 ns/1 ps

module add_1_bit(in1,in2,cin,sig,cout);
    input in1, in2, cin;
    output sig, cout;
    wire g,h,andc;
    
    xor gen_sig(sig,in1,in2,cin);
    and and1(g,in1,in2);
    or or1(h,in1,in2);
    and and2(andc,h,cin);
    or or_out(cout,g,andc);
    
endmodule

module tst_add_1_bit();
    reg in1,in2,cin;
    wire sig,cout;
    integer i;
    
    add_1_bit a1b(.in1(in1),.in2(in2),.cin(cin),.sig(sig),.cout(cout));
    initial begin//test 1 bit adder;
        in1=0; in2=0; cin=0;
        for(i=0;i<8;i=i+1) begin
            #2 {in1,in2,cin}=i;
        end
        #2 $finish;
    end  
endmodule

/*module add_1_bit(in1,in2,cin,sig,cout);
    input in1,in2,cin;
    output sig, cout;
    reg sig, cout;
    always@(in1 or in2 or cin) begin
        {cout,sig}=in1+in2+cin;
    end
    initial $display("i anm working");
endmodule
*/