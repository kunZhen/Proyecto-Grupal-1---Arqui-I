module PISA(
	input logic clk, reset,

	input logic switch,
   output logic vgaclk,
   output logic hsync,
   output logic vsync,
   output logic sync_b, 
   output logic blank_b,
   output logic [7:0] red,
   output logic [7:0] green,
   output logic [7:0] blue
	
);

	// Instancia del módulo VGA
	vga vga (
		 .clk(clk),                // Señal de reloj principal
		 .switch(switch),          // Entrada de switch
		 .vgaclk(vgaclk),          // Señal de reloj para VGA
		 .hsync(hsync),            // Señal de sincronización horizontal
		 .vsync(vsync),            // Señal de sincronización vertical
		 .sync_b(sync_b),          // Señal de sincronización negativa
		 .blank_b(blank_b),        // Señal de blanking
		 .red(red),                // Salida de color rojo (8 bits)
		 .green(green),            // Salida de color verde (8 bits)
		 .blue(blue)              // Salida de color azul (8 bits)
	);


	
	

endmodule 