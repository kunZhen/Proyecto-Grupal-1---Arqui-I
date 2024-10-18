module unicycle_tb;
    localparam DATA_WIDTH = 20;
    localparam ADDRESS_WIDTH = 8;
    localparam REG_NUMBER = 5;
    localparam MEM_SIZE = 256;

    // Clock and reset signals
    reg clk = 1;
    reg rst = 1;

    // Unicycle unit output signals
    reg zero;
    reg [ADDRESS_WIDTH-1:0] pc_result;
	 reg [DATA_WIDTH-1:0] instruction;
    reg [1:0] ALUOp;
    reg [2:0] ALUSel;
	 reg [1:0] MemToReg;
    reg Branch, ByteEnable, MemRead, MemWrite, RegSrc, ALUSrc, RegWrite;
	 reg CMP, BLT, BGE, JMP;
    reg [REG_NUMBER-1:0] rs1, rs2, rd;
    reg [DATA_WIDTH-1:0] data_rs1, data_rs2, reg_write_data, immediate, alu_result, compared_data;
    reg [DATA_WIDTH-1:0] mem_read_data;
    reg [DATA_WIDTH-1:0] mem_write_data;

    // Instantiate the unicycle module
    unicycle #(
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
        .Branch(Branch),
		  .MemToReg(MemToReg),
		  .ByteEnable(ByteEnable),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
		  .RegSrc(RegSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .data_rs1(data_rs1),
        .data_rs2(data_rs2),
        .immediate(immediate),
        .reg_write_data(reg_write_data),
        .alu_result(alu_result),
		  .compared_data(compared_data),
        .instruction(instruction),
        .mem_read_data(mem_read_data),
        .mem_write_data(mem_write_data)
    );

    always #5 clk = ~clk;

    initial begin
        #10000000;

        $display("Testbench completed successfully");
		  $writememh("../../data_out.hex", dut.datapath_unit_inst.data_memory_inst.memory);
        $finish;
    end

endmodule
