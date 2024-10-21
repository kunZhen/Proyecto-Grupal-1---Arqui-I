`timescale 1ns / 1ps

module PS2_DRIVER_tb;

    // Inputs
    reg clk;
    reg ps2_clk;
    reg ps2_data;

    // Outputs
    wire [15:0] Quadrant_confirm;
    wire [15:0] Quadrant_led;
    wire [7:0] Quadrant_value;

    // Instantiate the Unit Under Test (UUT)
    PS2_DRIVER uut (
        .clk(clk), 
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data), 
        .Quadrant_confirm(Quadrant_confirm), 
        .Quadrant_led(Quadrant_led), 
        .Quadrant_value(Quadrant_value)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // PS/2 clock generation
    initial begin
        ps2_clk = 1;
        forever #50 ps2_clk = ~ps2_clk;  // 10kHz PS/2 clock
    end

    // Test scenario
    initial begin
        // Initialize Inputs
        ps2_data = 1;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Test for key '1' (scan code 0x16)
        send_scancode(8'h16);
        
        // Wait for processing
        #10000;
        
        // Test for key '2' (scan code 0x1E)
        send_scancode(8'h1E);
        
        // Wait for processing
        #10000;
        
        // Test for key 'A' (scan code 0x1C)
        send_scancode(8'h1C);
        
        // Wait for processing
        #10000;
        
        // End simulation
        $finish;
    end
    
    // Task to send a scancode
    task send_scancode;
        input [7:0] code;
        integer i;
        begin
            // Start bit
            ps2_data = 0;
            #100;
            
            // Data bits
            for (i = 0; i < 8; i = i + 1) begin
                ps2_data = code[i];
                #100;
            end
            
            // Parity bit (odd parity)
            ps2_data = ~^code;
            #100;
            
            // Stop bit
            ps2_data = 1;
            #100;
        end
    endtask
    
    // Monitor changes in Quadrant_value
    initial begin
        $monitor("Time=%0t ps: Quadrant_value changed to %h", $time, Quadrant_value);
    end

endmodule