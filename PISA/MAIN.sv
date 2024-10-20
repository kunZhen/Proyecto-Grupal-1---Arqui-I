module MAIN (
	input logic clk, reset,
	
	input logic switch,
   output logic vgaclk,
   output logic hsync,
   output logic vsync,
   output logic sync_b, 
   output logic blank_b,
   output logic [7:0] red,
   output logic [7:0] green,
   output logic [7:0] blue,
	
	input logic wren_a,
	input logic wren_b,
	input logic [31:0] data_a,       
	input logic [31:0] data_b, 
	output logic [31:0] q_a, 
	output logic [31:0] q_b,
	output logic [16:0] address_a, address_b, 
	output logic [3:0] byteena_a, byteena_b
	
);

	// Instantiate Processor
	
	PISA pisa(
		.clk(clk),
		.reset(reset),
		.switch(switch),          // Entrada de switch
		.vgaclk(vgaclk),          // Señal de reloj para VGA
		.hsync(hsync),            // Señal de sincronización horizontal
		.vsync(vsync),            // Señal de sincronización vertical
		.sync_b(sync_b),          // Señal de sincronización negativa
		.blank_b(blank_b),        // Señal de blanking
		.red(red),                // Salida de color rojo (8 bits)
		.green(green),            // Salida de color verde (8 bits)
		.blue(blue),              // Salida de color azul (8 bits)
		
		.address_a(address_a),
      .address_b(address_b),
      .byteena_a(byteena_a),
      .byteena_b(byteena_b),
      .data_a(data_a),
      .data_b(data_b),
      .wren_a(wren_a),
      .wren_b(wren_b),
      .q_a(q_a),
      .q_b(q_b)
	);

endmodule