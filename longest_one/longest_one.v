module longest_one_detector(input clk,
                            input[2:0] din,
                            input count,
                            output reg[3:0] length);

    //Registers
    reg[3:0] temp_reg;
    reg[3:0] result;

    //Inner Control
    wire temp_gtl;
    wire result_gtl;
    reg cont_flag;
    reg cont_flag_c;

    always@(posedge clk)
        temp_reg <= !count ? 4'd0 : result;

    always@(posedge clk)
        length <= !count ? 4'd0 : result_gtl ? result : temp_gtl ? temp_reg : length ;

    always@(posedge clk)
        cont_flag <= !count ? 1'd0 : cont_flag_c;

    assign temp_gtl = (temp_reg > length);
    assign result_gtl = (result > length);

    always @(*)
    begin
        if (count)
            case(din)
                3'b111: {cont_flag_c,result} = {1'b1,temp_reg + 4'd3};
                3'b110:
                begin
                    cont_flag_c = 1'b0;
                    result      = cont_flag ? temp_reg + 2 : 4'd2;
                end

                3'b101:
                begin
                    cont_flag_c = 1'b1;
                    result      = cont_flag ? temp_reg + 1 : 4'd1;
                end

                3'b100:
                begin
                    cont_flag_c = 1'b1;
                    result      = cont_flag ? temp_reg + 1 : 4'd1;
                end

                3'b011:
                begin
                    cont_flag_c = 1'b1;
                    result      = 4'd2;
                end

                3'b010:
                begin
                    cont_flag_c = 1'b0;
                    result      = 4'd1;
                end

                3'b001:
                begin
                    cont_flag_c = 1'b1;
                    result      = 4'd1;
                end

                default:
                begin
                    cont_flag_c = 1'b0;
                    result      = 4'd0;
                end

            endcase
        else
            {cont_flag_c,result} = {1'b0,4'b000};

    end

endmodule
