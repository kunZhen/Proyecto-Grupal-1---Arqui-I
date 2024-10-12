module vga_controller #(
    parameter HACTIVE = 10'd640,   // Ancho activo horizontal
    HFP = 10'd16,                  // Frente de sincronización horizontal
    HSYN = 10'd96,                 // Sincronización horizontal
    HBP = 10'd48,                  // Fondo de sincronización horizontal
    HMAX = HACTIVE + HFP + HSYN + HBP, // Total de píxeles horizontales
    VBP = 10'd33,                  // Fondo de sincronización vertical
    VACTIVE = 10'd480,             // Altura activa vertical
    VFP = 10'd10,                  // Frente de sincronización vertical
    VSYN = 10'd2,                  // Sincronización vertical
    VMAX = VACTIVE + VFP + VSYN + VBP  // Total de líneas verticales
)
(
    input logic vgaclk,            // Reloj del VGA
    output logic hsync,            // Sincronización horizontal
    output logic vsync,            // Sincronización vertical
    output logic sync_b,           
	 output logic blank_b,
    output logic [9:0] x,          // Posición absoluta horizontal del píxel
    output logic [9:0] y           // Posición absoluta vertical del píxel
);

// Inicialización de las posiciones x e y
initial begin
    x = 0;
    y = 0;
end

// Proceso siempre activo en el flanco de subida del reloj VGA
always @(posedge vgaclk) begin
    x++; // Incremento de la posición horizontal
    // Verificación de si se alcanzó el final de la línea horizontal
    if (x == HMAX) begin
        x = 0; // Reinicio de la posición horizontal
        y++;   // Incremento de la posición vertical
        // Verificación de si se alcanzó el final de la pantalla vertical
        if (y == VMAX) y = 0; // Reinicio de la posición vertical
    end
end

// Generación de la señal de sincronización horizontal
assign hsync = ~(x >= HACTIVE + HFP & x < HACTIVE + HFP + HSYN); 
// Generación de la señal de sincronización vertical
assign vsync = ~(y >= VACTIVE + VFP & y < VACTIVE + VFP + VSYN);

assign sync_b = hsync & vsync;
assign blank_b = (x < HACTIVE) & (y < VACTIVE);

endmodule
