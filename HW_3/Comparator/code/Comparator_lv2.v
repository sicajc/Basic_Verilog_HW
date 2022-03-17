module Comparator_lv2(gt,lt,a_gt_b,a_eq_b,a_lt_b);

input[3:0] gt;
input[3:0] lt;

output a_gt_b;
output a_eq_b;
output a_lt_b;

reg a_gt_b , a_eq_b , a_lt_b;

always @(*)
begin
  if( gt > lt) // Note assign should be be used in if_else
    begin //Every reg must be assigned some sort of value in statement,otherwise
    //They might become floating variables.
    
     a_gt_b <=#3 1; //<= would execute the program concurrently i.e. non-blocking
     a_lt_b <=#4 0; //For combinational circuit, since they are all executing concurrently
     a_eq_b <=#5 0; //We should use non blocking, unless they are executed sequentially
                    //Using them wrong might lead to register receving the wrong value
    end 
  else if(gt < lt)
    begin
     
     a_gt_b <=#3 0;
     a_lt_b <=#4 1;
     a_eq_b <=#5 0;

    end  
  else
    begin
     
     a_gt_b <=#3 0;
     a_lt_b <=#4 0;
     a_eq_b <=#5 1;

    end
end  

endmodule
