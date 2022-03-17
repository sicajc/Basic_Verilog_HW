module Comparator(a,b,greater,equal,less);

input[15:0] a;
input[15:0] b;

output greater;
output equal;
output less;

wire [3:0]gt ; //U can actually connect wire like this.
wire [3:0]lt ;
wire [3:0]eq ;

wire[3:0] hello;

Comparator_lv1 c0(.a(a[3:0]),.b(b[3:0]),.gt(gt[0]),.eq(eq[0]),.lt(lt[0]));
Comparator_lv1 c1(.a(a[7:4]),.b(b[7:4]),.gt(gt[1]),.eq(eq[1]),.lt(lt[1]));
Comparator_lv1 c2(.a(a[11:8]),.b(b[11:8]),.gt(gt[2]),.eq(eq[2]),.lt(lt[2]));
Comparator_lv1 c3(.a(a[15:12]),.b(b[15:12]),.gt(gt[3]),.eq(eq[3]),.lt(lt[3]));

Comparator_lv2 r1(.gt(gt[3:0]),.lt(lt[3:0]),.a_gt_b(greater),.a_eq_b(equal),.a_lt_b(less));


endmodule
