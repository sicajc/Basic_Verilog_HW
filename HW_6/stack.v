module stack(clk,
             data_in,
             cmd,
             data_out,
             full,
             empty,
             error,
             );
    input clk;
    input[7:0] data_in;
    input[1:0] cmd;
    output reg[7:0] data_out;
    output reg full;
    output  reg empty;
    output  reg error;

    reg[7:0] RAM[0:7];
    reg[2:0] sp;
    wire[7:0] dout;

    //Encodings
    parameter  no_op = 2'b00 ;
    parameter clear  = 2'b01 ;
    parameter push   = 2'b10;
    parameter  pop   = 2'b11 ;

    //Stack operations,Register operation

    //Status signal
    reg full_c,empty_c,error_c;
    reg[2:0] sp_c;
    //Opeartion signals
    reg  pop_s;
    reg  clear_s;
    reg  push_s;
    reg  no_op_s;

    //cmd -> operation, generating signals
    always@(*)
    begin
        case(cmd)
            clear:
            {pop_s,clear_s,push_s,no_op_s} = 4'b0100;
            push:
            {pop_s,clear_s,push_s,no_op_s} = 4'b0010;
            pop:
            {pop_s,clear_s,push_s,no_op_s} = 4'b1000;
            no_op:
            {pop_s,clear_s,push_s,no_op_s} = 4'b0001;
            default:
            {pop_s,clear_s,push_s,no_op_s} = 4'b0001;
        endcase
    end

    //Status Registers full,empty,error
    always@(posedge clk)
    begin
        {full,empty,error} <= {full_c,empty_c,error_c};
    end
    //Stack pointer
    always@(negedge clk)
    begin
        sp <= sp_c;
    end
    //Combo operation for status and stack pointer
    always@(*)
    begin
        if (clear_s)
        begin
            {full_c,empty_c,error_c,sp_c} = {3'b010,3'd0};
        end
        else if (no_op_s)
        begin
            {full_c,empty_c,error_c,sp_c} = {full,empty,error,sp};
        end
        else
        begin
            if (sp == 3'd0)//sp is 0
            begin
                if (empty) //
                begin
                    case({push_s,pop_s})
                        2'b10://push
                        {full_c,empty_c,error_c,sp_c} = {1'b0,1'b0,1'b0,sp + 3'd1};

                        2'b01://pop
                        {full_c,empty_c,error_c,sp_c} = {1'b0,1'b1,1'b1,sp};

                        default:
                        {full_c,empty_c,error_c,sp_c} = {full,empty,error,sp};
                    endcase
                end
                else if(full)
                begin
                    //Full
                    case({push_s,pop_s})
                        2'b10://push
                        {full_c,empty_c,error_c,sp_c} = {1'b1,1'b0,1'b1,sp};

                        2'b01://pop
                        {full_c,empty_c,error_c,sp_c} = {1'b0,1'b0,1'b0, 3'd7};

                        default:
                        {full_c,empty_c,error_c,sp_c} = {full,empty,error,sp};
                    endcase
                end
                else
                    {full_c,empty_c,error_c,sp_c} = push_s ? {1'b0,1'b0,1'b0,sp+1} : {1'b0,1'b0,1'b0,3'd7} ;
            end
            else
            //Stack pointer is not 0
            begin
                if (pop_s)
                    {full_c,empty_c,error_c,sp_c} = (sp == 3'd1) ? {3'b010,3'd0} : {3'b000,sp - 3'd1} ;
                else if (push_s)
                    {full_c,empty_c,error_c,sp_c} = (sp == 3'd7) ? {3'b100,3'd0} : {3'b000,sp + 3'd1} ;
                else
                    {full_c,empty_c,error_c,sp_c} = {full,empty,error,sp};
            end
        end
    end

    //8x8 RAM operation
    integer i ;

    always@(posedge clk)
    begin
        if (clear_s)
        begin
            for(i = 0 ; i < 8 ; i = i+1)
                RAM[i] <= 8'dx ;
        end
        else
        begin
            if (push_s)
                RAM[sp] <= full ? RAM[sp] : data_in;
            else if (pop_s)
                if(full)
                    RAM[3'd7] <= 8'dx;
                else
                    RAM[sp-3'd1] <= 8'dx;
            else
                RAM[sp] <= RAM[sp];
        end
    end

    //dout reports the content of memory element addressed by $sp.
    assign dout     = RAM[sp];
    assign data_out = dout;

endmodule
