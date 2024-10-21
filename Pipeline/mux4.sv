module mux4 #(parameter WIDTH = 20) (
   input logic [1:0] sel,
   input logic [WIDTH-1:0] a, b, c, d,
   output logic [WIDTH-1:0] y
);

   always_comb begin
      case (sel)
         2'b00: y = a;
         2'b01: y = b;
         2'b10: y = c;
         2'b11: y = d;
         default: y = 20'b0;
      endcase
   end
	 
endmodule
