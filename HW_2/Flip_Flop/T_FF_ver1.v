module T_FF(q,clk,rst);

output q;
input clk,rst; 
reg q = 1'b0; //reset value 

always @(posedge clk or ~rst) begin
  
  if(~rst) // if reset signal is 0, we reset the reg.
    q <=1'b0; //reset to initial value
  else //Otherwise we flips every value when clock positive triggered
    q = ~q;
    
end
endmodule