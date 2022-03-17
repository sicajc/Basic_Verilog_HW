module Uni_Counter(data,mode,clear,incr,pause,clk,count);
//A basic 4 bit counter
//When solving problem, making a few simple examples then draw out the flow chart is 
//a good way to solve problem.

input[3:0] data = 4'b0000; //If clear = 1, count[3:0] is reset at POS_EDGE of clock
input mode; //Hex counting if mode = 1 , decimal if mode = 0;
input clear; // Counting upward if incr = 1 , counting downward if incr = 0;
input incr; //Counting suspended when pause = 1
input clk; 


output[3:0] count; //Counter Output, reg type
reg [3:0] count = 4'b0000; // reg var
reg upper;
//Priority of control Clear > pause.
// If clear is 1 , should we still count it?
// Should we have an upper bound and lower bound for this counter?

always @(posedge clk)
  begin
  if(clear) 
    count = 4'b0000;
  else if(pause)
    count = count;  
  else
    begin
      if(mode)//mode = 1. count in decimal
         upper = 10;      
      else
         upper = 16; 

      if(incr)//incr = 1, c = c + 1 
         count = count + 1;
      else
         begin
         count = count - 1;
         if((count == 4'b1111))
            if(!mode)//Hex 0000 - 1 = 1111
              count = 4'b1010; 
         else 
            count = count; // If it is deciaml 0000 - 1 = 1010
         end

      if( upper == count)
         count = 4'b0000;
      
   end

  end

endmodule  
