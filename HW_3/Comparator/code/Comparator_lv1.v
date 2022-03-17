module Comparator_lv1(a,b,gt,eq,lt);

input[3:0] a;
input[3:0] b;

//Add delays gt,eq,lt #3 #5 #4

output gt;
output eq;
output lt;
reg gt,eq,lt; // Ouput must be regs

//reg[3:0] i1;
//reg[3:0] i2;

always @(*)
begin

  if( a > b )begin
    gt <= #3 1;
    eq <= #5 0;
    lt <= #4 0;
  end
  else if(a == b) begin
    eq <= #5 1;
    gt <= #3 0;
    lt <= #4 0;
  end
  else begin
    lt <= #4 1;
    eq <= #5 0;
    gt <= #3 0; 
  end   
end

endmodule   