module alu #(parameter N = 20) (
    input logic [N-1:0] A, B,            // Operand A and B
    input logic [2:0] Opcode,            // 4-bit operation code
    output logic [N-1:0] Result,         // Result
    output logic Z                       // Zero flag
);
    always_comb begin
        case (Opcode)
            3'b000: Result = A + B;  // Add
            3'b001: Result = A - B;  // Subtract
				3'b010: Result = A * B;  // Multiply
				3'b011: Result = A / B;  // Divide
				3'b100: Result = A & B;  // AND
            3'b101: Result = A | B;  // OR
				3'b110: Result = A << B; // Shift left
            3'b111: Result = A >> B; // Shift right
            default: Result = A + B; // Default operation is add
        endcase
    end

    // Flag
    assign Z = (Result == 0);

endmodule
