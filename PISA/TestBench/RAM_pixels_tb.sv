`timescale 1ns / 1ps

module RAM_pixels_tb;

  // Parameters
  reg clock;
  reg [7:0] data;
  reg [17:0] rdaddress;
  reg [17:0] wraddress;
  reg wren;
  wire [7:0] q;

  // Instantiate the RAM_pixels module
  RAM_pixels UUT (
    .clock(clock),
    .data(data),
    .rdaddress(rdaddress),
    .wraddress(wraddress),
    .wren(wren),
    .q(q)
  );

  // Clock generation
  always #5 clock = ~clock;

  initial begin
    // Initialize signals
    clock = 0;
    wren = 0;
    data = 8'h00;
    wraddress = 18'h00000;
    rdaddress = 18'h00000;

    // Test scenario
    $display("Starting RAM test...");

    // Read cycle 1: Read data from address 0
    #10;
    rdaddress = 18'h00000;
    #10;
    $display("Read data from address 0: %h (Expected: AA)", q);

    // Read cycle 2: Read data from address 1
    #10;
    rdaddress = 18'h00001;
    #10;
    $display("Read data from address 1: %h (Expected: BB)", q);
	 
	 #10;
    rdaddress = 18'h00010;
    #10;
	 rdaddress = 18'h00011;
    #50;


    // Test complete
    $display("RAM test complete.");
    $stop;
  end

endmodule
