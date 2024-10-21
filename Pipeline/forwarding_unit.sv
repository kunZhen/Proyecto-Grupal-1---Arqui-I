module forwarding_unit #(parameter REG_NUMBER = 5) (
   input logic EX_MEM_RegWrite,
   input logic MEM_WB_RegWrite,
   input logic [REG_NUMBER-1:0] ID_EX_rs1,
   input logic [REG_NUMBER-1:0] ID_EX_rs2,
   input logic [REG_NUMBER-1:0] EX_MEM_rd,
   input logic [REG_NUMBER-1:0] MEM_WB_rd,
   output logic [1:0] ForwardA, ForwardB
);

   always_comb begin
      ForwardA = 2'b00;
      ForwardB = 2'b00;

      // EX hazard
      if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)) begin
         ForwardA = 2'b10;
      end
		if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)) begin
         ForwardB = 2'b10;
      end

      // MEM hazard
      if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && 
         !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)) && 
         (MEM_WB_rd == ID_EX_rs1)) begin
         ForwardA = 2'b01;
      end
      if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && 
         !(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)) && 
         (MEM_WB_rd == ID_EX_rs2)) begin
         ForwardB = 2'b01;
      end
   end

endmodule
