module MAIN (
	input logic clk, reset
);

	// Instantiate Bilinea Processor
	
	Bilinea bilinea(
		.clk(clk),
		.reset(reset)
	);

endmodule