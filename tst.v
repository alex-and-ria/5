`timescale 1 ns/ 1 ps
module top();
reg clk, nreset;
initial $disply("Hello");
initial
begin
clk=0;
forever #5 clk=~clk;
end
initial
begin
nreset = 0;
#25 nreset = 1;
end
initial
begin
repeat(10) @(posedge clk);
$finish(1);
end
initial
begin
$dumpfile("wave.vcd");
$dumpvars(0);
end
endmodule
