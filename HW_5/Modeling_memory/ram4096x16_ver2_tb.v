`include "ram4096x16.v"
module ram4096x16_tb();
    reg[11:0] addr;
    reg[31:0] i;
    reg[15:0] data_in;
    wire[15:0] data;
    reg rw,clk;

    ram4096x16 ram_test(.clk(clk),.addr(addr),.rw(rw),.data(data));

    assign data = rw ? data_in : 16'hzzzz;

    //to write rw = 1, to read rw = 0
    always #5 clk= ~clk;

    initial begin
    clk = 0;
        //Ask TA how to concatenate it using varialbe and debug skill in verilog.
        //Write data_in_1
        for(i=0;i<7;i=i+1)
        begin
            #10 rw=1;addr=12'h000+i;data_in=16'h0000+i;
            #10 rw=1;addr=12'h400+i;data_in=16'h0400+i;
            #10 rw=1;addr=12'h800+i;data_in=16'h0800+i;
            #10 rw=1;addr=12'hc00+i;data_in=16'h0c00+i;
        end

        //read_1
        for(i = 1; i<=4; i = i+1)
        begin
          #10 rw=0;addr = 12'hc00+i;
          #10 rw=0;addr = 12'h800+i;
          #10 rw=0;addr = 12'h400+i;
          #10 rw=0;addr = 12'h000+i;
        end


        //Write 2
        for(i=0;i<=7;i=i+1)
        begin
          #10 rw=1;addr=12'h000+i;data_in = 16'h0000 + i*256;
          #10 rw=1;addr=12'h400+i;data_in = 16'h0004 + i*256;
          #10 rw=1;addr=12'h800+i;data_in = 16'h0008 + i*256;
          #10 rw=1;addr=12'hc00+i;data_in = 16'h000c + i*256;
        end

        //Read data_in_2
        for(i=3;i>=0;i=i-1)
        begin
          #10 rw=0;addr = 12'h000+i;
          #10 rw=0;addr = 12'h400+i;
          #10 rw=0;addr = 12'h800+i;
          #10 rw=0;addr = 12'hc00+i;
        end

         #10 $finish;
    end

endmodule
