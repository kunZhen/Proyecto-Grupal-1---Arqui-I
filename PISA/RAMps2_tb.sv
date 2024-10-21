`timescale 1ns / 1ps


module RAMps2_tb();
  // Parámetros
  parameter CLOCK_PERIOD = 10; // 10 ns clock period

  // Señales para conectar con el DUT (Device Under Test)
  logic clock;
  logic [7:0] data;
  logic [3:0] rdaddress;
  logic [3:0] wraddress;
  logic wren;
  logic [7:0] q;

  // Instancia del módulo RAMps2
  RAMps2 dut (
    .clock(clock),
    .data(data),
    .rdaddress(rdaddress),
    .wraddress(wraddress),
    .wren(wren),
    .q(q)
  );

  // Generador de reloj
  always begin
    clock = 1'b0;
    #(CLOCK_PERIOD/2);
    clock = 1'b1;
    #(CLOCK_PERIOD/2);
  end

  // Test
  initial begin
    // Inicialización
    wren = 1'b0;
    data = 8'h00;
    rdaddress = 4'h0;
    wraddress = 4'h0;

    // Espera por unos ciclos para asegurarse de que la RAM se ha inicializado
    repeat(5) @(posedge clock);

    // Lee de la dirección 1
    rdaddress = 4'h1;
    @(posedge clock);
    $display("Dato en dirección 1: %h", q);

    // Lee de la dirección 2
    rdaddress = 4'h2;
    @(posedge clock);
    $display("Dato en dirección 2: %h", q);

    // Finaliza la simulación
    #(CLOCK_PERIOD*5);
    $finish;
  end

endmodule