module hazard_detection_unit #(parameter REG_NUMBER = 5) (
    input logic ID_EX_MemRead,
    input logic [REG_NUMBER-1:0] IF_ID_rs1,
    input logic [REG_NUMBER-1:0] IF_ID_rs2,
    input logic [REG_NUMBER-1:0] ID_EX_rd,
    output logic IF_ID_Write,
    output logic PCWrite,
    output logic Stall
);

    always_comb begin
        IF_ID_Write = 1'b1;
        PCWrite = 1'b1;
        Stall = 1'b0;

        if (ID_EX_MemRead && ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2))) begin
            IF_ID_Write = 1'b0;
            PCWrite = 1'b0;
            Stall = 1'b1;
        end
    end

endmodule
