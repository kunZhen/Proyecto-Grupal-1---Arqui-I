module control_unit (
    input logic [2:0] opcode,
    input logic [1:0] funct2,
    output logic [1:0] ALUOp,
	 output logic Branch, ByteEnable, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite,
    output logic BLT, BGE, JMP
);

    always_comb begin
		  ByteEnable = 1'b0;
        BLT = 1'b0;
        BGE = 1'b0;
        JMP = 1'b0;
        case (opcode)
				3'b000: begin // R-type: addp, subp, mulp, divp
                Branch = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
            end
				
				3'b001: begin // R-type: andp, orp, cmpp
                Branch = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
            end

            3'b010: begin // addip, sllip, srlip
                Branch = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b1; // Take immediate value
                RegWrite = 1'b1;
            end
				
				3'b011: begin // lw
					 if (funct2 == 2'b00) begin
						  ByteEnable = 1'b1;
					 end else begin
						  ByteEnable = 1'b0;
					 end
                Branch = 1'b0;
                MemRead = 1'b1;
                MemToReg = 1'b1;
                ALUOp = 2'b00;
                MemWrite = 1'b0;
                ALUSrc = 1'b1;
                RegWrite = 1'b1;
            end
            
            3'b100: begin // sw
					 if (funct2 == 2'b00) begin
						  ByteEnable = 1'b1;
					 end else begin
						  ByteEnable = 1'b0;
					 end
                Branch = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp = 2'b00;
                MemWrite = 1'b1;
                ALUSrc = 1'b1;
                RegWrite = 1'b0;
            end

            3'b101: begin // bltp, bgep, jump
                case (funct2)
                    2'b00: BLT = 1'b1;
                    2'b01: BGE = 1'b1;
                    2'b10: JMP = 1'b1;
                endcase
                Branch = 1'b1;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp = 2'b01;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b0;
            end
				
            default: begin // Default is R-type
                Branch = 1'b0;
                MemRead = 1'b0;
                MemToReg = 1'b0;
                ALUOp = 2'b10;
                MemWrite = 1'b0;
                ALUSrc = 1'b0;
                RegWrite = 1'b1;
            end
        endcase
    end

endmodule
