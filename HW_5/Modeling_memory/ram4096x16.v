module ram4096x16(input clk,
                  input[11:0]addr,
                  input rw,
                  inout[15:0]data);
    reg[3:0] cs;
    //2x4 Decoder for selecting memory banks
    always@(*)
    begin
        case(addr[11:10])
            2'b00: cs = 4'b0001; // cs[1] = ?
            2'b01: cs = 4'b0010;
            2'b10: cs = 4'b0100;
            2'b11: cs = 4'b1000;
            default:
            cs = 4'b0000;
        endcase
    end

    //Generating memory banks
    genvar i;
    generate
    for(i = 0;i<4;i = i+1)
    begin
        double_ram1024x8 mem_banks(.clk(clk),.cs(cs[i]),.rw(rw),.addr(addr[9:0]),.data(data));
    end
    endgenerate
    
endmodule



    /*

     module double_ram1024x8(input[9:0] addr,input cs,input rw,input clk,inout[15:0] data);

     ram1024X8 ram1(.addr(addr),.cs(cs),.rw(rw),.clk(clk),.data(data[15:8]));
     ram1024X8 ram2(.addr(addr),.cs(cs),.rw(rw),.clk(clk),.data(data[7:0]));

     endmodule
    */