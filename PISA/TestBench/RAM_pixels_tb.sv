`timescale 1ns/1ps

module RAM_pixels_tb;

  // Testbench signals
  reg [16:0] address_a, address_b;
  reg [3:0] byteena_a, byteena_b;
  reg clock;
  reg [31:0] data_a, data_b;
  reg rden_a, rden_b;
  reg wren_a, wren_b;
  wire [31:0] q_a, q_b;

  // Instantiate the RAM_pixels module
  RAM_pixels uut (
    .address_a(address_a),
    .address_b(address_b),
    .byteena_a(byteena_a),
    .byteena_b(byteena_b),
    .clock(clock),
    .data_a(data_a),
    .data_b(data_b),
    .rden_a(rden_a),
    .rden_b(rden_b),
    .wren_a(wren_a),
    .wren_b(wren_b),
    .q_a(q_a),
    .q_b(q_b)
  );

  // Clock generation
  always #5 clock = ~clock;  // Toggle clock every 5ns (100 MHz clock)

  // Testbench sequence
  initial begin
    // Initialize inputs
    address_a = 0;
    address_b = 0;
    byteena_a = 4'b1111;  // Enable all bytes for both ports
    byteena_b = 4'b1111;
    clock = 0;
    data_a = 0;
    data_b = 0;
    rden_a = 0;
    rden_b = 0;
    wren_a = 0;
    wren_b = 0;

    // Wait for the reset (if any) or initialization phase
    #10;

    // Read from address 1 on port B
    address_b = 17'd0;
    rden_b = 1;
    #10;  // Wait for one clock cycle
    $display("Read from address 1 on port B: %h", q_b);
	 
	 address_b = 17'd1;
	 #10;
	 
	 address_b = 17'd3;
	 #10;
	 
	 
	 address_b = 17'd4;
	 #20;
	 
	 //rden_b = 0;
	 address_b = 17'd4;
	 #10;
	 
	 
	 address_b = 17'h35f;
	 #10;
	 

    // End the simulation
    #20;
    $stop;
  end

endmodule
