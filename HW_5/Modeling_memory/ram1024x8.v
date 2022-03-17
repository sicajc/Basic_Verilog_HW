module ram1024x8(input[9:0] addr,
                 input cs,
                 input rw,
                 input clk,
                 inout[7:0] data);
//If rw = 1, write. rw = 0 read,should we add a tri-state buffer?
reg[7:0] mem[0:1023];
reg[7:0] d_out;

//Tri-state buffer.
assign data = (cs && !rw) ? d_out : {8{1'bz}};

always@(posedge clk)
begin
    if (cs && rw)
    begin
        mem[addr] = data;
    end
end

always@(posedge clk)
begin
    if (cs && !rw)
    begin
        d_out = mem[addr];
    end
end
endmodule
