module register_file_tb;
   localparam DATA_WIDTH = 20;
   localparam REG_NUMBER = 5;

   // Signal declaration
   reg clk = 0;
   reg rst = 1;
   reg [REG_NUMBER-1:0] rs1, rs2, rd;
   reg reg_write;
   reg [DATA_WIDTH-1:0] data_rd;
   reg [DATA_WIDTH-1:0] data_rs1, data_rs2;

   // Instantiate the register_file module
   register_file #(
      .DATA_WIDTH(DATA_WIDTH),
      .REG_NUMBER(REG_NUMBER)
   ) dut (
      .clk(clk),
      .rst(rst),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .reg_write(reg_write),
      .data_rd(data_rd),
      .data_rs1(data_rs1),
      .data_rs2(data_rs2)
   );

   always #5 clk = ~clk;

   initial begin
      reg_write = 0;
      data_rd = 0;
      rs1 = 0;
      rs2 = 0;
      rd = 0;
      #20;

      // Check all register data is zero
      for(int i = 0; i<2**REG_NUMBER; i++) begin
         reg_write = 0;
         rs1 = i;
         #10;

         assert(data_rs1 == 20'b0) else $error("Incorrect data in register data_rs1, expected %h and got %h", 20'h0, data_rs1);
         $display("rs1: %b, data_rs1: %h", rs1, data_rs1);
      end

      // Writing and reading in registers. Consider: addp x4 x3 x2
      // Write in x3
      reg_write = 1;
      data_rd = 20'h11;
      rd = 3;
      #10;

      // Write in x2
      reg_write = 1;
      data_rd = 20'h2a;
      rd = 2;
      #10;

      // Read data from x3 and x2
      reg_write = 0;
      rs1 = 3;
      rs2 = 2;
      #10;
      $display("data_rs1: %h", data_rs1);
      $display("data_rs2: %h", data_rs2);

      // Write in x4
      reg_write = 1;
      data_rd = data_rs1 + data_rs2;
      rd = 4;
      #10;

      // Read data from x4
      reg_write = 0;
      rs1 = 4;
      rs2 = 4;
      #10;
      $display("data_rs1: %h", data_rs1);
      $display("data_rs2: %h", data_rs2);

      // Check changes
      for(int i = 0; i<5; i++) begin
         reg_write = 0;
         rs1 = i;
         #10;

         $display("rs1: %b, data_rs1: %h", rs1, data_rs1);
      end

      $display("Testbench completed successfully");
      $finish;
   end

endmodule
