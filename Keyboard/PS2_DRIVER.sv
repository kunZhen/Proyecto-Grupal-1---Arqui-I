module PS2_DRIVER(
 input clk, ps2_clk, ps2_data,
 output Quadrant1_confirm, Quadrant2_confirm,Quadrant3_confirm, Quadrant4_confirm,Quadrant5_confirm, Quadrant6_confirm,
	Quadrant7_confirm, Quadrant8_confirm,Quadrant9_confirm, Quadrant10_confirm,Quadrant11_confirm, Quadrant12_confirm,
	Quadrant13_confirm, Quadrant14_confirm,Quadrant15_confirm, Quadrant16_confirm,
	
	Quadrant1_led, Quadrant2_led, Quadrant3_led, Quadrant4_led,
	Quadrant5_led, Quadrant6_led, Quadrant7_led, Quadrant8_led, Quadrant9_led,
	Quadrant10_led, Quadrant11_led, Quadrant12_led, Quadrant13_led, Quadrant14_led,
	Quadrant15_led,Quadrant16_led
	
);


 logic[7:0] Quadrant_1 = 8'h16; // código para la numero 1
 logic[7:0] Quadrant_2 = 8'h1E; // código para la numero 2
 logic[7:0] Quadrant_3 = 8'h26; // código para el número 3
 logic[7:0] Quadrant_4 = 8'h25; // código para el número 4
 logic[7:0] Quadrant_5 = 8'h2E; // código para el número 5
 logic[7:0] Quadrant_6 = 8'h36; // código para el número 6
 logic[7:0] Quadrant_7 = 8'h3D; // código para el número 7
 logic[7:0] Quadrant_8 = 8'h3E; // código para el número 8
 logic[7:0] Quadrant_9 = 8'h46; // código para el número 9
 logic[7:0] Quadrant_10 = 8'h15; // código para el número Q
 logic[7:0] Quadrant_11 = 8'h1D; // código para el número W
 logic[7:0] Quadrant_12 = 8'h24; // código para el número W
 logic[7:0] Quadrant_13 = 8'h2D; // código para el número W
 logic[7:0] Quadrant_14 = 8'h2C; // código para el número W
 logic[7:0] Quadrant_15 = 8'h35; // código para el número W
 logic[7:0] Quadrant_16 = 8'h3C; // código para el número W
 
 logic read; // para saber si necesita más bits
 logic previous_state; // para verificar el cambio en el reloj
 logic error; // si hay un error en los datos
 logic full_buffer; // esto es 1 cuando se reciben 11 bits
 logic trigger; // reloj más lento
 logic holding; // para cambiar el key_code
 
 logic[11:0] read_counter; // para contar el tiempo pasado
 logic[10:0] scan_code; // todo el paquete
 logic[7:0] key_code; // los 8 bits para el código de la tecla
 logic[3:0] counter; // contador de bits de 0 a 11
 logic[7:0] down_counter; // para el trigger
 logic[29:0] holding_counter; // tiempo que se retendrá el valor
 

 // establecer valores iniciales
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
  Quadrant1_confirm = 0;
  Quadrant2_confirm = 0;
  Quadrant3_confirm = 0;
  Quadrant4_confirm = 0;
  Quadrant5_confirm = 0;
  Quadrant6_confirm = 0;
  Quadrant7_confirm = 0;
  Quadrant8_confirm = 0;
  Quadrant9_confirm = 0;
  Quadrant10_confirm = 0;
  Quadrant11_confirm = 0;
  Quadrant12_confirm = 0;
  Quadrant13_confirm = 0;
  Quadrant14_confirm = 0;
  Quadrant15_confirm = 0;
  Quadrant16_confirm = 0;
  holding_counter = 8'b0;
  holding = 0;
  Quadrant1_led = 0;
  Quadrant2_led = 0;
  Quadrant3_led = 0;
  Quadrant4_led = 0;
  Quadrant5_led = 0;
  Quadrant6_led = 0;
  Quadrant7_led = 0;
  Quadrant8_led = 0;
  Quadrant9_led = 0;
  Quadrant10_led = 0;
  Quadrant11_led = 0;
  Quadrant12_led = 0;
  Quadrant13_led = 0;
  Quadrant14_led = 0;
  Quadrant15_led = 0;
  Quadrant16_led = 0;

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
 
 // aumento del contador
 always @(posedge clk) begin
  if(trigger) begin
   if(read) begin
    read_counter <= read_counter + 1;
   end else begin
    read_counter <= 0;
   end
  end
 end
 
 // controla el buffer y el scan_code
 always @(posedge clk) begin
  if(trigger) begin
   // añadir el bit al código escaneado
   if (ps2_clk != previous_state) begin
    if(!ps2_clk) begin
     read <= 1;
     error <= 0;
     scan_code[10:0] <= {ps2_data, scan_code[10:1]};
     counter <= counter + 1;
    end
   end 
   
   // si el scan_code está completo
   else if (counter == 11) begin
    counter <= 0;
    read <= 0;
    full_buffer <= 1;
   
    // en caso de error en el escaneo
    if(!scan_code[10] && !(scan_code[1]^scan_code[2]^scan_code[3]^scan_code[4]
     ^scan_code[5]^scan_code[6]^scan_code[7]^scan_code[8]
     ^scan_code[9]))
     error <= 1;
    else
     error <= 0;
   end
   // si no hay cambio en el ps2 clk
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
 
 // actualizar el key_code
 always @(posedge clk) begin
  if(trigger) begin
   if(full_buffer) begin
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
 
 // actualizar las salidas
 always @(posedge clk) begin
  if (key_code == Quadrant_1) begin
   Quadrant1_confirm = 1'b1;
  end else begin
   Quadrant1_confirm = 1'b0;
  end
  
  if (key_code == Quadrant_2) begin
   Quadrant2_confirm = 1'b1;
  end else begin
   Quadrant2_confirm = 1'b0;
  end
  
  if (key_code == Quadrant_3) begin
   Quadrant3_confirm = 1'b1;
  end else begin
   Quadrant3_confirm = 1'b0;
  end

  if (key_code == Quadrant_4) begin
   Quadrant4_confirm = 1'b1;
  end else begin
   Quadrant4_confirm = 1'b0;
  end

  if (key_code == Quadrant_5) begin
   Quadrant5_confirm = 1'b1;
  end else begin
   Quadrant5_confirm = 1'b0;
  end

  if (key_code == Quadrant_6) begin
   Quadrant6_confirm = 1'b1;
  end else begin
   Quadrant6_confirm = 1'b0;
  end

  if (key_code == Quadrant_7) begin
   Quadrant7_confirm = 1'b1;
  end else begin
   Quadrant7_confirm = 1'b0;
  end

  if (key_code == Quadrant_8) begin
   Quadrant8_confirm = 1'b1;
  end else begin
   Quadrant8_confirm = 1'b0;
  end

  if (key_code == Quadrant_9) begin
   Quadrant9_confirm = 1'b1;
  end else begin
   Quadrant9_confirm = 1'b0;
  end

  if (key_code == Quadrant_10) begin
   Quadrant10_confirm = 1'b1;
  end else begin
   Quadrant10_confirm = 1'b0;
  end

  if (key_code == Quadrant_11) begin
   Quadrant11_confirm = 1'b1;
  end else begin
   Quadrant11_confirm = 1'b0;
  end
  if (key_code == Quadrant_12) begin
   Quadrant12_confirm = 1'b1;
  end else begin
   Quadrant12_confirm = 1'b0;
  end
  if (key_code == Quadrant_13) begin
   Quadrant13_confirm = 1'b1;
  end else begin
   Quadrant13_confirm = 1'b0;
  end
  if (key_code == Quadrant_14) begin
   Quadrant14_confirm = 1'b1;
  end else begin
   Quadrant14_confirm = 1'b0;
  end
  if (key_code == Quadrant_15) begin
   Quadrant15_confirm = 1'b1;
  end else begin
   Quadrant15_confirm = 1'b0;
  end
  if (key_code == Quadrant_16) begin
   Quadrant16_confirm = 1'b1;
  end else begin
   Quadrant16_confirm = 1'b0;
  end
 end
 
 // control de los LEDs
 always @(posedge clk) begin
  if(Quadrant1_confirm) begin
   Quadrant1_led = 1'b1;
  end
  
  if(Quadrant2_confirm) begin
   Quadrant2_led = 1'b1;
  end
  
  if(Quadrant3_confirm) begin
   Quadrant3_led = 1'b1;
  end
  
  if(Quadrant4_confirm) begin
   Quadrant4_led = 1'b1;
  end
  
  if(Quadrant5_confirm) begin
   Quadrant5_led = 1'b1;
  end
  
  if(Quadrant6_confirm) begin
   Quadrant6_led = 1'b1;
  end
  
  if(Quadrant7_confirm) begin
   Quadrant7_led = 1'b1;
  end
  
   if(Quadrant8_confirm) begin
   Quadrant8_led = 1'b1;
  end
  
  if(Quadrant9_confirm) begin
   Quadrant9_led = 1'b1;
  end
  if(Quadrant10_confirm) begin
   Quadrant10_led = 1'b1;
  end
  if(Quadrant11_confirm) begin
   Quadrant11_led = 1'b1;
  end
  if(Quadrant12_confirm) begin
   Quadrant12_led = 1'b1;
  end
  if(Quadrant13_confirm) begin
   Quadrant13_led = 1'b1;
  end
  if(Quadrant14_confirm) begin
   Quadrant14_led = 1'b1;
  end
  if(Quadrant15_confirm) begin
   Quadrant15_led = 1'b1;
  end
  if(Quadrant16_confirm) begin
   Quadrant16_led = 1'b1;
  end
  
  if(Quadrant1_led || Quadrant2_led || Quadrant3_led || Quadrant4_led ||
   Quadrant5_led || Quadrant6_led || Quadrant7_led || Quadrant8_led 
	|| Quadrant9_led|| Quadrant10_led || Quadrant11_led || Quadrant12_led 
	|| Quadrant13_led|| Quadrant14_led || Quadrant15_led) begin
   holding = 1'b1;
	end

  
  if(holding) begin
   holding_counter = holding_counter + 1'b1;
  end
  
  if(holding_counter > 10000000) begin
   Quadrant1_led = 1'b0;
   Quadrant2_led = 1'b0;
	Quadrant3_led = 1'b0;
   Quadrant4_led = 1'b0;
	Quadrant5_led = 1'b0;
   Quadrant6_led = 1'b0;
	Quadrant7_led = 1'b0;
	Quadrant8_led = 1'b0;
   Quadrant9_led = 1'b0;
	Quadrant10_led = 1'b0;
	Quadrant11_led = 1'b0;
   Quadrant12_led = 1'b0;
	Quadrant13_led = 1'b0;
	Quadrant14_led = 1'b0;
   Quadrant15_led = 1'b0;
	Quadrant16_led = 1'b0;

   holding = 1'b0;
   holding_counter = 30'b0;
  end
 end
 
endmodule
