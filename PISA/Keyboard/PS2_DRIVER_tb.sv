module PS2_DRIVER_tb;

    // Signals for the test
    reg clk;
    reg ps2_clk;
    reg ps2_data;
    
    wire [15:0] Quadrant_confirm;
    wire [15:0] Quadrant_led;
    wire [7:0] Quadrant_value;

    // Instantiate the module under test
    PS2_DRIVER uut (
        .clk(clk),
        .ps2_clk(ps2_clk),
        .ps2_data(ps2_data),
        .Quadrant_confirm(Quadrant_confirm),
        .Quadrant_led(Quadrant_led),
        .Quadrant_value(Quadrant_value)
    );

    // Clock generator
    always #5 clk = ~clk;

    // Task to simulate PS/2 data input
    task send_ps2_data;
        input [10:0] packet;  // 11-bit PS/2 packet
        integer i;
        begin
            // Simulate PS/2 clock and data
            for (i = 0; i < 11; i = i + 1) begin
                ps2_data = packet[i];
                #10 ps2_clk = 0;  // Falling edge
                #10 ps2_clk = 1;  // Rising edge
            end
        end
    endtask

    // Example PS/2 packets to simulate keyboard input
    reg [10:0] ps2_packet;

    initial begin
        // Initialization of signals
        clk = 0;
        ps2_clk = 1;
        ps2_data = 1;

        // Initial delay to allow for simulation setup
        #100;

        // Simulate multiple key presses

        // Example: key 1 (0x16) for quadrant 0
        ps2_packet = 11'b0_01100010_1_1;  // Start, keycode (0x16), parity (1), stop (1)
        send_ps2_data(ps2_packet);

        // Wait to allow the module to process the data
        #200;

        // Example: key 2 (0x1E) for quadrant 1
        ps2_packet = 11'b0_01111000_1_1;  // Start, keycode (0x1E), parity (1), stop (1)
        send_ps2_data(ps2_packet);

        // Wait for processing
        #200;

        // Example: key 3 (0x26) for quadrant 2
        ps2_packet = 11'b0_00100110_0_1;  // Start, keycode (0x26), parity, stop
        send_ps2_data(ps2_packet);

        // Wait before finishing
        #200;

        // End the simulation
        $finish;
    end

    // Monitor for output changes
    initial begin
        $monitor("Time = %0t | Quadrant_confirm = %b | Quadrant_led = %b | Quadrant_value = %h",
                 $time, Quadrant_confirm, Quadrant_led, Quadrant_value);
    end

endmodule
