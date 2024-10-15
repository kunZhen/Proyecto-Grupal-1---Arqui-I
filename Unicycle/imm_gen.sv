module imm_gen #(parameter DATA_WIDTH = 20)(
    input logic [DATA_WIDTH-1:0] instruction,
    output logic [DATA_WIDTH-1:0] immediate
);

    reg [2:0] opcode;
    reg [DATA_WIDTH-1:0] imm_i;
    reg [DATA_WIDTH-1:0] imm_s;
    reg [DATA_WIDTH-1:0] imm_b;

    // Extract fields from the instruction
    assign opcode = instruction[2:0];
    assign imm_i = { {15{instruction[19]}}, instruction[19:15] }; // Sign-extend for I-type
    assign imm_s = { {15{instruction[9]}}, instruction[9:5] }; 	// Sign-extend for S-type
    assign imm_b = { {5{instruction[19]}}, instruction[19:5] }; 	// Sign-extend for B-type

    // Immediate selection based on instruction type
    always_comb begin
        case(opcode)
            // I-type
            3'b010: immediate = imm_i; // addip, sllip, srlip
            3'b011: immediate = imm_i; // lbp, lwp

            // S-type
            3'b100: immediate = imm_s; // sbp, swp

            // B-type
            3'b101: immediate = imm_b; // bltp, bgep

            default: immediate = 20'b0; // Handling unrecognized instructions
        endcase
    end

endmodule
