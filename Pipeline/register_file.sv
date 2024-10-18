module register_file #(parameter DATA_WIDTH = 20, parameter REG_NUMBER = 5) (
   input logic clk,                          // Clock input
   input logic rst,                          // Reset
   input logic [REG_NUMBER-1:0] rs1,         // Register source 1
   input logic [REG_NUMBER-1:0] rs2,         // Register source 2
   input logic [REG_NUMBER-1:0] rd,          // Register destination
   input logic reg_write,                    // Register write enable
   input logic [DATA_WIDTH-1:0] data_rd,     // Data to be written into register
   output logic [DATA_WIDTH-1:0] data_rs1,   // Data read from register 1
   output logic [DATA_WIDTH-1:0] data_rs2    // Data read from register 2
);

   // Array to store registers
   //reg [(2**REG_NUMBER)-1:0] registers [DATA_WIDTH-1:0];
	reg [DATA_WIDTH-1:0] registers [(2**REG_NUMBER)-1:0];

   // Initialize all registers to 0
   //initial begin
   //    for (int i = 0; i < 2**REG_NUMBER; i++) begin
   //        registers[i] = 20'h0;
   //    end
   //end

   // Write operation on positive edge of clock
   always_ff @(posedge clk) begin : write
		if (~rst) begin
         for (int i = 0; i < 2**REG_NUMBER; i++) begin
            registers[i] <= 20'h0;
         end
      end

      if (reg_write && (rd != 0)) begin
         if (data_rd === 20'hx) begin
            registers[rd] <= 20'h0;
         end else begin
            registers[rd] <= data_rd;
         end
      end
   end

   // Read operation
   always_comb begin : read
      // If rs1 or rs2 is 0, output 0; otherwise, read from corresponding register
      data_rs1 = (rs1 == 0) ? 20'b0 : registers[rs1];
      data_rs2 = (rs2 == 0) ? 20'b0 : registers[rs2];
   end

endmodule
