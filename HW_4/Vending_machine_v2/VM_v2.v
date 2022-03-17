module VM_v2 (input rst,
              input clk,
              input [1:0] item,
              input sel,
              input D_10,
              input D_50,
              output reg signed[7:0] value,
              output reg [3:0] price,
              output reg [2:0] item_rels,
              output reg change_return);

    //Encodings needed
    parameter WATER_P     = 20,BLACK_TEA_P     = 30,COKE_P     = 40,JUICE_P     = 50 ;//Price of products
    localparam  WATER_SIG = 2'b00,BLACK_TEA_SIG = 2'b01,COKE_SIG = 2'b10,JUICE_SIG = 2'b11;//Signals for selections
    localparam  WATER_REL = 3'b100,BLACK_TEA_REL = 3'b101,COKE_REL = 3'b110,JUICE_REL = 3'b111 ;//Release Signals

    //MAIN CONTROL
    //Level_1 FSM
    wire[1:0] action;
    L1_FSM FSM1(.rst(rst),.clk(clk),.sel(sel),.action(action));
    //Encoding state for output Action
    localparam AS = 2'b00 ; // About to select(AS)
    localparam S = 2'b01 ; // Selecting(S)
    localparam P_C = 2'b10 ; // Paying and change releasing(P_C)

    //Encoding states for Main_FSM
    localparam I = 2'b00 ; // Initial state(I)
    localparam D = 2'b01 ; // Determining item to load
    localparam C_R = 2'b10 ; // Calculating change and release item

    //Internal variables
    reg signed[7:0] item_value;    //item value
    reg signed[7:0] c_money_to_pay;//Combination money to pay
    reg rel_sig; //Signal indicating enabling releasing the item


    //Registers
    reg[1:0] cur_item;     //Register holding current item
    reg signed[7:0] money_to_pay; //Register for money_to_pay, note that this must be signed!
    reg signed[7:0] sel_value;   //Register to hold selected item price

    //State register
    reg[1:0] current_state,next_state;
    always@(negedge clk)
        current_state <= rst ? I : next_state;
        //Excitation logic
        always@(*)
        begin
            case(current_state)
                I:
                next_state = (action == S) ? D : I;
                D:
                next_state = (action == P_C) ? C_R : D;
                C_R:
                next_state = (money_to_pay == 0) ? D : C_R;
                default:
                next_state = I;
                /*
                 if (money_to_pay == 0)
                 next_state = D;
                 else
                 next_state = C_R;
                 default:
                 next_state = I;
                 */
            endcase
        end

    //Output logic and datapath
    //sel_value Register
    always@(posedge clk)
    begin
        if (rst)
            sel_value <= 0;
        else
            if (sel)
                sel_value <= item_value;
            else
                sel_value <= sel_value;
    end

    //Money_to_pay_register
    always @(posedge clk)
    begin
        if (rst)
            money_to_pay <= 0;
        else begin
            case(current_state)
                I: money_to_pay <= 0;
                D:
                money_to_pay <= sel_value;
                C_R:
                begin
                    money_to_pay <= sel_value;
                    if (money_to_pay != 0)
                    begin
                        if (money_to_pay > 0)//Beware that money_to_pay has to be signed to use > or <=
                            if (D_10)
                                money_to_pay <= c_money_to_pay;
                            else if (D_50)
                                money_to_pay <= c_money_to_pay;
                            else
                                money_to_pay <= money_to_pay;
                                else
                                money_to_pay <= c_money_to_pay;
                            end
                        else
                            money_to_pay <= sel_value;
                    end
                    default:
                    money_to_pay <= money_to_pay;
            endcase
        end
    end

    //Seperating the combination and sequential logics
    always@(*)
    begin
        if (D_10)
            c_money_to_pay = (money_to_pay - 10);
        else if (D_50)
            c_money_to_pay = (money_to_pay - 50);
        else
            c_money_to_pay = (money_to_pay + 10);
    end

    //cur_item_register
    always@(posedge clk)
    begin
        if (rst) cur_item <= 0;
        else
        begin

        case(current_state)
            I:
            cur_item <= sel? item : cur_item;
            D:
            begin
                if (action == S & sel)
                    cur_item <= item;
                else
                    cur_item <= cur_item;
            end
            C_R:
                cur_item <= sel? item : cur_item;
            default:
                cur_item <= WATER_SIG;
        endcase
    end
    end

    //Output Signals
    always@(*)
    begin
        case(current_state)
            I:
            begin
                rel_sig       = 0;
                change_return = 0;
            end
            D:
            begin
                rel_sig       = 0;
                change_return = 0;
            end
            C_R:
            begin
                change_return = (money_to_pay < 0) ? 1:0; //Less than 0 in C_R state means we need to give change
                rel_sig       = (money_to_pay == 0) ? 1 : 0;    //Equal 0 in C_R state means we have to release the item
            end
        endcase
    end

    //Logic solving the difference in Money_to_pay reg and sel_value when sel = 1
    assign money_to_pay = sel? ((money_to_pay != sel_value) ? sel_value : money_to_pay) : money_to_pay;

    //Release: encoder
    always @(*)begin
        if (rel_sig)
        begin
            case(cur_item)
                WATER_SIG:      item_rels = WATER_REL;
                BLACK_TEA_SIG:  item_rels = BLACK_TEA_REL;
                COKE_SIG :      item_rels = COKE_REL;
                JUICE_SIG :     item_rels = JUICE_REL;
                default:        item_rels = 0;
            endcase
        end
        else
            item_rels = 0;
    end
    // VALUE : item_value Decoder
    always @(*)
    begin
        case(item)
            WATER_SIG :     item_value = WATER_P;
            BLACK_TEA_SIG:  item_value = BLACK_TEA_P;
            COKE_SIG :      item_value = COKE_P;
            JUICE_SIG:      item_value = JUICE_P;
            default:        item_value = WATER_P;
        endcase
    end

    /*
     Price
     Output depends on state, count with money_to_pay if in "paying and changing state" else count with selected item value
     This is found with the analysis of waveform
     */
    assign value = (D_10 == 0 && D_50 == 0 && action == S) ? item_value : ((current_state == D)? sel_value : money_to_pay);

    //Value->Price Encoder
    always@(*)
    begin
        case(value)
            0:  price      = 4'b0000;
            10: price      = 4'b0001;
            20: price      = 4'b0010;
            30: price      = 4'b0011;
            40: price      = 4'b0100;
            50: price      = 4'b0101;
            -40:price      = 4'b1100;
            -30:price      = 4'b1101;
            -20:price      = 4'b1110;
            -10:price      = 4'b1111;
            default: price = 4'b0000;
        endcase
    end
endmodule


    //1st stage FSM generating the current state of Vending machine
    module L1_FSM(input rst,input clk,input sel,output reg [1:0] action);
        localparam AS = 2'b00 ; // About to select after reset
        localparam S = 2'b01 ; // Selecting
        localparam P_C = 2'b10 ; // Paying and change releasing

        //State register
        reg[1:0] current_state,next_state;

        always@(posedge clk)
            if (rst)   current_state <= AS;
            else current_state       <= next_state;

        //Excitation logic
        always@(*)begin
            case(current_state)
                AS: next_state      = sel ? S : AS;
                S: next_state      = sel ? S : P_C;
                P_C: next_state      = sel ? S : P_C;
                default: next_state = AS;
            endcase
        end
        //Output logic
        always@(*)begin
            case(current_state)
                AS:   action    = AS;
                S:   action    =  S;
                P_C:   action    = P_C;
                default: action = AS;
            endcase
        end
    endmodule
