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
   output logic [7:0] blue,
	
	input logic wren,
	input logic [31:0] data,       
	output [7:0] q, 
	output [17:0] rdaddress, wraddress,
	
	input   logic           PS2_CLK,
   input   logic           PS2_DAT,
	output  logic   [6:0]   HEX0,
   output  logic   [6:0]   HEX1,
   output  logic   [6:0]   HEX2,
   output  logic   [6:0]   HEX3,
   output  logic   [6:0]   HEX4,
   output  logic   [6:0]   HEX5
	
);

	// Instancia del módulo VGA
	vga vga (
		 .clk(clk),                // Señal de reloj principal
		 .reset(reset),
		 .switch(switch),          // Entrada de switch
		 
		 .rdaddress(rdaddress), 
		 .q(q),
		 
		 .vgaclk(vgaclk),          // Señal de reloj para VGA
		 .hsync(hsync),            // Señal de sincronización horizontal
		 .vsync(vsync),            // Señal de sincronización vertical
		 .sync_b(sync_b),          // Señal de sincronización negativa
		 .blank_b(blank_b),        // Señal de blanking
		 .red(red),                // Salida de color rojo (8 bits)
		 .green(green),            // Salida de color verde (8 bits)
		 .blue(blue)              // Salida de color azul (8 bits)
	);
	
	RAM_pixels ram_pixels (
    .clock(clk), 
    .data(data), 
    .rdaddress(rdaddress), 
    .wraddress(wraddress), 
    .wren(wren), 
    .q(q)
  );
  
  // Instancia del módulo keyboard
	top_keyboard u_keyboard (
		 .CLK        (clk),      // Señal de reloj
		 .PS2_CLK    (PS2_CLK),  // Señal del reloj del PS2
		 .PS2_DAT    (PS2_DAT),  // Señal de datos del PS2

		 .HEX0       (HEX0),     // Salida al display HEX0
		 .HEX1       (HEX1),     // Salida al display HEX1
		 .HEX2       (HEX2),     // Salida al display HEX2
		 .HEX3       (HEX3),     // Salida al display HEX3
		 .HEX4       (HEX4),     // Salida al display HEX4
		 .HEX5       (HEX5)      // Salida al display HEX5
	);



	
	

endmodule 