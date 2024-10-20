module tb_PS2_DRIVER;
    // Declarar señales de prueba
    reg clk;           // Clk para el testbench
    reg ps2_clk;       // Señal de reloj PS2
    reg ps2_data;      // Señal de datos PS2
    wire left_arrow;   // Salida de flecha izquierda
    wire right_arrow;  // Salida de flecha derecha
    wire left_led;     // LED de flecha izquierda
    wire right_led;    // LED de flecha derecha

    // Instanciar el módulo a probar
    PS2_DRIVER uut (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .left_arrow(left_arrow),
        .right_arrow(right_arrow),
        .left_led(left_led),
        .right_led(right_led)
    );

    // Generar el reloj del testbench
    // Generar el reloj del testbench
// Generar el reloj del testbench
initial begin
    clk = 0;          // Inicialización
end

// Alternar el reloj cada 5 unidades de tiempo
always begin
    #5 clk = ~clk;    // Alternar el reloj con periodo de 10 unidades de tiempo
end

    // Generar las señales PS2
    initial begin
        ps2_clk = 1;
        ps2_data = 1;
        #10;  // Tiempo de estabilización inicial

        // Simular la secuencia de datos de un teclado PS2
        // Suponiendo que estamos enviando el código para la flecha izquierda (0x6B)
        // y la flecha derecha (0x74)

        // Enviar código de la flecha izquierda (0x6B)
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // Start bit
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 1
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 2
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 3
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 4
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 5
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 6
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 7
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 8
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // Parity bit
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // Stop bit

        // Delay antes de la siguiente secuencia
        #20;

        // Enviar código de la flecha derecha (0x74)
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // Start bit
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 1
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 2
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 3
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 4
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 5
        #10 ps2_clk = 0; ps2_data = 0; #10 ps2_clk = 1; // bit 6
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 7
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // bit 8
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // Parity bit
        #10 ps2_clk = 0; ps2_data = 1; #10 ps2_clk = 1; // Stop bit

        // Terminar simulación
        #50 $stop;
    end

    // Monitorear las señales de salida
    initial begin
        $monitor("Time = %0t | left_arrow = %b | right_arrow = %b | left_led = %b | right_led = %b",
                 $time, left_arrow, right_arrow, left_led, right_led);
    end
endmodule
