module mux2 #(parameter WIDTH = 20) (
   input logic sel,
   input logic [WIDTH-1:0] a, b,
   output logic [WIDTH-1:0] y
);

	assign y = sel ? b : a;

endmodule
