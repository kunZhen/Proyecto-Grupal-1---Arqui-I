module draw_board #(parameter HRES = 640, VRES = 480) (
    input logic clk,
    input logic rst,
    input logic [9:0] x,
    input logic [9:0] y,
    
    input [7:0] q,
    output logic [17:0] rdaddress,
    
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
    // Estados para la máquina de estados
    typedef enum {
        INIT_WIDTH_HIGH,
        INIT_WIDTH_LOW,
        INIT_HEIGHT_HIGH,
        INIT_HEIGHT_LOW,
        DISPLAY_IMAGE
    } state_t;
    
    state_t state;
    
    // Registros para almacenar el ancho y alto
    logic [15:0] img_width;
    logic [15:0] img_height;
    logic [7:0] width_high, width_low;
    logic [7:0] height_high, height_low;
    
    // Registros para las líneas divisorias
    logic [15:0] div_width_1, div_width_2, div_width_3;  // Divisiones horizontales
    logic [15:0] div_height_1, div_height_2, div_height_3; // Divisiones verticales
    parameter LINE_WIDTH = 1; // Ancho de las líneas divisorias
    
    // Dirección base donde comienza la imagen real
    parameter BASE_ADDRESS = 18'h10;
    
    // Color de las líneas divisorias (rojo en este caso)
    parameter [7:0] LINE_COLOR = 8'hFF;
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INIT_WIDTH_HIGH;
            rdaddress <= 18'h0;
            img_width <= 0;
            img_height <= 0;
        end else begin
            case (state)
                INIT_WIDTH_HIGH: begin
                    width_high <= q;
                    rdaddress <= 18'h1;
                    state <= INIT_WIDTH_LOW;
                end
                
                INIT_WIDTH_LOW: begin
                    width_low <= q;
                    rdaddress <= 18'h4;
                    img_width <= {width_high, width_low};
						  img_width <= 64;
                    // Calcular divisiones horizontales
                    div_width_1 <= img_width / 4;
                    div_width_2 <= (img_width * 2) / 4;
                    div_width_3 <= (img_width * 3) / 4;
                    state <= INIT_HEIGHT_HIGH;
                end
                
                INIT_HEIGHT_HIGH: begin
                    height_high <= q;
                    rdaddress <= 18'h5;
                    state <= INIT_HEIGHT_LOW;
                end
                
                INIT_HEIGHT_LOW: begin
                    height_low <= q;
                    img_height <= {height_high, height_low};
						  img_height <= 64;
                    // Calcular divisiones verticales
                    div_height_1 <= img_height/ 4;
                    div_height_2 <= (img_height * 2) / 4;
                    div_height_3 <= (img_height * 3) / 4;
                    state <= DISPLAY_IMAGE;
                end
                
                DISPLAY_IMAGE: begin
                    // Comprobar si estamos en una línea divisoria
                    if (x < img_width && y < img_height) begin
                        // Verificar si estamos en una línea vertical
                        if ((x >= div_width_1 && x < div_width_1 + LINE_WIDTH) ||
                            (x >= div_width_2 && x < div_width_2 + LINE_WIDTH) ||
                            (x >= div_width_3 && x < div_width_3 + LINE_WIDTH) ||
                            // Verificar si estamos en una línea horizontal
                            (y >= div_height_1 && y < div_height_1 + LINE_WIDTH) ||
                            (y >= div_height_2 && y < div_height_2 + LINE_WIDTH) ||
                            (y >= div_height_3 && y < div_height_3 + LINE_WIDTH)) begin
                            // Dibujar línea divisoria
                            red   <= LINE_COLOR;
                            green <= 0;
                            blue  <= 0;
                        end else begin
                            // Mostrar imagen normal
                            rdaddress <= BASE_ADDRESS + (y * img_width + x);
                            red   <= q;
                            green <= q;
                            blue  <= q;
                        end
                    end else begin
                        // Fuera del área de la imagen
                        red   <= 8'b11111111;
                        green <= 8'b11111111;
                        blue  <= 8'b11111111;
                    end
                end
            endcase
        end
    end
endmodule