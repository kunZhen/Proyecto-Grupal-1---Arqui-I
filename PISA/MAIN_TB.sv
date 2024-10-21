`timescale 1ns / 1ps

module MAIN_TB;

    // Inputs
    reg CLK;
    reg switch;
    reg wren;
    reg [31:0] data;
    reg PS2_CLK;
    reg PS2_DAT;

    // Outputs
    wire vgaclk;
    wire hsync;
    wire vsync;
    wire sync_b;
    wire blank_b;
    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;
    wire [7:0] q;
    wire [17:0] rdaddress;
    wire [17:0] wraddress;
    wire [6:0] HEX0;
    wire [6:0] HEX1;
    wire [6:0] HEX2;
    wire [6:0] HEX3;
    wire [6:0] HEX4;
    wire [6:0] HEX5;

    // Instantiate the Unit Under Test (UUT)
    MAIN uut (
        .CLK(CLK),
        .switch(switch),
        .vgaclk(vgaclk),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .red(red),
        .green(green),
        .blue(blue),
        .wren(wren),
        .data(data),
        .q(q),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    initial begin
        // Initialize inputs
        CLK = 0;
        switch = 0;
        wren = 0;
        data = 32'h0000_0000;
        PS2_CLK = 0;
        PS2_DAT = 0;

        // Wait 100 ns for global reset to finish
        #100;

        // Add stimulus here
        switch = 1;
        wren = 1;
        data = 32'hFFFF_FFFF;

        #100;

        switch = 0;
        wren = 0;
        data = 32'h0000_0000;

        #100;

        $finish;
    end

    always #10 CLK = ~CLK; // Clock generation

endmodule