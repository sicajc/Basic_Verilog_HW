module ALU_tb;
reg [15:0] a,b;
reg [2:0] op;
wire [15:0] y; //Specially note that wire used as the output is always changing
wire cout;     //wire is used as something always flucuating,so in testbench, since the value 
 //Coming out is always fluctuating, you should use wire.
 //Reg used to keep value, and the value you want to change
ALU u1(.a(a),.b(b), .sel(op), .cout(cout),.y(y));
initial begin
  a <= 16'h8F54;
  b <= 16'h79F8;
  op <= 3'b000;
  #40 a <= 16'b1001_0011_1101_0010 ;
      b <= 16'b1110_1100_1001_0111 ;
end

always #10 begin //being_end should always be used to prevent errors
  
  op = op + 3'b001 ; 

end


endmodule