module VM(clk,
          rst,
          item,
          sel,
          dollar_10,
          dollar_50,
          price,
          item_rels,
          change_return);

    //Inputs
    input wire clk,rst,sel,dollar_10,dollar_50;
    input wire[1:0] item;
    //Outputs
    output wire change_return;
    output reg [7:0] price;
    output reg [2:0] item_rels;
    
    //Mid registers to help keep track of value, and enabling the changing of FSM
    reg [1:0] cur_item ;//Keep track of past item
    reg [7:0] cur_price ;//The price when selecting
    reg end_flag; //After the product is released, the price should be 0 until the next sel occurs.
    wire [7:0] cur_change_price;//The price when calculating changes
    wire en;//Know if we have to start calculate the change or not, calculate the change when enabled.
    wire rel; //The release signal generated by Price_FSM, can also be used to signal when the payment is over.
    
    
    //Encodings needed
    parameter WATER_P   = 20,BLACK_TEA_P   = 30,COKE_P   = 40,JUICE_P   = 50 ;//Price of products
    localparam  TEN       = 10, FIFTY       = 50 ; //Value of money
    localparam  WATER_SIG = 2'b00,BLACK_TEA_SIG = 2'b01,COKE_SIG = 2'b10,JUICE_SIG = 2'b11;//Signals for selections
    localparam  WATER_REL = 3'b100,BLACK_TEA_REL = 3'b101,COKE_REL = 3'b110,JUICE_REL = 3'b111 ;//Release Signals
    
    //End_flag indicated the end of calculation
    always @(posedge clk)begin
      if(rel)
        end_flag <= 1;
      else if(sel)
        end_flag <= 0;
      else
        end_flag <= end_flag;
    end
    
    //Logic determines current item,whenever sel or en changes, this should changes too.
    always @(negedge clk)begin
        if (rst)begin
            price         <= 0;
            item_rels     <= 0;
            cur_item      <= 0;
            cur_price     <= 0;
            end_flag      <= 0;
        end
        else if (!sel & en) //If en = 1 and sel != 1, start calculate the change, lock the cur_item until en = 0;
            cur_item <= cur_item;
        else //sel = 1 also en = 0 means the user is still selecting
            cur_item <= item;
    end
    
    //Output logic for current item to display current price.
    //if cur_item doesnt change,cur_price will not change, and if end_flag = 1, cur_price = 1;
    //Start with sel end with release
    always @(cur_item or rel)begin
    if(!rel)
    begin
        case(cur_item)
            WATER_SIG :     cur_price = WATER_P;
            BLACK_TEA_SIG:  cur_price = BLACK_TEA_P;
            COKE_SIG :      cur_price = COKE_P;
            JUICE_SIG:      cur_price = JUICE_P;
            default:        cur_price = WATER_P;
        endcase
    end
    else
        cur_price = cur_change_price;    
    end
    
    EN_FOR_CHANGE_FSM EN(.clk(clk),.rst(rst),.sel(sel),.en(en));
    PRICE_FSM PRICE(.clk(clk),.rst(rst),.en(en),.ten(dollar_10),.fifty(dollar_50),.price_to_pay(cur_price),.price_left(cur_change_price),.rel(rel),.change_return(change_return));
    
    // Cur_price might be changed when giving out changes, so we have to determine if the enable signal is on, end_flag is used to set price to 0 at the end of calculation
    assign price = end_flag ? 0: (en? cur_change_price : cur_price) ;
    
    //Release Signal logic
    always @(cur_item or rel)begin
        if (rel)
            case(cur_item)
                WATER_SIG: item_rels     = WATER_REL;
                BLACK_TEA_SIG: item_rels = WATER_REL;
                COKE_SIG : item_rels     = COKE_REL;
                JUICE_SIG : item_rels    = JUICE_REL;
            endcase
        else
            item_rels = 0;
    end
    
endmodule
