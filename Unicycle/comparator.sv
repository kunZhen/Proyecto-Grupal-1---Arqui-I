module comparator #(parameter DATA_WIDTH = 20) (
    input  logic [DATA_WIDTH-1:0] a,     // First input data
    input  logic [DATA_WIDTH-1:0] b,     // Second input data
    output logic lt, ge       
);

    // Compare the entries
    always_comb begin
        lt = (a < b);
        ge = (a >= b);
    end

endmodule
