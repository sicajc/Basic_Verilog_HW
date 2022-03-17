module PRICE_FSM_TB;
reg RST = 0,CLK= 1,SEL= 0,
EN = 0,TEN = 0,FIFTY =0;
reg [3:0] PRICE_TO_PAY = 0;

wire [3:0] PRICE_LEFT; 
wire [2:0] ITEM_RELS; 
wire CHANGE_RETURN; 
integer i;

PRICE_FSM DUT(.clk(CLK), .rst(RST), .en(EN),);
      
    initial begin
        CLK = 1;
        #5;
        for(i = 0 ; i<40 ; i = i+1)
        begin
            //RST
            RST = (i == 1 | i == 31) ? 1:0;
            //ITEM
            case(i)
                3: ITEM  = 1;
                4: ITEM  = 2;
                5: ITEM  = 3;
                25: ITEM = 2;
                26: ITEM = 3;
                27: ITEM = 2;
                default:
                ITEM = 0;
            endcase
            //SEL
            case(i)
                3: SEL  = 1;
                4: SEL  = 1;
                15: SEL = 1;
                26: SEL = 1;
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
