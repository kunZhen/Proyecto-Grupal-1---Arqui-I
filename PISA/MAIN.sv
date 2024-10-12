module MAIN (
	input logic clk, reset
);

	// Instantiate Processor
	
	PISA pisa(
		.clk(clk),
		.reset(reset)
	);

endmodule