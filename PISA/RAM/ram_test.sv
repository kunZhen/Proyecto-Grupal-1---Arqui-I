module ram_test(
	input logic clk, rst, 
	input logic [2:0] btn,
	output [31:0] q, 
	output [16:0] rdaddress, wraddress
);

	logic wren, seconds;

	logic [31:0] data;

	logic [16:0] addr_wr, addr_cont;

	RAM_data mem(seconds, data, rdaddress, wraddress, wren, q);




endmodule