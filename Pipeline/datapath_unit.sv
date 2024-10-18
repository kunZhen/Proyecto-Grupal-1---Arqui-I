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
	 
	logic reg_write;
	logic lt, ge;
   logic cmp, blt, bge, jmp;

   logic [2:0] opcode;
	logic [1:0] funct2;

   logic sel0, sel1, sel2, sel3;
   logic [DATA_WIDTH-1:0] alu_operand1;
   logic [DATA_WIDTH-1:0] alu_operand2;
	
	logic [31:0] write_data;
	
	
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
	
	
	// ----------------------------------- ID ----------------------------------- //

	
	// Extract opcode and funct2 from instruction
	assign opcode = instruction[2:0];
	assign funct2 = instruction[4:3];

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
	 
	assign reg_write = RegWrite;
	 
	// Extract rs1 and rd from instruction
   assign rs1 = instruction[14:10];
   assign rd = instruction[9:5];
	 
	// Instantiate the mux2 module to determine which value between 1 and rs2 passes to rs2
   mux2 #(REG_NUMBER) mux_1_rs2 (
      .sel(RegSrc), 
      .a(instruction[19:15]),
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
		.rd(rd),
		.reg_write(reg_write), // From control_unit
		.data_rd(reg_write_data), // From mux_alu_mem
		.data_rs1(data_rs1),
		.data_rs2(data_rs2)
   );

   // Instantiate the imm_gen module
   imm_gen #(DATA_WIDTH) imm_gen_inst (
      .instruction(instruction),
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

   assign pc_jump = pc + immediate;
   assign sel0 = (blt && lt) || (bge && ge) || jmp;
	
	
	// ----------------------------------- EX ----------------------------------- //

	
   // Instantiate the mux2 module to determine which value between data_rs2 and immediate passes to the ALU
   mux2 #(DATA_WIDTH) mux_drs2_imm (
      .sel(ALUSrc), 
      .a(data_rs2), 
      .b(immediate),
      .y(alu_operand2)
   );

   // Instantiate the alu_control module
   alu_control alu_control_inst (
      .opcode(opcode),
      .funct2(funct2),
      .ALUOp(ALUOp),
      .ALUSel(ALUSel)
    );

   assign alu_operand1 = data_rs1; // From register_file

   // Instantiate the alu module
   alu #(DATA_WIDTH) alu_inst (
      .A(alu_operand1),
      .B(alu_operand2), // From mux_drs2_imm
      .Opcode(ALUSel), // From alu_control
      .Result(alu_result),
      .Z(zero)
   );
	
	
	// ----------------------------------- MEM ----------------------------------- //

	
   assign mem_write_data = data_rs2;
	assign write_data = {12'b0, mem_write_data};

   // Instantiate the data_memory module
   data_memory #(
      .DATA_WIDTH(32),
      .ADDRESS_WIDTH(20),
      .MEM_SIZE(1024)
   ) data_memory_inst(
      .clk(clk),
      .rst(rst),
      .address(alu_result), // From alu
      .write_data(write_data), // From register_file
      .we(MemWrite), // From control_unit
      .re(MemRead), // From control_unit
		.be(ByteEnable),
      .read_data(mem_read_data)
   );
	
	
	// ----------------------------------- WB ----------------------------------- //

	
   // Instantiate the mux4 module to determine which value between
	// alu_result, mem_read_data or compared_data passes to register_file
   mux4 #(DATA_WIDTH) mux_alu_mem (
      .sel(MemToReg), // From control_unit
      .a(alu_result), // From alu 
      .b(mem_read_data), // From data_memory
		.c(compared_data), // From compare
		.d(20'h0),
      .y(reg_write_data)
   );

endmodule
