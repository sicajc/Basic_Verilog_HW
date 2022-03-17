//FSM for selection signal, so that we can obtain the enable signal to allow for changes calculation
module EN_FOR_CHANGE_FSM(clk,
                         rst,
                         sel,
                         en);
    //Inputs
    input clk,rst,sel;
    //Outputs
    output reg en;
    
    //States S0 means 0->1, S1 means 1->1 S2 means 1->0, S2 state means the user finish selecting
    //Once FSM leaves S0, it would not come back to S0 
    //S0 needed for inital start after reset
    //consider sel sequence 00110001,the first 01 should not enable,the second 01 however does enable the item.
    localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    
    //State registers
    reg[1:0] next_state,current_state;
    always @(negedge clk or posedge clk) begin 
        if (rst)
        begin //This is a terrible coding style, within state register, the only thing that is changing should be current_state
            next_state    <= S0;
            current_state <= S0;
            en            <= 0;
        end
        else
            current_state <= next_state;
    end
    
    //Excitation Logic
    always @(*)begin //When using Combinational logic, always(*) is used.
                     //A Clean coding style for if else statement
        case(current_state)
            S0:
            next_state = sel  ? S1 : S0;  
            S1:
            next_state = sel  ? S1 : S2;
            S2:
            next_state = sel  ? S1 : S2;
        endcase
    end
    
    //Output logic
    always @(*) begin
        case(current_state)
            S0: en      = 0;
            S1: en      = 0;
            S2: en      = 1;
            default: en = 0;
        endcase
    end
    
endmodule
    
