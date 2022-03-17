//FSM for Price_and_Changes
module PRICE_FSM(clk,
                 rst,
                 en,
                 sel,
                 ten,
                 fifty,
                 price_to_pay,
                 price_left,
                 rel,
                 change_return,
                 price_flag,
                 );
    //Inputs
    input clk,sel,rst,en,ten,fifty;
    input[7:0] price_to_pay;//Value for Initial state.
    
    //Outputs
    output reg [7:0] price_left;//Used to Display the remaining price to pay
    output reg rel; //The realease signal generated to allow for item to release from VM
    output reg change_return; // The change_return signal to indicate the coins return
    
    //Reg for tracking values
    output reg price_flag = 0;//So that we dont have to change the initial state
    
    parameter WATER_P = 20,BLACK_TEA_P = 30,COKE_P = 40,JUICE_P = 50 ;//Price of products
    
    //States for prices,4 bits needed for encoding
    localparam S0 = 0,S1 = 1,S2 = 2,S3 = 3,S4 = 4,S5 = 5,S6 = 12, S7 = 13, S8 = 14, S9 = 15;
    
    
    //State registers
    reg [3:0] current_state,next_state,init_state;
    
    //Com Logic to determine initial input states,changes only when en = 1
    /*WTF is this? The only thing that should be sequential should only be related to clock.
    Thus such coding style should be prevented at all cost!*/
    always @(posedge en)
    begin
        if (en)
        begin
            case(price_to_pay)
                WATER_P :      init_state = S2;
                BLACK_TEA_P:   init_state = S3;
                COKE_P :       init_state = S4;
                JUICE_P:       init_state = S5;
                default:       init_state = S2;
            endcase
        end
    end
    
    //State_registers
    //if en = 1, price_flag = 1 then current_state is always next state. However,init_state is not latched.
    //When is price_flag = 1? After the initial state is set at the first time.
    /*Within the state register, the only thing that should be changing is current_state, nothing else*/
    always@(posedge clk or en) //En must be added to sensitivity list here, so that we can have the right output
    begin//We should not add en and posedge clk into the state register, only clk should be included, but in this case, it is needed?
        if (rst) 
        begin
            current_state <= init_state;
            next_state    <= 0;
            price_flag    <= 0;
            rel           <= 0;
            change_return <= 0;
            price_left    <= 0;
        end
        else if(!en)
        begin
            current_state <= init_state;
            price_flag    <= 0;
            rel           <= 0;
            change_return <= 0;
            price_left    <= price_to_pay;
        end
        else
        begin  
            current_state <= price_flag ? next_state : init_state;
            //Current_state should be set to initial state if price_flag = 0, means we havent set the initial state yet
        end    
            //Price_flag = 1 means we have already set the initial state,keep counting
            //Set the Initial state for counting.
    end
        
        
        //Excitation logic
        //First TB pays 3 $10 then 1 $50, however when selecting 3 different items, strange things occurs
        always @(current_state or ten or fifty)
        begin
            case(current_state)
                S0: //0
                next_state    = S0;
                S1: //10
                next_state = fifty ? S6 : (ten ? S0 : current_state); //A clean coding style for if else
                S2: //20
                next_state = fifty ? S7 : (ten ? S1 : current_state);
                S3: //30
                    next_state = fifty ? S8 : (ten ? S2 : current_state) ;
                S4: //40
                    next_state = fifty ? S9 : (ten ? S3 : current_state);
                S5: //50
                    next_state = fifty ? S0: (ten ? S4 : current_state) ;
                S6: //-40
                    next_state    = S7;
                S7: //-30
                    next_state    = S8;
                S8: //-20
                    next_state    = S9;
                S9: //-10
                    next_state    = S0;
                default:
                    next_state    = S0;
               
            endcase
        end
        
        //Output logic
        /*The output signal within the case shall always have the same number of statements.
          Everything related to the output should only be written here, nothing else, the output might be
          dependent on other signals*/
        always @(current_state) begin 
            //When writing FSM, the changing of output should only be written within Output logic!
            case(current_state)
                S0:
                begin
                    rel = price_flag ? 1 : 0; //Release drink only if price_flag is originally 1.
                    price_left = 0;
                    price_flag = 0;
                    change_return = 0;
                end
                S1:
                begin
                    rel        = 0; //Release Signal should be one here
                    price_left = 10; //Means you still have 10 dollars to pay
                    price_flag = 1; //We are still calculating the price and change
                    change_return = 0;
                end
                S2:
                begin
                    rel        = 0;
                    price_left = 20; //Means you still have 20 dollars to pay
                    price_flag = 1;
                    change_return = 0;
                end
                S3:
                begin
                    rel        = 0;
                    price_left = 30;
                    price_flag = 1;
                    change_return = 0;
                end
                S4:
                begin
                    rel        = 0;
                    price_left = 40;
                    price_flag = 1;
                    change_return = 0;
                end
                S5:
                begin
                    rel        = 0;
                    price_left = 50;
                    price_flag = 1;
                    change_return = 0;
                end
                S6:
                begin
                    rel        = 0;
                    price_left = -40; //Just display the negative value on screen
                    price_flag = 1;
                    change_return = 1;
                end
                S7:
                begin
                    rel        = 0;
                    price_left = -30;
                    price_flag = 1;
                    change_return = 1;
                end
                S8:
                begin
                    rel        = 0;
                    price_left = -20;
                    price_flag = 1;
                    change_return = 1;
                end
                S9:
                begin
                    rel        = 0;
                    price_left = -10;
                    price_flag = 1;
                    change_return = 1;
                end
                default:
                begin
                    rel        = 0;
                    price_left = 0;
                    price_flag = 1;
                    change_return = 1;
                end
            endcase
        end
        endmodule
