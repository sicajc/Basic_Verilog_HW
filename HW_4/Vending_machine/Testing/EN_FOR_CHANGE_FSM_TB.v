module EN_FOR_CHANGE_FSM_TB;
reg RST = 0,CLK= 1,SEL= 0;
wire EN;
integer i; 
EN_FOR_CHANGE_FSM DUT(.clk(CLK), .rst(RST),.sel(SEL),.en(EN));
      
    initial begin
        CLK = 1;
        #5;
        for(i = 0 ; i<40 ; i = i+1)
        begin
            //RST
            RST = (i == 1 | i == 31) ? 1:0;
            //SEL
            case(i)
                3: SEL  = 1;
                4: SEL  = 1;
                15: SEL = 1;
                26: SEL = 1;
                default:
                SEL = 0;
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
