module ALU(a,b,sel,y,cout);

input[15:0] a;
input[15:0] b;
input[2:0] sel;

output[15:0] y;
output cout;

wire[16:0] y0; //000
reg[16:0] y1; //001
reg[15:0] y2; //010
reg[15:0] y3; //011
reg[15:0] y4; //100
reg[15:0] y5; //101
reg[15:0] y6; //110
reg[15:0] y7; //111

reg[15:0] y; //output in module the output should be always reg, unless
reg cout;//output

reg c0 = 1'b0;
reg c1 = 1'b0;

//You SHOULD NOT USE ASSIGN in IF_ELSE
//A+B
assign y0 = a+b;
assign c0 = y0[16];

//A-B
assign y1 = a-b;
assign c1 = y1[16]; //Carry would be performed implicitly

//min{a,b}
assign y2 = (a-b) > 0 ? b : a ;

//max{a,b}
assign y3 = (a-b) > 0 ? a : b ; 
//bitwise A & B
assign y4 = a & b;

//bitwise A OR B
assign y5 = a | b;

//A XOR B
assign y6 = a ^ b;

//A XNOR B
assign y7 = ~( a^b );

//MUX, output [15:0] y , 1 bit cout
always @(*) begin
  case(sel)//OPCODE Selection for mux
    
    3'b000 : begin
       y = y0; 
       cout = c0;
    end
    3'b001 : begin
      y = y1;
      cout = c1;
    end

    3'b010 : y = y2;
    3'b011 : y = y3;
    3'b100 : y = y4;
    3'b101 : y = y5;
    3'b110 : y = y6;
    3'b111 : y = y7;
    default : y = 0; 

  endcase
end


endmodule