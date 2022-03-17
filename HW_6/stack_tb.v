`include "stack.v"
module stack_tb();
    reg clk;
    reg[7:0] data_in;
    reg[1:0] cmd;

    wire[7:0] data_out;
    wire full;
    wire empty;
    wire error;

    //Encodings
    parameter  no_op = 2'b00 ;
    parameter  clear = 2'b01 ;
    parameter  push  = 2'b10;
    parameter  pop   = 2'b11 ;
    integer i;

    stack uut(.clk(clk),.cmd(cmd),.data_in(data_in),.data_out(data_out),.full(full),.empty(empty),.error(error));

    initial begin

        clk     = 0;
        data_in = 8'h00;

        for(i = 1;i<26;i = i+1)
        begin
            case(i)
                1: cmd            = clear;
                2: cmd            = pop;
                3: cmd            = pop;
                4: {cmd,data_in}  = {push,8'h01};
                5: {cmd,data_in}  = {push,8'h02};
                6: cmd            = no_op;
                7: cmd            = pop;
                8: {cmd,data_in}  = {push,8'h03};
                9: {cmd,data_in}  = {push,8'h04};
                10: {cmd,data_in} = {push,8'h05};
                11: {cmd,data_in} = {push,8'h06};
                12: {cmd,data_in} = {push,8'h07};
                13: {cmd,data_in} = {push,8'h08};
                14: {cmd,data_in} = {push,8'h09};
                15: {cmd,data_in} = {push,8'h0a};
                16: {cmd,data_in} = {push,8'h0b};
                17: {cmd,data_in} = {push,8'h0c};
                18: cmd           = pop;
                19: cmd           = pop;
                20: cmd           = pop;
                21: cmd           = no_op;
                22: cmd           = clear;
                23: {cmd,data_in} = {push,8'h10};
                24: {cmd,data_in} = {push,8'h20};
                25: cmd           = pop;

                default:
                cmd = no_op;
            endcase
            #10;
        end

        #30$finish;
    end

    always
    begin
    #5 clk = ~clk;
    end


endmodule
