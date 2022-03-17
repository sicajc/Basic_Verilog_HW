//PRICE WIDTH
`define PWIDTH  8
//ITEM WIDTH
`define IWIDTH  2
//STATE WIDTH
`define S1WIDTH  3
`define S2WIDTH  2
//Encodings for L1 FSM
`define A_T_S 3'b001//About to select item
`define S     3'b010//Selecting item
`define P_C   3'b100// Paying and giving change
//Encodings for L2 FSM
`define IDLE   2'b00 //Idle state, waiting to pay, still selecting the item
`define PAY    2'b01 //Paying state, inserting the money D_10 D_50 price_to_pay > = 0
`define CHANGE 2'b10 //Giving changes price_to_pay < 0

module VM3 (input rst,
            input clk,
            input [1:0] item,
            input sel,
            input D_10,
            input D_50,
            output reg signed[7:0] value,
            output reg [3:0] price,
            output reg [2:0] item_rels,
            output reg change_return);
    
    DP datapath(.rst(rst),.clk(clk),.item(item),.D_10(D_10),.D_50(D_50),.value(value),.price(price),.item_rels(item_rels));
    CP controlpath(.rst(rst),.clk(clk),.sel(sel));
    
endmodule
    
    //DATAPATH
    module DP(input rst,input sel,input clk,input[1:0] item,input D_10,input D_50,output reg signed[7:0] value,output reg[3:0] price,output reg[2:0] item_rels,output reg zero,output reg less);
        
        //Encodings needed
        parameter WATER_P     = 20,BLACK_TEA_P     = 30,COKE_P     = 40,JUICE_P     = 50 ;//Price of products
        localparam  WATER_SIG = 2'b00,BLACK_TEA_SIG = 2'b01,COKE_SIG = 2'b10,JUICE_SIG = 2'b11;//Signals for selections
        localparam  WATER_REL = 3'b100,BLACK_TEA_REL = 3'b101,COKE_REL = 3'b110,JUICE_REL = 3'b111 ;//Release Signals
        
        
        localparam n = `PWIDTH ;
        localparam p = `IWIDTH;
        //Internal Wires
        wire[n-1:0] price_to_pay;
        wire[n-1:0] item_price;
        wire[p-1:0] sel_item;
        reg[n-1:0] m1_out;
        reg[n-1:0] item_value;
        
        reg[n-1:0] item_price_in;
        reg[p-1:0] sel_item_in;
        reg[n-1:0] price_to_pay_in;
        
        //Control Signals
        wire ldp;
        wire changing;
        wire en_rel;
        wire d_value;
        
        //Registers
        DFF #(n) Item_price(.clk(clk),.en(sel),.d(item_price_in),.q(item_price));
        DFF #(n) Price_to_pay(.clk(clk),.en(enP),.d(price_to_pay_in),.q(price_to_pay));
        DFF #(p) Selected_item(.clk(clk),.en(sel),.d(sel_item_in),.q(sel_item));
        
        //Reset Registers
        assign item_price_in   = rst ? 0 : item_value;
        assign sel_item_in     = rst ? 0 : item;
        assign price_to_pay_in = rst ? 0 : m1_out;
        
        //M1 mux for selecting input of price_to_pay register
        always@(*)
        begin
            casex({changing,D_10,D_50,ldp})
                4'b1xxx:    m1_out = price_to_pay + 10;
                4'b01xx:    m1_out = price_to_pay - 10;
                4'b001x:    m1_out = price_to_pay - 50;
                4'bxxx1:    m1_out = item_price;
                default:    m1_out = price_to_pay;
            endcase
        end
        //item_value decoder
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
        
        //release_item encoder
        always @(*)begin
            if (en_rel)
            begin
                case(sel_item)
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
        
        //MUX2 for selecting output value
        always@(*)
        begin
            casex(d_value)
                4'b1000: value = item_value;
                4'b0100: value = 0;
                4'b0010: value = item_price;
                4'b0001: value = price_to_pay;
                default: value = item_value;
            endcase
        end
        //Price->value encoder
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
        //Check if price_to_pay == 0
        assign zero = (price_to_pay == 0);
        //Check if price_to_pay < 0
        assign less = (price_to_pay < 0);
    endmodule
        
        //CONTROL_PATH
        module CP(input sel,
            input rst,
            input clk,
            output reg enP,
            output reg ldP,
            output reg d_value,
            output reg en_rel,
            output reg changing,
            output reg ldp);
            
            
            
        endmodule
            
            module DFF#(parameter n = 4)(input clk,input en,input[n-1:0] d,output reg[n-1:0] q);
                always@(posedge clk)
                    q <= en ? d : q;
            endmodule
                
                
                module L1_FSM(input rst,input clk,input sel,output reg action,output reg enP);
                    parameter L1 = `S1WIDTH;
                    reg[L1-1:0] next_state1;
                    reg[L1-1:0] next_state;

                    wire[L1-1:0] current_state;
                    
                    //State_reg
                    DFF #(L1) L1_state_reg(.clk(clk),.en(1),.d(next_state),.q(current_state));
                    
                    //Reset
                    assign next_state = rst ? `A_T_S : next_state1;
                    
                    //Next_state_logic
                    always@(*)
                    begin
                        case(current_state)
                            `A_T_S:
                            next_state1 = sel ? `S : `A_T_S;
                            `S:
                            next_state1 = sel ? `S : `P_C;
                            `P_C:
                            next_state1 = sel ? `S : `P_C;
                            default:
                            next_state1 = `IDLE;
                        endcase
                    end
                    //Output_logic
                    always@(*)
                    begin
                        case(current_state)
                            `A_T_S:
                            {enP,action} = {1'b0,1'b0};
                            `S:
                            {enP,action} = {1'b1,1'b0};
                            `P_C:
                            {enP,action} = {1'b1,1'b1};
                            default:
                            {enP,action} = {1'b0,1'b0};
                        endcase
                    end
                endmodule
                    
                    module L2_FSM(input rst,input clk,input action,input zero,input less,input signed[7:0] price_to_pay,output reg enRel,output changing,output d_value,output ldp);
                        parameter L2 = `S2WIDTH;
                        
                        
                        reg[L2-1:0] next_state1;
                        reg[L2-1:0] next_state;

                        wire[L2-1:0] current_state;
                        
                        //State register
                        DFF #(L2) L2_state_reg(.clk(clk),.en(1),.d(next_state),.q(current_state));
                        
                        //Reset state registers,we dont have to reset state register like this.
                        assign next_state = rst ? `IDLE  : next_state1;
                        
                        //Next state logic
                        always@(*)
                        begin
                            case(current_state)
                                `IDLE:
                                next_state = action ? `PAY : `IDLE;
                                `PAY:
                                if (zero)
                                    next_state = action ? `PAY : `IDLE;
                                else
                                    next_state = less ? `CHANGE : `PAY;
                                    `CHANGE:
                                    next_state = zero ? (action? `IDLE : `PAY ) : `CHANGE;
                                    default:
                                    next_state = `IDLE;
                            endcase
                        end
                        //Output logic
                        always@(*)
                        begin
                          case(current_state)
                            `IDLE:
                                ;


                          endcase
                        
                        end
                        
                    endmodule
                        
                        
                        
                        
