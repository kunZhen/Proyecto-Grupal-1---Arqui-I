module draw_board #(parameter HRES = 640, VRES = 480) (
    input logic clk,
    input logic [9:0] x,
    input logic [9:0] y,
	 input logic switch,
	 input logic [3:0] nboat,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
	parameter RECT_WIDTH = 48;
   parameter RECT_HEIGHT = 58;
	
	// Definición de colores
   logic [7:0] background_red = 8'b00010111; 
   logic [7:0] background_green = 8'b10010101;
   logic [7:0] background_blue = 8'b10110101;
	
   logic [7:0] rect_red = 8'b11111111;
   logic [7:0] rect_green = 8'b11111111;
   logic [7:0] rect_blue = 8'b11111111;
	
	// Variables para almacenar las coordenadas del rectángulo
	logic [9:0] rect_x = 36;
	logic [9:0] rect_y = 91;
	
	logic [9:0] lim_x = 36;
	logic [9:0] lim_y = 91;
	
	logic [9:0] lim_x2 = 36;
	logic [9:0] lim_y2 = 91;
	
	logic [9:0] lim_x3 = 36;
	logic [9:0] lim_y3 = 91;
	
	logic [9:0] lim_x4 = 36;
	logic [9:0] lim_y4 = 91;
	
	logic [9:0] lim_x5 = 36;
	logic [9:0] lim_y5 = 91;
	
	// Para el ataque del jugador a la PC
	int selectedx = 0;
	int selectedy = 0;
	
	// Matriz del jugador y enemigo
	int player [5][5] = '{ '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0} };
	int enemy [5][5] = '{ '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0}, '{0, 0, 0, 0, 0} };
	
	
	// Estado del movimiento del rectángulo
	logic actual = 0;

	logic [3:0] boat = 0;

	// Para indicar cuando se puede dibujar o mover
	logic canDraw = 0;
	
	
	
	// Variables para generar números aleatorios
	logic [3:0] clkcount = 0;
	logic [3:0] clkcount2 = 0;
	
	// Para generar un wait
	logic [9:0] delay = 0;
	
	// Asigna las coordenadas iniciales del rectángulo y controla el movimiento
	always_ff @(posedge clk) begin
		rect_x <= x;
		rect_y <= y;
		
		if (clkcount > 4) begin
			clkcount = 0;
		end else begin
			clkcount = clkcount + 1;
		end
		
		if (clkcount2 > 5) begin
			clkcount2 = 0;
		end else begin
			clkcount2 = clkcount2 + 1;
		end
				  
		// Si el switch cambia de estado, pone 1 en la matriz,
		if (switch != actual && boat >= nboat && delay == 0) begin
			actual <= !actual;
			enemy[selectedx][selectedy] <= 1;
			
			if (clkcount2 == 5) begin
				player[clkcount][clkcount2 - 1] <= 1;
			end else begin
				player[clkcount][clkcount2] <= 1;
			end
		end else if (delay > 1000) begin
			delay = 0;
		end else begin
			delay = delay + 1;
		end
		
	end
			
			
	always_ff @(posedge clk) begin
		// Pintar el fondo
		if (x < HRES && y < VRES) begin
			red = background_red;
			green = background_green;
			blue = background_blue;
		end else begin
			red = 8'b00000000;
			green = 8'b00000000;
			blue = 8'b00000000;
		end
			
		if (x == HRES/2 && y >= 0 && y <= VRES) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		
		// Lineas verticales de la izquierda
		if (x == 35 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 85 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 135 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 185 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 235 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 285 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		
		// Lineas horizontales de la izquierda
		if (x >= (HRES/4 - 125) && x <= (HRES/4 + 125) && y == 90) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 - 125) && x <= (HRES/4 + 125) && y == 150) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 - 125) && x <= (HRES/4 + 125) && y == 210) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 - 125) && x <= (HRES/4 + 125) && y == 270) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 - 125) && x <= (HRES/4 + 125) && y == 330) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 - 125) && x <= (HRES/4 + 125) && y == 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		
		// Lineas verticales de la derecha
		if (x == 355 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 405 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 455 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 505 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 555 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x == 605 && y >= 90 && y <= 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		
		// Lineas horizontales de la derecha
		if (x >= (HRES/4 + 195) && x <= (HRES/4 + 445) && y == 90) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 + 195) && x <= (HRES/4 + 445) && y == 150) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 + 195) && x <= (HRES/4 + 445) && y == 210) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 + 195) && x <= (HRES/4 + 445) && y == 270) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 + 195) && x <= (HRES/4 + 445) && y == 330) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		
		if (x >= (HRES/4 + 195) && x <= (HRES/4 + 445) && y == 390) begin
			red = rect_red;
			green = rect_green;
			blue = rect_blue;
		end
		

		// Dibujado barco 1x1
		if (rect_x >= lim_x && rect_x <= (lim_x + RECT_WIDTH) && rect_y >= lim_y && rect_y <= (lim_y + RECT_HEIGHT)) begin
			red = 8'b11111111;
			green = 8'b00000000;
			blue = 8'b00000000;
		end

		
	end

endmodule