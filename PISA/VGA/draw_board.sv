module draw_board #(parameter HRES = 640, VRES = 480) (
    input logic clk,
    input logic [9:0] x,  // Coordenada X (0 a HRES-1)
    input logic [9:0] y,  // Coordenada Y (0 a VRES-1)
	 
    input [7:0] q,          // Datos leídos desde RAM (1 byte por píxel)
    output logic [17:0] rdaddress, // Dirección de lectura de RAM
	 
    output logic [7:0] red,   // Salida del canal rojo
    output logic [7:0] green, // Salida del canal verde
    output logic [7:0] blue   // Salida del canal azul
);

	// Dirección base de la imagen en la memoria
	parameter BASE_ADDRESS = 18'h10;
	parameter IMG_WIDTH = 400, IMG_HEIGHT = 433;
	
	// Contador para la dirección de memoria
	logic [17:0] current_address = BASE_ADDRESS;
	
	// Contador para la fila actual y el píxel en la fila
	logic [9:0] current_x = 0;  // Contador para la posición X en la fila
	logic [9:0] current_y = 0;  // Contador para la fila actual
	
	always_ff @(posedge clk) begin
		// Si las coordenadas (x, y) están dentro de la resolución de la pantalla
		if (x < IMG_WIDTH  && y < IMG_HEIGHT) begin
			// Asignar el color en escala de grises usando el valor de q
			red   <= q;
			green <= q;
			blue  <= q;
			
			// Incrementar la dirección de lectura
			rdaddress <= current_address;
			
			// Avanzar en la fila (incrementar current_x)
			current_x <= current_x + 1;
			current_address <= current_address + 1;  // Incrementa la dirección en 1
			
			// Si llegamos al final de la fila (ancho de la imagen), pasa a la siguiente fila
			if (current_x >= (IMG_WIDTH  - 1)) begin
				current_x <= 0;  // Reinicia el contador de píxeles en X
				current_y <= current_y + 1;  // Pasa a la siguiente fila
			end
			
			// Si llegamos al final de la imagen (altura máxima), reiniciamos
			if (current_y >= (IMG_HEIGHT - 1)) begin
				current_y <= 0;  // Reinicia el contador de filas
				current_address <= BASE_ADDRESS;  // Reinicia la dirección de memoria
			end
		end else begin
			// Valores por defecto si estamos fuera del rango
			red   <= 8'b11111111;
			green <= 8'b11111111;
			blue  <= 8'b11111111;
		end
	end
endmodule
