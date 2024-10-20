module instruction_memory_tb;
	localparam DATA_WIDTH = 20;
	localparam ADDRESS_WIDTH = 8;
	localparam MEM_SIZE = 256;

   // Signal declaration
   reg clk = 0;
   reg [ADDRESS_WIDTH-1:0] address;
   reg [DATA_WIDTH-1:0] instruction;

   // Instantiate the instruction_memory module
   instruction_memory #(
      DATA_WIDTH, 
      ADDRESS_WIDTH, 
      MEM_SIZE
   ) dut (
      .clk(clk),
      .address(address),
      .instruction(instruction)
   );

   always #5 clk = ~clk;

   initial begin
      #5;
      // Read first 10 instructions from instruction_memory
      for (int i = 0; i < 10; i++) begin
         address = i;
         #10;
         $display("Instruction%d: %h", i+1, instruction);
      end

      $display("Testbench completed successfully");
      $finish;
   end

endmodule
