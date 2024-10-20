module draw_board_tb;
    // Definición de parámetros para la resolución
    parameter HRES = 640;
    parameter VRES = 480;
    
    // Señales de entrada del módulo
    logic clk;
    logic rst;
    logic [9:0] x;
    logic [9:0] y;
    
    // Señales de salida del módulo
    logic [31:0] q_b;
    logic [16:0] address_b;
    logic [3:0] byteena_b;
    
    logic [7:0] red;
    logic [7:0] green;
    logic [7:0] blue;
    
    // Instancia del módulo bajo prueba
    draw_board #(HRES, VRES) uut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y),
        .q_b(q_b),
        .address_b(address_b),
        .byteena_b(byteena_b),
        .red(red),
        .green(green),
        .blue(blue)
    );
    
    // Generación del reloj (50MHz)
    always #10 clk = ~clk;
    
    // Estímulos iniciales
    initial begin
        // Inicialización de señales
        clk = 0;
        rst = 1;
        x = 0;
        y = 0;
        q_b = 32'h0;
        
        // Simulación del reset
        #25;
        rst = 0;
        
        // Espera para entrar en INIT_WIDTH
        #50;
        
        // Simular la primera lectura para el ancho
        q_b = 32'h00000064; // Ancho de 100 píxeles (hexadecimal 64)
        #20; // Esperar a que el reloj haga su trabajo
        
        // Simular la lectura de la altura
        q_b = 32'h00000064; // Alto de 100 píxeles
        #20;
        
        // Empezar a mostrar la imagen
        for (int i = 0; i < 100; i++) begin
            for (int j = 0; j < 100; j++) begin
                x = i;
                y = j;
                q_b = {8'hFF, 8'hFF, 8'hFF, 8'hFF}; // Simular el valor en q_b (blanco)
                #20; // Esperar a la simulación del ciclo de reloj
                
                // Verificar si estamos en una línea divisoria o en la imagen
                if ((x == 25 || x == 50 || x == 75 || y == 25 || y == 50 || y == 75)) begin
                    assert(red == 8'hFF && green == 8'h0 && blue == 8'h0) else $error("Error en la línea divisoria en (%0d, %0d)", x, y);
                end else begin
                    assert(red == 8'hFF && green == 8'hFF && blue == 8'hFF) else $error("Error en la imagen en (%0d, %0d)", x, y);
                end
            end
        end
        
        // Finalización de la simulación
        #100;
        $finish;
    end
endmodule
