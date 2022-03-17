module T_FF_tb; // Stimulus Module name
reg clk;
reg rst;
wire q;

T_FF u1(.q(q), .clk(clk) , .rst(rst)); 
//The unit I want to test, .q(q)
//.q Means the q pin I connected to, (q) is the wire name I connect from outside

initial begin
clk = 1'b0; //initial clock as 0
rst = 1'b1; //initial reset as 1

end
always #10 clk = ~clk; // Clock flips every 10 ns

initial begin
    
    #15 rst = 1'b0; //reset-> 0 @ 15
    #8 rst = 1'b1; //reset-> 1 @ 23

end



endmodule