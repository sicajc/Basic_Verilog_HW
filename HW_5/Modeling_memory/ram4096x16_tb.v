module ram4096x16_tb();
    reg[11:0] addr;
    reg rw,clk;
    reg[15:0] data_in;
    reg[31:0] i,k;

    ram4096x16 ram_test(.clk(clk),.addr(addr),.rw(rw),.data(data));

    assign data = rw ? data_in : 16'hzzzz;

    //to write rw = 1, to read rw = 0

    always #5 clk= ~clk;


    initial begin
    clk = 0;
        //Ask TA how to concatenate it using varialbe and debug skill in verilog.
        //Write data_in
        for(k = 0;k<8;k = k+1)
            for(i = 0;i<15;i = i+4)
            begin
                rw = 1; addr = 12'h000+i*12'd256+k ; 16'h0000 + k*12'd256 + i;
                 #20;
            end
        //Read data_in
        for(k = 1;k<5;k = k+1)
            for(i = 0;i<15;i = i+4)
            begin
                rw = 0 ; addr = 12'h000 + i;
                #20;
            end

        //Write data2
        for(k = 0; k<8; k = k+1)
            for(i = 0;i<15;i = i+4)
            begin
                rw = 1; addr = 12'h000+i*12'd256+k ; 16'h0000 + k*12'd256 + i;
                 #20;
            end

        //Read data_in
        for(k = 3;k>=0;k = k-1)
            for(i = 0;i<15;i = i+4)
            begin
                {rw,addr} = {1,12'h000 + i*12'd256 + k};
                 #20;
            end

         #10 $finish;
    end

endmodule
