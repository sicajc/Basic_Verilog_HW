`include "DFG_EG.v"
module DFG_EG_tb();
    reg start;
    reg clk;
    reg rst;
    reg[7:0] a;
    reg[7:0] b;
    reg[7:0] c;
    reg[7:0] d;
    reg[7:0] e;
    wire[7:0] x;
    wire[7:0] y;

    DFG_EG uut(.clk(clk),.rst(rst),.start(start),.a(a),.b(b),.c(c),.d(d),.e(e),.x_reg(x),.y_reg(y));

    initial begin
        clk = 0;
        rst = 1;
        start = 1;

        #30
        rst = 0;
        start = 1;
        a   = 8'd20;
        b   = 8'd1;
        c   = 8'd5;
        d   = 8'd3;
        e   = 8'd2;


        #20
        start = 0;



        #100 $finish;

    end

    always #5 clk = ~clk;


endmodule
