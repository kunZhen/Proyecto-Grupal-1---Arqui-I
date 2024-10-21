module vga #(
    parameter HRES = 640,
    parameter VRES = 480
)(
    input logic clk,
	 input logic switch,
	 
	 input [7:0] q, 
	 output [17:0] rdaddress,
	 
    output logic vgaclk,
    output logic hsync,
    output logic vsync,
    output logic sync_b, 
    output logic blank_b,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

    logic [9:0] x, y;
	 
	 logic [2:0] num_boats;
	 
	 logic reset = 1;

    pll vgapll(
        .inclk0(clk),
        .c0(vgaclk)
    );

    vga_controller #(
        .HACTIVE(HRES),
        .VACTIVE(VRES)
    ) vga_controller_inst (
        .vgaclk(vgaclk),
        .hsync(hsync),
        .vsync(vsync),
        .sync_b(sync_b),
        .blank_b(blank_b),
        .x(x),
        .y(y)
    );
	
	 
	 // Instanciación del módulo draw_board
	 draw_board #(HRES, VRES) draw_board_inst (//Lógica para el estado 1
		 .clk(clk),
		 .x(x),
		 .y(y),
		 
		 .q(q),
		 .rdaddress(rdaddress),
		 
		 .red(red),
		 .green(green),
		 .blue(blue)
    );
	


endmodule
