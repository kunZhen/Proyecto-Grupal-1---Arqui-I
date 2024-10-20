`timescale 1ns / 1ps

module RAM_pixels_tb;

    // Definir los registros y cables para las entradas y salidas
    reg [18:0] address_a;
    reg [18:0] address_b;
    reg [3:0] byteena_a;
    reg [3:0] byteena_b;
    reg clock;
    reg [31:0] data_a;
    reg [31:0] data_b;
    reg wren_a;
    reg wren_b;
    wire [31:0] q_a;
    wire [31:0] q_b;

    // Instanciar el módulo bajo prueba (DUT - Device Under Test)
    RAM_pixels uut (
        .address_a(address_a),
        .address_b(address_b),
        .byteena_a(byteena_a),
        .byteena_b(byteena_b),
        .clock(clock),
        .data_a(data_a),
        .data_b(data_b),
        .wren_a(wren_a),
        .wren_b(wren_b),
        .q_a(q_a),
        .q_b(q_b)
    );

    // Generar el reloj
    always #5 clock = ~clock; // El periodo de reloj es de 10 ns (50 MHz)

    // Inicialización de señales
    initial begin
        // Inicializar señales
        clock = 0;
        address_a = 0;
        address_b = 0;
        byteena_a = 4'b1111;
        byteena_b = 4'b1111;
        data_a = 0;
        data_b = 0;
        wren_a = 0;
        wren_b = 0;

        // Esperar 20 ns
        #20;

        // Escribir datos en el puerto B en la dirección 1
        address_b = 19'd1;
        data_b = 32'hCAFEBABE;
        wren_b = 1;            // Activar escritura

        #10; // Esperar un ciclo de reloj

        // Desactivar escritura
        wren_b = 0;

        // Leer de la dirección 1
        #10;
        address_b = 19'd1;

        #50; // Esperar otro ciclo de reloj

        // Terminar la simulación
        $stop;
    end

    // Monitorear las señales
    initial begin
        $monitor("Time: %0dns, address_a: %d, q_a: %h, address_b: %d, q_b: %h", 
                 $time, address_a, q_a, address_b, q_b);
    end

endmodule
