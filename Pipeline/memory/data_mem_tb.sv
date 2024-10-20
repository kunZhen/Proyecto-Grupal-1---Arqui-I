`timescale 1ns/1ps

module data_mem_tb();

    // Declaración de señales para el testbench
    reg clock;
    reg rden, wren;
    reg [18:0] wraddress, rdaddress;
    reg [7:0] data;
    reg byteena_a;
    wire [7:0] q;

    // Instancia del módulo data_mem
    data_mem uut (
        .clock(clock),
        .rden(rden),
        .wren(wren),
        .wraddress(wraddress),
        .rdaddress(rdaddress),
        .data(data),
        .byteena_a(byteena_a),
        .q(q)
    );

    // Generación de reloj
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Período de reloj de 10 ns
    end

    // Secuencia de prueba
    initial begin
        // Inicializar señales
        wren = 0;
        rden = 0;
        wraddress = 0;
        rdaddress = 0;
        data = 8'h00;
        byteena_a = 1'b1;

        // Tiempo de espera antes de comenzar las pruebas
        #10;
        
        // Escribir el valor 0xAB en la dirección 0x00001
        wraddress = 19'h00001;
        data = 8'hAB;
        wren = 1;
        #10;

        // Detener la escritura
        wren = 0;

        // Leer desde la dirección 0x00001
        rdaddress = 19'h00001;
        rden = 1;
        #10;

        // Esperar unos ciclos
        #10;
        rden = 0;

        // Escribir otro valor 0xCD en la dirección 0x00002
        wraddress = 19'h00002;
        data = 8'hCD;
        wren = 1;
        #10;

        // Detener la escritura
        wren = 0;

        // Leer desde la dirección 0x00002
        rdaddress = 19'h00002;
        rden = 1;
        #10;

        // Finalizar la simulación
        $stop;
    end

endmodule
