module PS2_DRIVER(
    input clk, ps2_clk, ps2_data,
    output reg key_0_led, key_1_led, key_2_led, key_3_led, key_4_led, key_5_led, 
           key_6_led, key_7_led, key_8_led, key_9_led, key_10_led, key_11_led, 
           key_12_led, key_13_led, key_14_led, key_15_led
   );
   
   logic[7:0] KEY_0 = 8'h16;
   logic[7:0] KEY_1 = 8'h1E;
   logic[7:0] KEY_2 = 8'h26;
   logic[7:0] KEY_3 = 8'h25;
   logic[7:0] KEY_4 = 8'h2E;
   logic[7:0] KEY_5 = 8'h36;
   logic[7:0] KEY_6 = 8'h3D;
   logic[7:0] KEY_7 = 8'h3E;
   logic[7:0] KEY_8 = 8'h46;
   logic[7:0] KEY_9 = 8'h15;
   logic[7:0] KEY_10 = 8'h1D;
   logic[7:0] KEY_11 = 8'h24;
   logic[7:0] KEY_12 = 8'h2D;
   logic[7:0] KEY_13 = 8'h2C;
   logic[7:0] KEY_14 = 8'h35;
   logic[7:0] KEY_15 = 8'h3C;

    // Definiciones internas de control
    logic read; 
    logic previous_state; 
    logic error; 
    logic full_buffer; 
    logic trigger; 
    logic holding; 
    
    logic[11:0] read_counter; 
    logic[10:0] scan_code; 
    logic[7:0] key_code; 
    logic[3:0] counter; 
    logic[7:0] down_counter; 
    logic[29:0] holding_counter; 

    // inicialización de variables
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
     holding_counter = 8'b0;
     holding = 0; 
     key_0_led = 0;
     key_1_led = 0;
     key_2_led = 0;
     key_3_led = 0;
     key_4_led = 0;
     key_5_led = 0;
     key_6_led = 0;
     key_7_led = 0;
     key_8_led = 0;
     key_9_led = 0;
     key_10_led = 0;
     key_11_led = 0;
     key_12_led = 0;
     key_13_led = 0;
     key_14_led = 0;
     key_15_led = 0;
    end

    // frecuencia más lenta
    always @(posedge clk) begin
     if(down_counter < 249) begin 
      down_counter <= down_counter + 1;
      trigger <= 0;
     end else begin 
      down_counter <= 0;
      trigger <= 1;
     end
    end

    // control de la memoria de los datos recibidos
    always @(posedge clk) begin
     if(trigger) begin 
      if(read) begin 
       read_counter <= read_counter + 1;
      end else begin 
       read_counter <= 0;
      end
     end
    end

    // Control del buffer de escaneo y lectura de datos
    always @(posedge clk) begin
     if(trigger) begin 
      if (ps2_clk != previous_state) begin 
       if(!ps2_clk) begin
        read <= 1;
        error <= 0;
        scan_code[10:0] <= {ps2_data, scan_code[10:1]};
        counter <= counter + 1;
       end
      end 
      
      if (counter == 11) begin
       counter <= 0;
       read <= 0;
       full_buffer <= 1;

       if (!scan_code[10] && !(scan_code[1] ^ scan_code[2] ^ scan_code[3] ^ scan_code[4] ^
                        scan_code[5] ^ scan_code[6] ^ scan_code[7] ^ scan_code[8] ^
                        scan_code[9])) 
        error <= 1;
       else 
        error <= 0;
      end
      else begin 
       full_buffer <= 0;
       if(counter < 11 & read_counter >= 4000) begin
        counter <= 0;
        read <= 0;
       end
      end
      previous_state <= ps2_clk;
     end
    end

    // Actualización del código de la tecla
    always @(posedge clk)begin 
     if(trigger)begin
      if(full_buffer)begin
       if(error) begin
        key_code <= 8'd0;
       end else begin
        key_code <= scan_code[8:1];
       end
      end else begin
       key_code <= 8'd0;
      end
     end else begin
      key_code <= 8'd0;
     end
    end

    // Lógica para encender LEDs cuando se presiona una tecla
    always @(posedge clk) begin
        // Desactivar todos los LEDs
        key_0_led = 0;
        key_1_led = 0;
        key_2_led = 0;
        key_3_led = 0;
        key_4_led = 0;
        key_5_led = 0;
        key_6_led = 0;
        key_7_led = 0;
        key_8_led = 0;
        key_9_led = 0;
        key_10_led = 0;
        key_11_led = 0;
        key_12_led = 0;
        key_13_led = 0;
        key_14_led = 0;
        key_15_led = 0;

        // Activar el LED correspondiente si la tecla está presionada
        case (key_code)
            KEY_0: key_0_led = 1;
            KEY_1: key_1_led = 1;
            KEY_2: key_2_led = 1;
            KEY_3: key_3_led = 1;
            KEY_4: key_4_led = 1;
            KEY_5: key_5_led = 1;
            KEY_6: key_6_led = 1;
            KEY_7: key_7_led = 1;
            KEY_8: key_8_led = 1;
            KEY_9: key_9_led = 1;
            KEY_10: key_10_led = 1;
            KEY_11: key_11_led = 1;
            KEY_12: key_12_led = 1;
            KEY_13: key_13_led = 1;
            KEY_14: key_14_led = 1;
            KEY_15: key_15_led = 1;
        endcase
    end
endmodule
