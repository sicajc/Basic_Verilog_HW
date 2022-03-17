module DFG_EG(input clk,
              input rst,
              input start,
              input[7:0] a,
              input[7:0] b,
              input[7:0] c,
              input[7:0] d,
              input[7:0] e,
              output reg[7:0] x_reg,
              output reg[7:0] y_reg);
    /*-------------------CP------------------*/
    reg[12:0] CV; //Control Vectors
    reg[1:0] Src1;
    reg[1:0] Src4;
    reg Asrc;
    reg Msrc;
    reg Ld1,Ld2,Ld3,Ld4,Ld5;
    reg Xdone,Ydone;
    assign  Src1 = CV[12:11];
    assign  Src4 = CV[10:9];
    assign  Asrc = CV[8];
    assign  Msrc = CV[7];
    assign  {Ld1,Ld2,Ld3,Ld4,Ld5} = CV[6:2];
    assign  Xdone = CV[1];
    assign  Ydone = CV[0];

    parameter S0 = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter DONE = 3'd4;

    reg[2:0] current_state,next_state;

    always @(posedge clk)
    begin
        current_state <= rst ? S0 : next_state;
    end

    always @(*) begin
        case(current_state)
            S0:
            begin
                next_state = start ? S1 : S0;
                CV         = 13'h147c ;
            end

            S1:{next_state,CV} = {S2,13'h0148};
            S2:{next_state,CV} = {S3,13'h0249};
            S3:{next_state,CV} = {DONE,13'h00c2};
            DONE:
            begin
                next_state = start ? S0 : DONE;
                CV = start ? 13'h0a7c : 13'h0000;
            end

            default:
            {next_state,CV} = {S0,13'h0};

        endcase
    end

    /*-------------------DP-------------------*/
    //Registers
    reg[7:0] r1_reg,r2_reg,r3_reg,r4_reg,r5_reg;

    //adders
    reg[7:0] add1_out;
    reg[7:0] add2_out;

    //multipler
    reg[7:0] mul_out;


    //R1
    always@(posedge clk)
    begin
        if (rst)
            r1_reg <= 8'hz;
        else
            if (Ld1)
                case(Src1)
                    2'b00:  r1_reg <= add1_out;
                    2'b01:  r1_reg <= mul_out;
                    2'b10:  r1_reg <= a;
                    default:
                    r1_reg <= r1_reg;
                endcase
            else
                r1_reg <= r1_reg;
    end

    //R2
    always @(posedge clk)
        r2_reg <= rst ? 8'hz : Ld2 ? b : r2_reg;

    //R3
    always @(posedge clk) begin
        r3_reg <= rst ? 8'hz : Ld3 ? c : r3_reg;
    end

    //R4
    always @(posedge clk) begin
        if (rst)
            r4_reg <= 8'hz;
        else if (Ld4)
            case(Src4)
                2'b00: r4_reg <= add2_out;
                2'b01: r4_reg <= mul_out;
                2'b10: r4_reg <= d;
                default:
                r4_reg <= r4_reg;
            endcase
        else
            r4_reg <= r4_reg;
    end

    //R5
    always @(posedge clk)
    begin
        r5_reg <= rst ? 8'hz : Ld5 ? e : r5_reg;
    end

    //adder1
    always @(*)
    begin
        add1_out = Asrc ? r1_reg + r3_reg : r1_reg + r2_reg ;
    end
    //adder2
    always @(*)
    begin
        add2_out = r2_reg + r4_reg;
    end

    //multiplier
    always @(*)
    begin
        mul_out = Msrc ? r1_reg * r5_reg : r1_reg *  r4_reg;
    end


    //Output registers x,y
    always @(negedge clk)
    begin
        x_reg <= rst ? 8'hz : Xdone ? add1_out : x_reg;
        y_reg <= rst ? 8'hz : Ydone ? mul_out : y_reg;
    end

endmodule
