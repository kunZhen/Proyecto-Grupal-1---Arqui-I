module datapath_unit #(
   parameter DATA_WIDTH = 20,
   parameter ADDRESS_WIDTH = 8,
   parameter REG_NUMBER = 5,
   parameter MEM_SIZE = 256
) (
   input logic clk,
   input logic rst,
   output logic zero,
   output logic [ADDRESS_WIDTH-1:0] pc_result,
   output logic [1:0] ALUOp,
   output logic [2:0] ALUSel,
	output logic [1:0] MemToReg,
	output logic Branch, ByteEnable, MemRead, MemWrite, RegSrc, ALUSrc, RegWrite,
	output logic CMP, BLT, BGE, JMP,
   output logic [REG_NUMBER-1:0] rs1, rs2, rd,
   output logic [DATA_WIDTH-1:0] data_rs1, data_rs2,
   output logic [DATA_WIDTH-1:0] immediate,
   output logic [DATA_WIDTH-1:0] reg_write_data,
   output logic [DATA_WIDTH-1:0] alu_result,
   output logic [DATA_WIDTH-1:0] instruction,
	output logic [DATA_WIDTH-1:0] compared_data,
   output logic [DATA_WIDTH-1:0] mem_read_data,
   output logic [DATA_WIDTH-1:0] mem_write_data
);
   logic [ADDRESS_WIDTH-1:0] pc = 0;
	logic [ADDRESS_WIDTH-1:0] pc_next;
   logic [ADDRESS_WIDTH-1:0] pc_jump;
	
	logic lt, ge;
   logic cmp, blt, bge, jmp;

   logic [2:0] opcode;
	logic [1:0] funct2;

   logic sel0;
   logic [DATA_WIDTH-1:0] alu_operand1;
   logic [DATA_WIDTH-1:0] alu_operand2;
	
	logic [31:0] write_data;
	
	logic [ADDRESS_WIDTH-1:0] ID_pc;

   logic [DATA_WIDTH-1:0] EX_data_rs1;
   logic [DATA_WIDTH-1:0] EX_data_rs2;
   logic [DATA_WIDTH-1:0] EX_immediate;
	logic [DATA_WIDTH-1:0] EX_compared_data;
   logic [REG_NUMBER-1:0] EX_rd;
	logic [REG_NUMBER-1:0] EX_rs1;
	logic [REG_NUMBER-1:0] EX_rs2;
   logic [2:0] EX_opcode;
   logic [1:0] EX_funct2;
   logic [1:0] EX_ALUOp;
	logic [1:0] EX_MemToReg;
	logic EX_Branch;
	logic EX_ByteEnable;
	logic EX_MemRead;
	logic EX_MemWrite;
	logic EX_ALUSrc;
   logic EX_RegWrite;
	
   logic [DATA_WIDTH-1:0] MEM_alu_result;
   logic [DATA_WIDTH-1:0] MEM_write_data;
	logic [DATA_WIDTH-1:0] MEM_compared_data;
   logic [REG_NUMBER-1:0] MEM_rd;
	logic [1:0] MEM_MemToReg;
	logic MEM_ByteEnable;
	logic MEM_MemRead;
   logic MEM_MemWrite;
   logic MEM_RegWrite;

   logic [DATA_WIDTH-1:0] WB_alu_result;
   logic [DATA_WIDTH-1:0] WB_mem_read_data;
	logic [DATA_WIDTH-1:0] WB_compared_data;
	logic [REG_NUMBER-1:0] WB_rd;
	logic [1:0] WB_MemToReg;
	logic WB_RegWrite;
	
	// Define stage registers
   logic [ADDRESS_WIDTH-1:0] IF_ID_pc;
   logic [DATA_WIDTH-1:0] IF_ID_instruction;

   logic [DATA_WIDTH-1:0] ID_EX_data_rs1;
   logic [DATA_WIDTH-1:0] ID_EX_data_rs2;
   logic [DATA_WIDTH-1:0] ID_EX_immediate;
	logic [DATA_WIDTH-1:0] ID_EX_compared_data;
	logic [REG_NUMBER-1:0] ID_EX_rd;
   logic [REG_NUMBER-1:0] ID_EX_rs1;
   logic [REG_NUMBER-1:0] ID_EX_rs2;
   logic [2:0] ID_EX_opcode;
   logic [1:0] ID_EX_funct2;
   logic [1:0] ID_EX_ALUOp;
	logic [1:0] ID_EX_MemToReg;
   logic ID_EX_Branch;
	logic ID_EX_ByteEnable;
   logic ID_EX_MemRead;
   logic ID_EX_MemWrite;
   logic ID_EX_ALUSrc;
   logic ID_EX_RegWrite;

   logic [DATA_WIDTH-1:0] EX_MEM_alu_result;
   logic [DATA_WIDTH-1:0] EX_MEM_data_rs2;
	logic [DATA_WIDTH-1:0] EX_MEM_compared_data;
   logic [REG_NUMBER-1:0] EX_MEM_rd;
	logic [1:0] EX_MEM_MemToReg;
   logic EX_MEM_Branch;
	logic EX_MEM_ByteEnable;
   logic EX_MEM_MemRead;
   logic EX_MEM_MemWrite;
   logic EX_MEM_RegWrite;
   
   logic [DATA_WIDTH-1:0] MEM_WB_alu_result;
   logic [DATA_WIDTH-1:0] MEM_WB_mem_read_data;
	logic [DATA_WIDTH-1:0] MEM_WB_compared_data;
   logic [REG_NUMBER-1:0] MEM_WB_rd;
   logic MEM_WB_RegWrite;
   logic MEM_WB_MemToReg;
	
	
	// ----------------------------------- IF ----------------------------------- //
	 
	
	assign pc_next = pc + 1; 
	 
	// Instantiate the mux2 module to determine which value between pc_next and pc_jump passes to pc
   mux2 #(ADDRESS_WIDTH) mux_pcn_pcj (
      .sel((sel0 === 1'bx) ? 1'b0: sel0), 
      .a(pc_next),
      .b(pc_jump),
      .y(pc_result)
   );
	 
	// Calculation of the new PC value
   always_ff @(posedge clk, negedge rst) begin
      if (~rst) begin
         pc <= 8'h0;
      end else begin
			if (pc_result >= 8'hfa) begin
				pc <= 8'hfa;
			end else begin
				pc = pc_result;
			end
      end
   end

   // Instantiate the instruction_memory module
   instruction_memory #(
      .DATA_WIDTH(DATA_WIDTH), 
      .ADDRESS_WIDTH(ADDRESS_WIDTH), 
      .MEM_SIZE(MEM_SIZE)
   ) instruction_memory_inst (
      .clk(clk),
      .address(pc),
      .instruction(instruction)
   );
	
	// Write IF/ID
	always_ff @(posedge clk) begin
      IF_ID_pc <= pc;
      IF_ID_instruction <= instruction;
   end
	
	
	// ----------------------------------- ID ----------------------------------- //
	
	
	// Read IF/ID
   always_ff @(negedge clk) begin
		ID_pc = IF_ID_pc;
   
		// Extract opcode and funct2 from instruction
		opcode = IF_ID_instruction[2:0];
		funct2 = IF_ID_instruction[4:3];

      // Extract rd and rs1 from instruction
		rd = IF_ID_instruction[9:5];
      rs1 = IF_ID_instruction[14:10];
   end

   // Read MEM/WB
   always_ff @(negedge clk) begin
      WB_rd = MEM_WB_rd;
      WB_RegWrite = MEM_WB_RegWrite;
   end

   // Instantiate the control_unit module
   control_unit control_unit_inst (
      .opcode(opcode),
		.funct2(funct2),
      .ALUOp(ALUOp),
      .Branch(Branch),
		.ByteEnable(ByteEnable),
      .MemRead(MemRead),
      .MemToReg(MemToReg),
      .MemWrite(MemWrite),
		.RegSrc(RegSrc),
      .ALUSrc(ALUSrc),
      .RegWrite(RegWrite),
		.CMP(cmp),
		.BLT(blt),
		.BGE(bge),
		.JMP(jmp)
   );
	 
	// Instantiate the mux2 module to determine which value between 1 and rs2 passes to rs2
   mux2 #(REG_NUMBER) mux_1_rs2 (
      .sel(RegSrc), 
      .a(IF_ID_instruction[19:15]),
      .b(5'b00001),
      .y(rs2)
   );

   // Instantiate the register_file module
   register_file #(
      .DATA_WIDTH(DATA_WIDTH),
      .REG_NUMBER(REG_NUMBER)
   ) register_file_inst (
		.clk(clk),
		.rst(rst),
		.rs1(rs1),
		.rs2(rs2),
		.rd(WB_rd),
		.reg_write(WB_RegWrite), // From control_unit
		.data_rd(reg_write_data), // From mux_alu_mem
		.data_rs1(data_rs1),
		.data_rs2(data_rs2)
   );

   // Instantiate the imm_gen module
   imm_gen #(DATA_WIDTH) imm_gen_inst (
      .instruction(IF_ID_instruction),
      .immediate(immediate)
   );
	 
	// Instantiate the comparator module
   compare #(DATA_WIDTH) compare_inst (
		.cmp(cmp),
      .a(data_rs1),
      .b(data_rs2),
      .result(compared_data)
   );
	 
	assign lt = data_rs2[0];
	assign ge = data_rs2[1];

   assign pc_jump = ID_pc + immediate;
   assign sel0 = (blt && lt) || (bge && ge) || jmp;
	
	// Write ID/EX
   always_ff @(posedge clk) begin
      ID_EX_data_rs1 <= data_rs1;
      ID_EX_data_rs2 <= data_rs2;
      ID_EX_immediate <= immediate;
		ID_EX_compared_data <= compared_data;
		
		ID_EX_rd <= rd;
		ID_EX_rs1 <= rs1;
		ID_EX_rs2 <= rs2;
		
      ID_EX_opcode <= opcode;
      ID_EX_funct2 <= funct2;
		
      ID_EX_ALUOp <= ALUOp;
		ID_EX_MemToReg <= MemToReg;
      ID_EX_Branch <= Branch;
		ID_EX_ByteEnable <= ByteEnable;
      ID_EX_MemRead <= MemRead;
      ID_EX_MemWrite <= MemWrite;
      ID_EX_ALUSrc <= ALUSrc;
      ID_EX_RegWrite <= RegWrite;
   end
	
	
	// ----------------------------------- EX ----------------------------------- //

	
	// Read ID/EX
   always_ff @(negedge clk) begin
      EX_data_rs1 = ID_EX_data_rs1;
      EX_data_rs2 = ID_EX_data_rs2;
      EX_immediate = ID_EX_immediate;
		EX_compared_data = ID_EX_compared_data;
		
		EX_rd = ID_EX_rd;
		EX_rs1 = ID_EX_rs1;
		EX_rs2 = ID_EX_rs2;

      EX_opcode = ID_EX_opcode;
		EX_funct2 = ID_EX_funct2;
		
      EX_ALUOp = ID_EX_ALUOp;
		EX_MemToReg = ID_EX_MemToReg;
		EX_Branch = ID_EX_Branch;
		EX_ByteEnable = ID_EX_ByteEnable;
		EX_MemRead = ID_EX_MemRead;
		EX_MemWrite = ID_EX_MemWrite;
		EX_ALUSrc = ID_EX_ALUSrc;
		EX_RegWrite = ID_EX_RegWrite;
   end
	
   // Instantiate the mux2 module to determine which value between data_rs2 and immediate passes to the ALU
   mux2 #(DATA_WIDTH) mux_drs2_imm (
      .sel(EX_ALUSrc), 
      .a(EX_data_rs2), 
      .b(EX_immediate),
      .y(alu_operand2)
   );

   // Instantiate the alu_control module
   alu_control alu_control_inst (
      .opcode(EX_opcode),
      .funct2(EX_funct2),
      .ALUOp(EX_ALUOp),
      .ALUSel(ALUSel)
    );

   assign alu_operand1 = EX_data_rs1; // From register_file

   // Instantiate the alu module
   alu #(DATA_WIDTH) alu_inst (
      .A(alu_operand1),
      .B(alu_operand2), // From mux_drs2_imm
      .Opcode(ALUSel), // From alu_control
      .Result(alu_result),
      .Z(zero)
   );
	
	// Write EX/MEM
   always_ff @(posedge clk) begin
      EX_MEM_alu_result <= alu_result;
      EX_MEM_data_rs2 <= EX_data_rs2;
		EX_MEM_compared_data <= EX_compared_data;
      EX_MEM_rd <= EX_rd;
      EX_MEM_Branch <= EX_Branch;
		EX_MEM_ByteEnable <= EX_ByteEnable;
      EX_MEM_MemRead <= EX_MemRead;
      EX_MEM_MemWrite <= EX_MemWrite;
      EX_MEM_RegWrite <= EX_RegWrite;
      EX_MEM_MemToReg <= EX_MemToReg;
   end
	
	
	// ----------------------------------- MEM ----------------------------------- //

	
	// Read EX/MEM
   always_ff @(negedge clk) begin
      MEM_alu_result = EX_MEM_alu_result;
      MEM_write_data = EX_MEM_data_rs2;
		MEM_compared_data = EX_MEM_compared_data;
		MEM_rd = EX_MEM_rd;
      MEM_ByteEnable = EX_MEM_ByteEnable;
      MEM_MemRead = EX_MEM_MemRead;
		MEM_MemWrite = EX_MEM_MemWrite;
		MEM_RegWrite = EX_MEM_RegWrite;
		MEM_MemToReg = EX_MEM_MemToReg;
   end
	
   assign mem_write_data = MEM_write_data;
	assign write_data = {12'b0, mem_write_data};

   // Instantiate the data_memory module
   data_memory #(
      .DATA_WIDTH(32),
      .ADDRESS_WIDTH(20),
      .MEM_SIZE(1024)
   ) data_memory_inst(
      .clk(clk),
      .rst(rst),
      .address(MEM_alu_result), // From alu
      .write_data(write_data), // From register_file
      .we(MEM_MemWrite), // From control_unit
      .re(MEM_MemRead), // From control_unit
		.be(MEM_ByteEnable),
      .read_data(mem_read_data)
   );
	
	// Write MEM/WB
   always_ff @(posedge clk) begin
      MEM_WB_alu_result <= MEM_alu_result;
      MEM_WB_mem_read_data <= mem_read_data;
		MEM_WB_compared_data <= MEM_compared_data;
      MEM_WB_rd <= MEM_rd;
      MEM_WB_RegWrite <= MEM_RegWrite;
      MEM_WB_MemToReg <= MEM_MemToReg;
   end
	
	
	// ----------------------------------- WB ----------------------------------- //
	
	// Read MEM/WB
   always_ff @(negedge clk) begin
        WB_MemToReg = MEM_WB_MemToReg; // From control_unit
        WB_alu_result = MEM_WB_alu_result;
        WB_mem_read_data = MEM_WB_mem_read_data;
		  WB_compared_data = MEM_WB_compared_data;
   end
	
   // Instantiate the mux4 module to determine which value between
	// alu_result, mem_read_data or compared_data passes to register_file
   mux4 #(DATA_WIDTH) mux_alu_mem (
      .sel(WB_MemToReg), // From control_unit
      .a(WB_alu_result), // From alu 
      .b(WB_mem_read_data), // From data_memory
		.c(WB_compared_data), // From compare
		.d(20'h0),
      .y(reg_write_data)
   );

endmodule
