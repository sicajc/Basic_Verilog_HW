module Counter_tb;

reg clear; //If clear = 1, count[3:0] is reset at POS_EDGE of clock
reg mode; //Hex counting if mode = 1 , decimal if mode = 0;
reg incr; // Counting upward if incr = 1 , counting downward if incr = 0;
reg pause; //Counting suspended when pause = 1
reg clk;
wire [3:0] count;

UC_V2 #(.n(4))u1(.clear(clear),.mode(mode),.incr(incr),.pause(pause),.clk(clk),.count(count));

initial
begin
    clk = 0;
    clear = 1; //0
    pause = 0;
    mode = 0;
    incr = 1;
    #20
    clear = 0; // 20
    pause = 0;
    mode = 0;
    incr = 1;
    #60
    clear = 0; // 80
    pause = 1;
    mode = 0;
    incr = 1;
    #10
    clear = 0; //90
    pause = 1;
    mode = 0;
    incr = 0;
    #20
    clear = 0; //110
    pause = 0;
    mode =  0;
    incr =  0;
    #60
    clear = 1; //170
    pause = 0;
    mode = 0;
    incr = 0;
    #10
    clear = 0; //180
    pause = 0;
    mode = 1;
    incr = 1;
    #60
    clear = 0; //240
    pause = 0;
    mode = 1;
    incr = 0;
    #20
    clear = 0; //260
    pause = 0;
    mode = 1;
    incr = 1;
    #140
    clear = 0; //400
    pause = 1;
    mode = 1;
    incr = 1;
end

always #10
begin //being_end should always be used to prevent errors

  clk = ~clk;

end


endmodule