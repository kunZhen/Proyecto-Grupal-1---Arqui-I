module pipeline #(
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
   output logic [3:0] ALUSel,
	output logic MemToReg,
	output logic [1:0] ForwardA, ForwardB,
	output logic Flush, Stall, IF_ID_Write, PCWrite, ByteEnable, MemRead, MemWrite, RegSrc, ALUSrc, RegWrite,
	output logic CMP, BLT, BGE, JMP,
   output logic [REG_NUMBER-1:0] rs1, rs2, rd,
   output logic [DATA_WIDTH-1:0] data_rs1, data_rs2,
   output logic [DATA_WIDTH-1:0] immediate,
   output logic [DATA_WIDTH-1:0] reg_write_data,
   output logic [DATA_WIDTH-1:0] alu_result,
   output logic [DATA_WIDTH-1:0] instruction,
   output logic [DATA_WIDTH-1:0] mem_read_data,
   output logic [DATA_WIDTH-1:0] mem_write_data
);

	// Instantiate the datapath_unit module
   datapath_unit #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .REG_NUMBER(REG_NUMBER),
      .MEM_SIZE(MEM_SIZE)
   ) datapath_unit_inst (
      .clk(clk),
      .rst(rst),
      .zero(zero),
      .pc_result(pc_result),
      .ALUOp(ALUOp),
      .ALUSel(ALUSel),
		.Flush(Flush),
		.Stall(Stall),
		.IF_ID_Write(IF_ID_Write),
		.PCWrite(PCWrite),
		.MemToReg(MemToReg),
		.ForwardA(ForwardA),
		.ForwardB(ForwardB),
		.ByteEnable(ByteEnable),
      .MemRead(MemRead),
      .MemWrite(MemWrite),
		.RegSrc(RegSrc),
      .ALUSrc(ALUSrc),
      .RegWrite(RegWrite),
		.CMP(CMP),
		.BLT(BLT),
		.BGE(BGE),
		.JMP(JMP),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .data_rs1(data_rs1),
      .data_rs2(data_rs2),
      .immediate(immediate),
      .reg_write_data(reg_write_data),
      .alu_result(alu_result),
      .instruction(instruction),
      .mem_read_data(mem_read_data),
      .mem_write_data(mem_write_data)
   );


endmodule
