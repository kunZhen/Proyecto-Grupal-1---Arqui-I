module alu_control (
   input logic [2:0] opcode,
	input logic [1:0] funct2,
   input logic [1:0] ALUOp,
   output logic [3:0] ALUSel
);

   logic [3:0] ALU_Control_Input;

   assign ALU_Control_Input = {ALUOp, funct2};

   always_comb begin
      case (opcode)
         // R-type
         3'b000: begin
            case (ALU_Control_Input)
               4'b1000: ALUSel = 4'b0000; // add
               4'b1001: ALUSel = 4'b0001; // sub
               4'b1010: ALUSel = 4'b0010; // mul
					4'b1011: ALUSel = 4'b0011; // div
					default: ALUSel = 4'b0000;
            endcase
         end
				
			3'b001: begin
            case (ALU_Control_Input)
               4'b1000: ALUSel = 4'b0100; // and
               4'b1001: ALUSel = 4'b0101; // or
               4'b1010: ALUSel = 4'b1000; // cmp
					default: ALUSel = 4'b0000;
            endcase
         end

         // I-type
         3'b010: begin
				case (ALU_Control_Input)
               4'b0000: ALUSel = 4'b0000; // addi
               4'b0001: ALUSel = 4'b0110; // slli
               4'b0010: ALUSel = 4'b0111; // srli
					default: ALUSel = 4'b0000;
            endcase
         end

         // I-type lb, lw
         3'b011: begin
            ALUSel = 4'b0000;
         end

         // S-type sb, sw
         3'b100: begin
            ALUSel = 4'b0000;
         end

         default: ALUSel = 4'b0000; // Default is equivalent to add
      endcase
   end

endmodule
