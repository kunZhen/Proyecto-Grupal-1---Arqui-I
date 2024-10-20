module draw_board #(parameter HRES = 640, VRES = 480) (
    input logic clk,
    input logic rst,
    input logic [9:0] x,
    input logic [9:0] y,
    
    input logic [31:0] q_b,
    output logic [16:0] address_b,
    output logic [3:0] byteena_b,
    output logic rden_b,
    
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);
    // States
    typedef enum {
        INIT_WIDTH,
        INIT_HEIGHT,
        DISPLAY_IMAGE
    } state_t;
    
    state_t state;
    
    // Registers for dimensions
    logic [15:0] img_width;
    logic [15:0] img_height;
    
    // Division line positions
    logic [15:0] div_width_1, div_width_2, div_width_3;
    logic [15:0] div_height_1, div_height_2, div_height_3;
    parameter LINE_WIDTH = 2;
    
    parameter BASE_ADDRESS = 16'h4;
    parameter [7:0] LINE_COLOR = 8'hFF;

    // Pipeline registers
    logic [9:0] x_delay, y_delay;
    logic in_image_area;
    logic [33:0] pixel_address;
    
    // Read enable control
    assign rden_b = (state == DISPLAY_IMAGE);
    
    // Safe address calculation
    assign pixel_address = BASE_ADDRESS + (y * img_width + x);
    
    always_ff @(posedge clk) begin
        x_delay <= x;
        y_delay <= y;
        in_image_area <= (x < img_width && y < img_height);
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INIT_WIDTH;
            address_b <= 17'h0;
            img_width <= 0;
            img_height <= 0;
            byteena_b <= 4'b1111;
            {red, green, blue} <= 24'h0;
        end else begin
            case (state)
                INIT_WIDTH: begin
                    img_width <= q_b[15:0];
						  img_width <= 16'd100;
                    address_b <= 17'h1;
                    byteena_b <= 4'b1111;
                    div_width_1 <= q_b[15:0] / 4;
                    div_width_2 <= (q_b[15:0] * 2) / 4;
                    div_width_3 <= (q_b[15:0] * 3) / 4;
                    state <= INIT_HEIGHT;
                end
                
                INIT_HEIGHT: begin
                    img_height <= q_b[15:0];
						  img_height <= 16'd100;
                    div_height_1 <= q_b[15:0] / 4;
                    div_height_2 <= (q_b[15:0] * 2) / 4;
                    div_height_3 <= (q_b[15:0] * 3) / 4;
                    state <= DISPLAY_IMAGE;
                end
                
                DISPLAY_IMAGE: begin
                    // Use delayed coordinates for timing alignment
                    if (in_image_area) begin
                        address_b <= pixel_address[16:0];
                        
                        if ((x_delay >= div_width_1 && x_delay < div_width_1 + LINE_WIDTH) ||
                            (x_delay >= div_width_2 && x_delay < div_width_2 + LINE_WIDTH) ||
                            (x_delay >= div_width_3 && x_delay < div_width_3 + LINE_WIDTH) ||
                            (y_delay >= div_height_1 && y_delay < div_height_1 + LINE_WIDTH) ||
                            (y_delay >= div_height_2 && y_delay < div_height_2 + LINE_WIDTH) ||
                            (y_delay >= div_height_3 && y_delay < div_height_3 + LINE_WIDTH)) begin
                            red   <= LINE_COLOR;
                            green <= 8'h0;
                            blue  <= 8'h0;
                        end else begin
                            red   <= q_b[7:0];
                            green <= q_b[7:0];
                            blue  <= q_b[7:0];
                        end
                    end else begin
                        red   <= 8'hFF;
                        green <= 8'hFF;
                        blue  <= 8'hFF;
                        address_b <= 17'h0;
                    end
                end
            endcase
        end
    end
endmodule