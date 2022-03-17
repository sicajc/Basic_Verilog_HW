`define STATE_BIT 2'd3
`define DATA_WIDTH 1'd1
`define S0 3'b000
`define S1 3'b001
`define S2 3'b010
`define S3 3'b011
`define S4 3'b100
`define S5 3'b101
`define S6 3'b110
`define S7 3'b111
module DB(input rst,
          input clk,
          input in,
          output reg out);

    parameter n  = `DATA_WIDTH ;
    parameter sb = `STATE_BIT;
    wire[sb-1:0] cur,next;
    reg[sb-1:0]next1;
    
    //State register
    DFF #(sb) state_reg(.clk(clk),.d(next),.q(cur));
    
    //Reset state register
    assign next = rst ? `S0 : next1;
    
    //Next_state_logic
    always@(*)
    begin
        case(cur)
            `S0:  next1     = in ? `S1 : `S0;
            `S1:  next1     = in ? `S3 : `S0;
            `S3:  next1     = in ? `S4 : `S0;
            `S4:  next1     = in ? `S4 : `S5;
            `S5:  next1     = in ? `S4 : `S7;
            `S7:  next1     = in ? `S4 : `S0;
            default:  next1 = `S0;
        endcase
    end
    
    //Output logic
    always@(*)
    begin
        case(cur)
            `S0:  out     = in ?  1'b0 : 1'b0;
            `S1:  out     = in ?  1'b0 : 1'b0;
            `S2:  out     = in ?  1'b0 : 1'b0;
            `S3:  out     = in ?  1'b1 : 1'b0;
            `S4:  out     = in ?  1'b1 : 1'b1;
            `S5:  out     = in ?  1'b1 : 1'b1;
            `S6:  out     = in ?  1'b1 : 1'b1;
            `S7:  out     = in ?  1'b1 : 1'b0;
            default:  next1 = 1'b0;
        endcase
    end
endmodule
    
    module DFF#(parameter n)(input clk,input[n-1:0] d,output reg[n-1:0] q);
        always@(posedge clk)
            q <= d;
    endmodule

//Test DB
module DB_TB;
reg rst,clk,sig_in;
wire sig_out;
integer i;
DB UUT(.clk(clk),.rst(rst),.in(sig_in),.out(sig_out));

initial begin
    {rst,clk,sig_in} = 3'b100;
    #10 rst = 1'b0;

    for(i = 0;i<120;i=i+1)
    begin
      case(i)
        8: sig_in = 1;
        11: sig_in = 0;
        14: sig_in = 1;
        17: sig_in = 0;
        21: sig_in = 1;
        24: sig_in = 0;
        27: sig_in = 1;

        73: sig_in = 0;
        76: sig_in = 1;
        79: sig_in = 0;
        83: sig_in = 1;
        86: sig_in = 0;
        88: sig_in = 1;
        91: sig_in = 0;

      endcase
      #1;
    end

    #200 $finish ;
end

always #5 clk=~clk;



endmodule