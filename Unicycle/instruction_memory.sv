module instruction_memory #(
    parameter DATA_WIDTH = 20,
    parameter ADDRESS_WIDTH = 8,
    parameter MEM_SIZE = 256
) (
    input logic clk,                             // Clock 
    input logic [ADDRESS_WIDTH-1:0] address,     // Input address to read instruction
    output logic [DATA_WIDTH-1:0] instruction    // Output instruction read from memory
);

    // Array to store instructions
    reg [DATA_WIDTH-1:0] instruction_memory [0:MEM_SIZE-1];

    // Initialize memory with content from file
    initial begin
		  $readmemh("pisa_test5.hex", instruction_memory);
    end

    // Assign instruction based on address
    always @(*) begin
        if (address >= 0 && address < MEM_SIZE) begin
            // Read instruction from memory array
            instruction = instruction_memory[address];
        end else begin
            instruction = {DATA_WIDTH{1'bx}}; // Undefined value in case of invalid address
        end
    end

endmodule
