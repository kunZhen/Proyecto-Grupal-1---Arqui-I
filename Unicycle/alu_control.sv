module alu_control (
    input logic [2:0] opcode,
	 input logic [1:0] funct2,
    input logic [1:0] ALUOp,
    output logic [2:0] ALUSel
);

    logic [3:0] ALU_Control_Input;

    assign ALU_Control_Input = {ALUOp, funct2};

    always_comb begin
        case (opcode)
            // R-type
            3'b000: begin
                case (ALU_Control_Input)
                    4'b1000: ALUSel = 3'b000; // add
                    4'b1001: ALUSel = 3'b001; // sub
                    4'b1010: ALUSel = 3'b010; // mul
						  4'b1011: ALUSel = 3'b011; // div
                endcase
            end
				
				3'b001: begin
                case (ALU_Control_Input)
                    4'b1000: ALUSel = 3'b100; // and
                    4'b1001: ALUSel = 3'b101; // or
                    4'b1010: ALUSel = 3'b001; // cmp (sub)
                endcase
            end

            // I-type
            3'b010: begin
				    case (ALU_Control_Input)
                    4'b0000: ALUSel = 3'b000; // addi
                    4'b0001: ALUSel = 3'b110; // slli
                    4'b0010: ALUSel = 3'b111; // srli
                endcase
            end

            // I-type lb, lw
            3'b011: begin
                ALUSel = 3'b000;
            end

            // S-type sb, sw
            3'b100: begin
                ALUSel = 3'b000;
            end

            default: ALUSel = 3'b000; // Default is equivalent to add
        endcase
    end

endmodule
