module PS2_DRIVER_simplify(
    input clk, ps2_clk, ps2_data,
    output reg [15:0] Quadrant_confirm,
    output reg [15:0] Quadrant_led
);

    // Definición de códigos de teclas
    reg [7:0] QUADRANT_CODES [0:15];
    initial begin
        QUADRANT_CODES[0] = 8'h16; QUADRANT_CODES[1] = 8'h1E; QUADRANT_CODES[2] = 8'h26; QUADRANT_CODES[3] = 8'h25;
        QUADRANT_CODES[4] = 8'h2E; QUADRANT_CODES[5] = 8'h36; QUADRANT_CODES[6] = 8'h3D; QUADRANT_CODES[7] = 8'h3E;
        QUADRANT_CODES[8] = 8'h46; QUADRANT_CODES[9] = 8'h15; QUADRANT_CODES[10] = 8'h1D; QUADRANT_CODES[11] = 8'h24;
        QUADRANT_CODES[12] = 8'h2D; QUADRANT_CODES[13] = 8'h2C; QUADRANT_CODES[14] = 8'h35; QUADRANT_CODES[15] = 8'h3C;
    end

    reg read, previous_state, error, full_buffer, trigger, holding;
    reg [11:0] read_counter;
    reg [10:0] scan_code;
    reg [7:0] key_code;
    reg [3:0] counter;
    reg [7:0] down_counter;
    reg [29:0] holding_counter;

    integer i; // Variable para bucles

    // Inicialización
    initial begin
        previous_state = 1;
        trigger = 0;
        down_counter = 0;
        error = 0;
        scan_code = 0;
        counter = 0;
        key_code = 0;
        read = 0;
        read_counter = 0;
        Quadrant_confirm = 16'b0;
        holding_counter = 0;
        holding = 0;
        Quadrant_led = 16'b0;
    end

    // Generación de trigger
    always @(posedge clk) begin
        if(down_counter == 248) begin
            trigger <= 1'b1;
            down_counter <= 0;
        end else begin
            trigger <= 1'b0;
            down_counter <= down_counter + 1'b1;
        end
    end

    // Lógica principal
    always @(posedge clk) begin
        if (trigger) begin
            // Lógica de lectura PS/2
            if (ps2_clk != previous_state && !ps2_clk) begin
                read <= 1;
                error <= 0;
                scan_code <= {ps2_data, scan_code[10:1]};
                counter <= counter + 1;
            end else if (counter == 11) begin
                counter <= 0;
                read <= 0;
                full_buffer <= 1;
                error <= !scan_code[10] || !(^scan_code[9:1]);
            end else begin
                full_buffer <= 0;
                if (counter < 11 && read_counter >= 4000) begin
                    counter <= 0;
                    read <= 0;
                end
            end

            previous_state <= ps2_clk;
            
            if (read)
                read_counter <= read_counter + 1;
            else
                read_counter <= 0;

            // Actualización de key_code
            if (full_buffer && !error)
                key_code <= scan_code[8:1];
            else
                key_code <= 8'd0;

            // Actualización de Quadrant_confirm
            for (i = 0; i < 16; i = i + 1) begin
                Quadrant_confirm[i] <= (key_code == QUADRANT_CODES[i]);
            end

            // Control de LEDs y temporizador
            if (|Quadrant_confirm) begin
                Quadrant_led <= Quadrant_confirm;
                holding <= 1'b1;
                holding_counter <= 0;
            end else if (holding) begin
                holding_counter <= holding_counter + 1'b1;
                if (holding_counter > 10000000) begin
                    Quadrant_led <= 16'b0;
                    holding <= 1'b0;
                end
            end
        end
    end

endmodule