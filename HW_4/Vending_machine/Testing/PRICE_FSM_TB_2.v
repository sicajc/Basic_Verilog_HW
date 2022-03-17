module PRICE_FSM_TB; 
reg RST = 0, CLK = 1, SEL = 0, DOLLAR_10 = 0, DOLLAR_50 = 0;
reg [7:0] PRICE_TO_PAY; 
wire [7:0] PRICE_LEFT; 
wire CHANGE_RETURN; 
wire EN; 
wire FLAG;
integer i; 
EN_FOR_CHANGE_FSM change_en(.clk(CLK), .rst(RST), .sel(SEL), .en(EN));
PRICE_FSM price(.clk(CLK), .rst(RST), .en(EN),.sel(SEL),
.ten(DOLLAR_10),.fifty(DOLLAR_50),
.price_to_pay(PRICE_TO_PAY),.price_left(PRICE_LEFT),
.rel(REL),.change_return(CHANGE_RETURN),.price_flag(FLAG));
    
    initial begin
        PRICE_TO_PAY = 40;
        CLK = 1;
        #5;
        for(i = 0 ; i<40 ; i = i+1)
        begin
            //RST
            RST = (i == 1 | i == 31) ? 1:0;
            //SEL and PRICE TO PAY
            case(i)
                3:
                begin
                    SEL          = 1;
                    PRICE_TO_PAY = 40;
                end
               
                4:  
                begin 
                    SEL       = 1;
                    PRICE_TO_PAY = 50;
                end
                15:
                begin 
                SEL = 1;
                PRICE_TO_PAY = 20;
                end
                26:
                begin 
                    SEL = 1;
                    PRICE_TO_PAY=30;
                end    
                default:
                SEL = 0;
            endcase
            //DOLLAR_10
            case (i)
                6:DOLLAR_10 = 1;
                7:DOLLAR_10 = 1;
                8:DOLLAR_10 = 1;
                default:
                DOLLAR_10 = 0;
            endcase
            //DOLLAR_50
            case (i)
                9: DOLLAR_50  = 1;
                21 :DOLLAR_50 = 1;
                28: DOLLAR_50 = 1;
                default:
                DOLLAR_50 = 0;
            endcase
            #10;
        end
    end
    
    always
    begin
    #5;
    CLK = ~CLK;
    end
    
    
endmodule
