module longest_one_tb() ;

reg clk=1  ;
reg count=0 ;
integer i ;
reg [2:0] din ;
reg [5:0] count_1 ;
wire [3:0] length ;
reg [4:0] length_sample [0:15];

longest_one_detector U0 (.rst(0),.clk(clk) , .count(count) , .din(din)   , .length(length)  );


always begin
#5 clk = ~clk ;
end
initial begin
clk = 1 ;  count=0 ;
# 12 count = 1 ;
wait (count_1==13) ;
count = 0 ;
end

always @ (negedge clk )begin
if (count==0)
	begin
	din <= 3'b111;
	count_1 <= 'd0 ;
	end
	else begin
	count_1 <= count_1+1  ;
	case (count_1)
	0:din<=3'b000;
	1:din<=3'b110;
	2:din<=3'b101;
	3:din<=3'b111;
	4:din<=3'b011;
	5:din<=3'b111;
	6:din<=3'b100;
	7:din<=3'b001;
	8:din<=3'b101;
	9:din<=3'b011;
	10:din<=3'b111;
	11:din<=3'b111;
	12:din<=3'b110;
	13:din<=3'b111;
	14:din<=3'b000;
	15:din<=3'b000;
	default:din<=3'b000;
	endcase

	end

end

initial begin
length_sample [ 0 ]= 0 ; length_sample [ 1 ]= 0 ; length_sample [ 2 ]= 0 ;
length_sample [ 3 ]= 2 ; length_sample [ 4 ]= 2 ;
length_sample [ 5 ]= 4 ; length_sample [ 6 ]= 4 ;
length_sample [ 7 ]= 5 ;
length_sample [ 8 ]= 6 ; length_sample [ 9 ]= 6 ; length_sample [ 10 ]= 6 ; length_sample [ 11 ]= 6 ; length_sample [ 12 ]= 6 ;
length_sample [ 13 ]= 8 ;
length_sample [ 14 ]= 0 ; length_sample [ 15 ]= 0 ;

for (i = 0 ; i<= 15  ; i = i+1)
begin
	@(negedge clk )
	begin
		if(length_sample[i] != length)
		begin
		$display ("Wrong Length , The Length should be %d" , length_sample[i]);
		$stop;
		end
	end
end
	$display ("congratulations~! Success~!");
	$stop;
end


endmodule
