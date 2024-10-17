module draw_board #(parameter HRES = 640, VRES = 480) (
    input logic clk,
    input logic [9:0] x,  // Coordenada X (0 a HRES-1)
    input logic [9:0] y,  // Coordenada Y (0 a VRES-1)
    
    input [7:0] q,          // Datos leídos desde RAM
    output logic [17:0] rdaddress, // Dirección de lectura de RAM
    
    output logic [7:0] red,   // Salida del canal rojo
    output logic [7:0] green, // Salida del canal verde
    output logic [7:0] blue   // Salida del canal azul
);
    // Dirección base de la imagen en la memoria
    parameter BASE_ADDRESS = 18'h10;
    parameter IMG_WIDTH = 400, IMG_HEIGHT = 433;
    
    always_ff @(posedge clk) begin
        // Si las coordenadas (x, y) están dentro del área de la imagen
        if (x < IMG_WIDTH && y < IMG_HEIGHT) begin
            // Calcular la dirección de memoria basada en la posición actual
            rdaddress <= BASE_ADDRESS + (y * IMG_WIDTH + x);
            
            // Asignar el color en escala de grises usando el valor de q
            red   <= q;
            green <= q;
            blue  <= q;
        end else begin
            // Valores por defecto si estamos fuera del rango de la imagen
            red   <= 8'b11111111;
            green <= 8'b11111111;
            blue  <= 8'b11111111;
        end
    end
endmodule