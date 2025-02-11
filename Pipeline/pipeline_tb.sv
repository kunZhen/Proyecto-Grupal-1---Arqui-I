module pipeline_tb;
   localparam DATA_WIDTH = 20;
   localparam ADDRESS_WIDTH = 8;
   localparam REG_NUMBER = 5;
   localparam MEM_SIZE = 256;

   reg rst = 1;
   reg zero;
   reg [1:0] ALUOp;
   reg [3:0] ALUSel;
	reg MemToReg;
	reg [1:0] ForwardA, ForwardB;
   reg Flush, Stall, IF_ID_Write, PCWrite, ByteEnable, MemRead, MemWrite, RegSrc, ALUSrc, RegWrite;
	reg CMP, BLT, BGE, JMP;
	reg clk = 1;
	reg [ADDRESS_WIDTH-1:0] pc_result;
	reg [DATA_WIDTH-1:0] instruction;
   reg [REG_NUMBER-1:0] rs1, rs2, rd;
   reg [DATA_WIDTH-1:0] data_rs1, data_rs2, reg_write_data, immediate, alu_result;
   reg [DATA_WIDTH-1:0] mem_read_data;
   reg [DATA_WIDTH-1:0] mem_write_data;

   // Instantiate the pipeline module
   pipeline #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .REG_NUMBER(REG_NUMBER),
      .MEM_SIZE(MEM_SIZE)
   ) dut (
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

   always #5 clk = ~clk;

   initial begin
      #1000000;
		
      $display("Testbench completed successfully");
		$writememh("../../data_out.hex", dut.datapath_unit_inst.data_memory_inst.memory);
      $finish;
   end

endmodule
