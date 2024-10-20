module alu #(parameter N = 20) (
   input logic [N-1:0] A, B,            // Operand A and B
   input logic [3:0] Opcode,            // 3-bit operation code
   output logic [N-1:0] Result,         // Result
   output logic Z                       // Zero flag
);
	always_comb begin
	   case (Opcode)
			4'b0000: Result = A + B;  // Add
			4'b0001: Result = A - B;  // Subtract
			4'b0010: Result = A * B;  // Multiply
			4'b0011: Result = A / B;  // Divide
			4'b0100: Result = A & B;  // AND
			4'b0101: Result = A | B;  // OR
			4'b0110: Result = A << B; // Shift left
			4'b0111: Result = A >> B; // Shift right
			4'b1000:	begin // CMP blt and bge
				Result = 20'b0;
				Result[0] = (A < B);
				Result[1] = (A >= B);
			end
			default: Result = A + B; // Default operation is add
	   endcase
	end

   // Flag
   assign Z = (Result == 0);

endmodule
