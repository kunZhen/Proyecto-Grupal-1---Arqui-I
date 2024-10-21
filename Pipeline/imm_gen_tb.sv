module imm_gen_tb;
   localparam MEM_SIZE = 256;
   localparam DATA_WIDTH = 20;

   // Signal declaration
   reg clk = 0;
   reg [DATA_WIDTH-1:0] instruction;
   reg [DATA_WIDTH-1:0] immediate;
	
	// Array to store instructions
   reg [DATA_WIDTH-1:0] instructions [0:MEM_SIZE-1];

   // Instantiate the imm_gen module
   imm_gen #(DATA_WIDTH) dut (
      .instruction(instruction),
      .immediate(immediate)
   );

   always #5 clk = ~clk;

   initial begin
      // Read the instructions from the file and load them into the array
      $readmemh("program.hex", instructions);

      // Process each instruction in each clock cycle
      for (int i = 0; i < 10; i++) begin
         instruction = instructions[i]; 
         #10;
            
         $display("Instruction[%0d]: %h, Immediate: %h", i, instruction, immediate);
      end

      $display("Testbench completed successfully");
      $finish;
   end

endmodule
