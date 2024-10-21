module data_memory_tb;
   localparam DATA_WIDTH = 32;
   localparam ADDRESS_WIDTH = 20;
   localparam MEM_SIZE = 8192;

   // Signal declaration
   reg clk = 0;
   reg rst = 1;
   reg [ADDRESS_WIDTH-1:0] address;
   reg [DATA_WIDTH-1:0] write_data;
   reg we;
	reg re;
	reg be;
   reg [DATA_WIDTH-1:0] read_data;

   // Instantiate the data_memory module
   data_memory #(
      .DATA_WIDTH(DATA_WIDTH),
      .ADDRESS_WIDTH(ADDRESS_WIDTH),
      .MEM_SIZE(MEM_SIZE)
   ) dut (
      .clk(clk),
      .rst(rst),
      .address(address),
      .write_data(write_data),
      .we(we),
		.re(re),
		.be(be),
      .read_data(read_data)
   );

   always #5 clk = ~clk;

   initial begin
      // Read first 10 data from memory
      for (int i = 0; i < 10; i++) begin
         we = 1'b0;
			re = 1'b1;
         address = i * 4;
         #10;
         $display("Address: %h, Data: %h", address, read_data);
      end

      // Write 
      address = 32'h18;
      write_data = 32'hb6a84325;
      we = 1'b1;
		re = 1'b0;
		be = 1'b0;
      #20;

      // Read
		address = 32'h18;
      we = 1'b0;
		re = 1'b1;
		be = 1'b0;
      #10;
      $display("Address: %h, Data: %h", address, read_data);

      // Write byte
      address = 32'h19;
      write_data = 32'h74;
      we = 1'b1;
		re = 1'b0;
		be = 1'b1;
      #20;

      // Read byte
		address = 32'h19;
      we = 1'b0;
		re = 1'b1;
		be = 1'b1;
      #10;
      $display("Address: %h, Data: %h", address, read_data);
		  
		// Read 
		address = 32'h18;
      we = 1'b0;
		re = 1'b1;
		be = 1'b0;
      #10;
      $display("Address: %h, Data: %h", address, read_data);

      $display("Testbench completed successfully");
      $finish;
   end

endmodule
