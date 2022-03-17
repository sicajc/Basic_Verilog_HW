module double_ram1024x8(input[9:0] addr,
                        input cs,
                        input rw,
                        input clk,
                        inout[15:0] data);

    ram1024x8 ram1(.addr(addr),.cs(cs),.rw(rw),.clk(clk),.data(data[15:8]));
    ram1024x8 ram2(.addr(addr),.cs(cs),.rw(rw),.clk(clk),.data(data[7:0]));

endmodule


/*
     //Test RAM1024x8 and dobule_RAM1024x8
     module ram1024x8_tb;
     reg[9:0] addr;
     reg cs,rw,clk,oe;
     reg[7:0] data1;
     wire[7:0] data_1;
     reg[15:0] data2;
     wire[15:0] data_2;
     integer k,myseed;

     ram1024X8 ram1(.clk(clk),.cs(cs),.rw(rw),.addr(addr),.data(data_1));
     double_ram1024x8 ram2(.clk(clk),.cs(cs),.rw(rw),.addr(addr),.data(data_2));
     assign data_1 = data1; //The port for data must be wire, but to change data value, it has to be reg
     assign data_2 = data2;
     initial begin
     clk    = 0;
     addr   = 0;
     myseed = 24;
     oe     = 0;

     for(k = 0;k< = 30;k = k+1) // Write data in.
     begin
     addr      = k % 1024;
     data2     = k % 64*1024;
     #20 data1 = (2*k) % 256;
     rw        = 1;
     cs        = 1;
     #20 rw    = 0; cs    = 0; // Turning on then turning off.
     end

     data1 = {8{1'bz}};
     data2 = {16{1'bz}};
     //data1 is being used to drive wire data, it should be set to z after usage!

     for(k = 0;k< = 30;k = k+1) //Read the Data out
     begin
     #20 addr = k % 1024;
     rw       = 0;
     cs       = 1;
     $display("Address:%5d,Data:%4d",addr,data_1);
     $display("Address:%5d,Data:%4d",addr,data_2);
     end

     #1000 $finish;
     end

     always #10 clk = ~clk;


     endmodule
     */