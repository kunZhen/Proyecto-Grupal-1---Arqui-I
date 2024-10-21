module tb_PS2_DRIVER;

    // Señales de entrada
    reg clk;
    reg ps2_clk;
    reg ps2_data;

    // Señales de salida
    wire [15:0] leds;
    wire [15:0] keys;

    // Instancia del controlador PS2
    PS2_DRIVER uut (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .leds(leds),
        .keys(keys)
    );

    // Inicializar señales
    initial begin
        clk = 0;
        ps2_clk = 1;
        ps2_data = 1;
    end

    // Generar reloj
    always begin
        #5 clk = ~clk; // Reloj rápido para el testbench
    end

    // Generar reloj PS2
    always begin
        #20 ps2_clk = ~ps2_clk; // Reloj PS2 más lento
    end

    // Test de secuencia de presionar tecla
    initial begin
        // Esperar unos ciclos para empezar
        #100;

        // Simulación de datos de teclado (asumimos un código de tecla ficticio)
        // Paquete PS2 completo de 11 bits
        // Por ejemplo, 8 bits para la tecla, 1 bit de paridad, y 1 bit de parada.
        
        // Simulando la tecla "A" (código de escaneo 0x1E)
        // Datos: 0 0001 1110 1 (0=start, 8 bits de datos, 1 paridad, 1 stop)
        
        // Start bit
        ps2_data = 0;
        #20;
        ps2_data = 1; // Cambio al siguiente bit
        
        // Datos de la tecla (0x1E -> 0001 1110)
        ps2_data = 0; #20; // Bit 1
        ps2_data = 0; #20; // Bit 0
        ps2_data = 0; #20; // Bit 0
        ps2_data = 0; #20; // Bit 0
        ps2_data = 1; #20; // Bit 1
        ps2_data = 1; #20; // Bit 1
        ps2_data = 1; #20; // Bit 1
        ps2_data = 0; #20; // Bit 0

        // Paridad (debería ser 1, ya que hay 5 bits 1)
        ps2_data = 1; #20; // Bit de paridad
        
        // Stop bit
        ps2_data = 1; #20; // Bit de parada

        // Esperar un ciclo
        #100;
        
        // Verificar salida LEDs (espera que el LED correspondiente se encienda)
        $display("LEDs: %b", leds);
        $display("Keys: %b", keys);
        
        // Esperar algunos ciclos más
        #200;

        // Terminar la simulación
        $stop;
    end

    // Monitoreo de señales
    initial begin
        $monitor("Time = %t, ps2_data = %b, leds = %b, keys = %b", $time, ps2_data, leds, keys);
    end

endmodule
