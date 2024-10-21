`timescale 1ns / 1ps

module KFPS2KB_tb();

    // Señales del módulo top
    logic CLK;
    logic PS2_CLK;
    logic PS2_DAT;
    logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    // Instancia del módulo top
    top dut (
        .CLK(CLK),
        .PS2_CLK(PS2_CLK),
        .PS2_DAT(PS2_DAT),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );

    // Generación de reloj
    always #5 CLK = ~CLK;

    // Tarea para enviar un código de tecla PS/2
    task send_ps2_code(input logic [7:0] code);
        logic [10:0] packet;
        packet = {1'b1, ^code, code, 1'b0};  // Stop bit, parity, code, start bit
        
        for (int i = 0; i < 11; i++) begin
            #50;  // 50 ns entre flancos de reloj (20 kHz)
            PS2_CLK = 0;
            PS2_DAT = packet[i];
            #50;
            PS2_CLK = 1;
        end
    endtask

    // Proceso de simulación
    initial begin
        // Inicialización
        CLK = 0;
        PS2_CLK = 1;
        PS2_DAT = 1;

        // Espera para la inicialización del sistema
        #1000;

        // Simula presionar la tecla 'A' (código PS/2: 1C)
        send_ps2_code(8'h1C);

        // Espera para que el sistema procese la tecla
        #1000;

        // Simula soltar la tecla 'A' (F0 1C)
        send_ps2_code(8'hF0);
        #1000;
        send_ps2_code(8'h1C);

        // Espera final
        #5000;

        // Fin de la simulación
        $finish;
    end

    // Monitor para verificar los valores en los displays de 7 segmentos
    always @(posedge CLK) begin
        $display("Time=%0t, HEX5-0: %h %h %h %h %h %h", 
                 $time, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
    end

    // Monitor para verificar el contenido de la RAM
    always @(posedge CLK) begin
        if (dut.ram_wren) begin
            $display("Time=%0t, RAM Write: Address=%h, Data=%h", 
                     $time, dut.ram_wraddress, dut.keycode);
        end
    end

endmodule