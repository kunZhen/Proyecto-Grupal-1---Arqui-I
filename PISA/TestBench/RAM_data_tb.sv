`timescale 1 ps / 1 ps

module RAM_data_tb;

  // Inputs
  reg clock;
  reg [31:0] data;
  reg [16:0] rdaddress;
  reg [16:0] wraddress;
  reg wren;

  // Outputs
  wire [31:0] q;

  // Instantiate the RAM_data module
  RAM_data uut (
    .clock(clock), 
    .data(data), 
    .rdaddress(rdaddress), 
    .wraddress(wraddress), 
    .wren(wren), 
    .q(q)
  );

  // Clock generation (50 MHz)
  always #10 clock = ~clock;

  initial begin
    // Initialize Inputs
    clock = 0;
    data = 0;
    rdaddress = 0;
    wraddress = 0;
    wren = 0;

    // Wait for global reset
    #20;
	 
	 rdaddress = 17'd1;
    #20; // Wait for one clock cycle
	 rdaddress = 17'd2;
    #20; // Wait for one clock cycle
	 rdaddress = 17'd3;
    #20; // Wait for one clock cycle
    
    // Write data to address 0
    data = 32'hA5A5A5A5;
    wraddress = 17'd0;
    wren = 1;
    #20; // Wait for one clock cycle
    
    // Write data to address 1
    data = 32'hA;
    wraddress = 17'd1;
    wren = 1;
    #20; // Wait for one clock cycle

    // Disable write enable
    wren = 0;
    #20;

    // Read from address 0
    rdaddress = 17'd0;
    #20; // Wait for one clock cycle
    
    // Read from address 1
    rdaddress = 17'd1;
    #20; // Wait for one clock cycle
	 rdaddress = 17'd2;
    #20; // Wait for one clock cycle
	 rdaddress = 17'd3;
    #20; // Wait for one clock cycle
	 
	 rdaddress = 17'd9;
    #60; // Wait for one clock cycle
    
    // End simulation
    $stop;
  end

endmodule
