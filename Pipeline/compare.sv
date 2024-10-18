module compare #(parameter DATA_WIDTH = 20) (
	input  logic cmp,						    // Flag to compare
   input  logic [DATA_WIDTH-1:0] a,     // First input data
   input  logic [DATA_WIDTH-1:0] b,     // Second input data
   output logic [DATA_WIDTH-1:0] result       
);

   // Compare the entries and save their value in result
   always_comb begin
		result = 20'b0;
		  
		if (cmp) begin
			result[0] = (a < b);
			result[1] = (a >= b);
		end 
   end

endmodule
