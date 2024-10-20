module draw_board #(parameter HRES = 640, VRES = 480) (
    input logic clk,
    input logic rst,
    input logic [9:0] x,
    input logic [9:0] y,
    
    input logic [31:0] q_b,
    output logic [16:0] address_b,
    output logic [3:0] byteena_b,
    
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
    // Estados para la máquina de estados
    typedef enum {
        INIT_WIDTH,
        INIT_HEIGHT,
        DISPLAY_IMAGE
    } state_t;
    
    state_t state;
    
    // Registros para almacenar el ancho y alto
    logic [15:0] img_width;
    logic [15:0] img_height;
    
    // Registros para las líneas divisorias
    logic [15:0] div_width_1, div_width_2, div_width_3;  // Divisiones horizontales
    logic [15:0] div_height_1, div_height_2, div_height_3; // Divisiones verticales
    parameter LINE_WIDTH = 2; // Ancho de las líneas divisorias
    
    // Dirección base donde comienza la imagen real
    parameter BASE_ADDRESS = 16'h4;
    
    // Color de las líneas divisorias (rojo en este caso)
    parameter [7:0] LINE_COLOR = 8'hFF;

    logic [1:0] pixel_offset; // Desplazamiento para seleccionar el píxel correcto dentro de q_b

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INIT_WIDTH;
            address_b <= 17'h0; // Comienza leyendo el ancho en la dirección 1
            img_width <= 0;
            img_height <= 0;
            byteena_b <= 4'b1111;  // Inicialmente habilitar todos los bytes
        end else begin
            case (state)
                INIT_WIDTH: begin
                    img_width <= q_b[6:0];  // Leer el ancho completo desde la dirección 1
                    img_width <= 16'd450;
                    address_b <= 17'h1;      // Luego leer la altura desde la dirección 2
                    // Calcular divisiones horizontales
                    div_width_1 <= img_width / 4;
                    div_width_2 <= (img_width * 2) / 4;
                    div_width_3 <= (img_width * 3) / 4;
                    state <= INIT_HEIGHT;
                end
                
                INIT_HEIGHT: begin
                    img_height <= q_b[6:0];  // Leer la altura completa desde la dirección 2
                    img_height <= 16'd450;
                    // Calcular divisiones verticales
                    div_height_1 <= img_height / 4;
                    div_height_2 <= (img_height * 2) / 4;
                    div_height_3 <= (img_height * 3) / 4;
                    state <= DISPLAY_IMAGE;
                end
                
                DISPLAY_IMAGE: begin
                    if (x < img_width && y < img_height) begin
                        // Verificar si estamos en una línea divisoria
                        if ((x >= div_width_1 && x < div_width_1 + LINE_WIDTH) ||
                            (x >= div_width_2 && x < div_width_2 + LINE_WIDTH) ||
                            (x >= div_width_3 && x < div_width_3 + LINE_WIDTH) ||
                            (y >= div_height_1 && y < div_height_1 + LINE_WIDTH) ||
                            (y >= div_height_2 && y < div_height_2 + LINE_WIDTH) ||
                            (y >= div_height_3 && y < div_height_3 + LINE_WIDTH)) begin
                            // Dibujar línea divisoria
                            red   <= LINE_COLOR;
                            green <= 0;
                            blue  <= 0;
                        end else begin
                            // Calcular la dirección dividiendo entre 4
                            address_b <= BASE_ADDRESS + (y * img_width + x) >> 2;
                            pixel_offset <= x[1:0];

                            // Configurar byteena_b para habilitar solo el byte relevante
                            case (x[1:0])
                                2'b00: byteena_b <= 4'b0001;  // Habilitar el primer byte
                                2'b01: byteena_b <= 4'b0010;  // Habilitar el segundo byte
                                2'b10: byteena_b <= 4'b0100;  // Habilitar el tercer byte
                                2'b11: byteena_b <= 4'b1000;  // Habilitar el cuarto byte
                            endcase

                            // Leer los píxeles de derecha a izquierda
                            case (x[1:0])  // Usar los 2 bits menos significativos de x
                                2'b00: {red, green, blue} <= {q_b[7:0], q_b[7:0], q_b[7:0]};    // Primer píxel (derecha)
                                2'b01: {red, green, blue} <= {q_b[15:8], q_b[15:8], q_b[15:8]}; // Segundo píxel
                                2'b10: {red, green, blue} <= {q_b[23:16], q_b[23:16], q_b[23:16]}; // Tercer píxel
                                2'b11: {red, green, blue} <= {q_b[31:24], q_b[31:24], q_b[31:24]}; // Cuarto píxel (izquierda)
                            endcase
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
