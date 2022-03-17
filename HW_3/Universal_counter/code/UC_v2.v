module UC_V2#(parameter n = 4)
             (input clk,
              input clear,
              input mode,
              input incr,
              input pause,
              output reg[n-1:0] count);


    wire[n-1:0] add_sub_out,result;
    wire[n-1:0] cur;

    //State Register
    reg[n-1:0] next;
    DFF #(n) dff(.clk(clk),.next(next),.cur(cur));

    //Mux1 + Decoder for mux selection
    always @(*)
    begin
        casex({clear,pause,mode,incr})
            4'b1xxx:    next = {n{1'b0}};
            4'b01xx:    next = count;
            4'b00xx:    next = add_sub_out;
            default:    next = count;
        endcase
    end

    //Adder_Subtractor
    assign add_sub_out = incr ? count + 1 : count - 1;

    //Cur_to_count
    always@(*)
    begin
        if (mode)
        begin
            if (cur > 15)
                count = 0;
            else if (cur < 0)
                count = 15;
            else
                count = cur;
        end
        else
        begin
            if (cur > 10)
                count = 0;
            else if (cur < 0)
                count = 9;
            else
                count = cur;
        end
    end

endmodule

    module DFF#(parameter n = 4)(input clk,input[n-1:0] next,output reg[n-1:0] cur);
        always@(posedge clk)
            cur <= next;
    endmodule
