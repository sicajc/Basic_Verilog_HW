module Comparator_tb; //The name of the file and the module had better be the same to prevent mistake

reg[15:0] a = 16'h0000;
reg[15:0] b = 16'h0000;

wire gt1; 
wire eq;
wire less;
// In testbench output must use wire, this must be remembered!
// In module, output should be reg and input is definitely wire. 

Comparator c1(.a(a), .b(b), .greater(gt1), .equal(eq), .less(less));

initial begin //Initial begin used to 
  #0
  a <= 16'h04f8;
  b <= 16'h04f7;
  #10
  b <= 16'h04fa; 
  #10
  a <= 16'h04fa;
  #10
  b <= 16'h24fa;
 
end
endmodule