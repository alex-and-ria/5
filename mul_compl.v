`timescale 1 ns/1 ps

module mul_compl(sel, wrt, clk, nres, ready, wdata,rdata, addr_b);
    parameter SZin=8;
    reg is_ready,set_ready;
    input sel,wrt,clk,nres;
    inout ready;
    input [SZin-1:0] wdata;
    input addr_b;//addr is 0 for operand1 or 1 for operand 2, so 1 bit for addres bus is enough;
    output reg [2*SZin-1:0] rdata;
    reg [SZin-1:0] memop [1:0];
    integer i;
    
task m_mul;
    input[SZin-1:0] in1,in2;
    output [2*SZin-1:0] out;
    reg [2*SZin-1:0] tmpres;
    integer j,k;
    begin
        tmpres=0;
        for(j=0;j<2*SZin-1;j=i+1) begin
            out[j]=0;//fill with zero;
        end
        for(j=SZin-2;j>=0;j=j-1) begin
            if(in2[j]==0) begin
                out=out<<1;
            end else begin
                for(k=2*SZin-1;k>=0;k=k-1) begin
                    if(k>SZin-1) begin
                        tmpres[k]=in1[SZin-1];//fill with sign;
                    end else begin
                        tmpres[k]=in1[k];
                    end
                end
                tmpres=tmpres<<(SZin-2-j);
                out=out+tmpres;                
            end            
        end
        if(in2[SZin-1]==1) begin//correction;
            for(j=0;j<SZin-1;j=j+1) begin
                tmpres[j]=in1[j];
            end
            tmpres=tmpres+1;
            tmpres=tmpres<<SZin-1;//make complement;
            out=out+tmpres;
        end
        $display("tsk");
    end    
endtask
    
    assign ready=(set_ready==1) ? is_ready: 1'bz;
    
    always @(posedge clk) begin
        is_ready=0;set_ready=0;
        if(sel==1) begin//selected
            if(!nres) begin
                $display("!nres");
                for(i=0;i<2;i=i+1) begin
                    memop[i]=0;//clear operands;
                end
            end else if(wrt) begin//write operand
                if(ready==0) begin
                    @(posedge ready);//wait for ready==1;
                end
                $display("wrta=%b, ready=%b",wrt,ready);
                is_ready=0; set_ready=1;
                memop[addr_b]=wdata;
                is_ready=1;
            end else begin//read result: momop[0]*memop[1];
                if(ready==0) begin
                    @(posedge ready);//wait for ready==1;
                end
                is_ready=0; set_ready=1;//multiplying can take some time, so set ready to 0;
                rdata=memop[0]*memop[1];//tmp; TODO;
                $display("memop[0]=%d,memop[1]=%d,rdata=%d",memop[0],memop[1],rdata);
                is_ready=1;
            end
        end else begin
            is_ready=0;set_ready=0;
        end    
    end
endmodule

module tst_mul_compl();
    parameter SZin=3;
    reg is_ready,set_ready;
    reg sel,wrt,clk,nres;
    wire ready;
    reg [SZin-1:0] wdata;
    reg addr_b;//addr is 0 for operand1 or 1 for operand 2, so 1 bit for addres bus is enough;
    wire [2*SZin-1:0] rdata;
    integer i;
    
    assign ready=(set_ready==1) ? is_ready: 1'bz;
    
    initial begin
        sel=0;wrt=0;clk=0;nres=0; wdata=0; addr_b=0;
        #2 sel=1;
        #2 nres=0; is_ready=1; set_ready=1;//clear;
        #2 nres=1; set_ready=0;
        for(i=0;i<3;i=i+1) begin
            #2
            if(ready==0) begin
                @(posedge clk);
            end  
            set_ready=1; addr_b=0; wrt=1; wdata=$random; $display("wdata=%d", wdata);
            #2 set_ready=0;
            #2
            if(ready==0) begin
                @(posedge clk);
            end
            set_ready=1; addr_b=1; wdata=$random; $display("wdata1=%d", wdata); set_ready=0;
            #2
            if(ready==0) begin
                @(posedge clk);
            end
            set_ready=1; wrt=0; set_ready=0;
            #2 $display("rdata=%d", rdata); 
        end       
        #2 $finish();
        
        
    end
    
    always #1 clk=!clk;
    
    mul_compl #(.SZin(SZin)) 
       mul_compl_ut(.sel(sel),.wrt(wrt),.clk(clk),.nres(nres),.ready(ready),.wdata(wdata),.rdata(rdata),.addr_b(addr_b));    
endmodule