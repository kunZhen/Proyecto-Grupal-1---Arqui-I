module data_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 32,
    parameter MEM_SIZE = 1024
) (
    input logic clk,                           // Clock 
    input logic rst,                           // Reset
    input logic [ADDRESS_WIDTH-1:0] address,   // Address
    input logic [DATA_WIDTH-1:0] write_data,   // Data input for writing
    input logic we,                     		  // Memory write enable
	 input logic re,                     		  // Memory read enable
	 input logic be, 						           // Byte enable for lbp/sbp
    output logic [DATA_WIDTH-1:0] read_data    // Data output for reading
);

    // Array to store data
    logic [DATA_WIDTH-1:0] memory [0:MEM_SIZE-1];

    // Initialize memory with content from file
    initial begin
        $readmemh("data.hex", memory);
    end

    // Write operation
    always_ff @(posedge clk or negedge rst) begin
        if (~rst) begin
            // Reset
            for (int i = 0; i < MEM_SIZE; i++) begin
                memory[i] <= '0;
            end
        end else if (we && (address < MEM_SIZE)) begin
				if (be) begin
					// Write byte (sbp)
					case (address[1:0])
						2'b00: memory[address[11:2]][7:0] <= write_data[7:0];
						2'b01: memory[address[11:2]][15:8] <= write_data[7:0];
						2'b10: memory[address[11:2]][23:16] <= write_data[7:0];
						2'b11: memory[address[11:2]][31:24] <= write_data[7:0];
               endcase
				end else begin
					// Write word (swp)
					memory[address[11:2]] <= write_data;
				end
        end
    end
    
	 // Read operation
    always @(*) begin
        if (re && (address < MEM_SIZE)) begin
			   if (be) begin
					// Read byte (lbp)
					case (address[1:0])
						2'b00: read_data <= {24'b0, (memory[address[11:2]][7:0] === 8'hxx) ? 8'h00 : memory[address[11:2]][7:0]};
						2'b01: read_data <= {24'b0, (memory[address[11:2]][15:8] === 8'hxx) ? 8'h00 : memory[address[11:2]][15:8]};
						2'b10: read_data <= {24'b0, (memory[address[11:2]][23:16] === 8'hxx) ? 8'h00 : memory[address[11:2]][23:16]};
						2'b11: read_data <= {24'b0, (memory[address[11:2]][31:24] === 8'hxx) ? 8'h00 : memory[address[11:2]][31:24]};
               endcase
				end else begin
					// Read word (lwp)
					if (memory[address[9:2]] === 32'hx) begin
						read_data <= 32'h0;
					end
					else begin
						read_data <= memory[address[11:2]];
					end
				end
        end
    end

endmodule
