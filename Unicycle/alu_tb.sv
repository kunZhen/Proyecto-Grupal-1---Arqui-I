module alu_tb;
    localparam N = 20;

    // Signal declaration
    reg [N-1:0] A, B;
    reg [2:0] Opcode;
    reg [N-1:0] Result;
    reg Z;

    // Instantiate the alu module
    alu #(N) dut (
        .A(A),
        .B(B),
        .Opcode(Opcode),
        .Result(Result),
        .Z(Z)
    );

    // Function to print results
    function void print_result();
        $display("A = %h, B = %h, Opcode = %b, Result = %h, Z = %b", A, B, Opcode, Result, Z);
    endfunction

    // Simulate the ALU with different operations and input values
    initial begin
        // Test for Add
        A = 20'h80000;
        B = 20'h80000;
        Opcode = 3'b000;
        #10;
        assert(Result == (A + B)) else $error("Add operation failed");
        assert(Z == 1) else $error("Zero flag assertion failed for Add operation");
        print_result();

        // Test for Subtract
        A = 20'hAAAAA;
        B = 20'h55555;
        Opcode = 3'b001;
        #10;
        assert(Result == (A - B)) else $error("Subtract operation failed");
        assert(Z == 0) else $error("Zero flag assertion failed for Subtract operation");
        print_result();
		  
		  // Test for Mul
        A = 20'h00006;
        B = 20'h00002;
        Opcode = 3'b010;
        #10;
        assert(Result == (A * B)) else $error("Mul operation failed");
        assert(Z == 0) else $error("Zero flag assertion failed for Mul operation");
        print_result();
		  
		  // Test for Div
        A = 20'h00006;
        B = 20'h00004;
        Opcode = 3'b011;
        #10;
        assert(Result == (A / B)) else $error("Div operation failed");
        assert(Z == 0) else $error("Zero flag assertion failed for Div operation");
        print_result();
		  
		  // Test for AND
        A = 20'hAAAAA;
        B = 20'h55555;
        Opcode = 3'b100;
        #10;
        assert(Result == (A & B)) else $error("AND operation failed");
        assert(Z == 1) else $error("Zero flag assertion failed for AND operation");
        print_result();

        // Test for OR
        A = 20'hAAAAA;
        B = 20'h55555;
        Opcode = 3'b101;
        #10;
        assert(Result == (A | B)) else $error("OR operation failed");
        assert(Z == 0) else $error("Zero flag assertion failed for OR operation");
        print_result();
		  
		  // Test for Shift Left
        A = 20'h00003;
        B = 20'h00004;
        Opcode = 3'b110;
        #10;
        assert(Result == (A << B)) else $error("Shift Left operation failed");
        assert(Z == 0) else $error("Zero flag assertion failed for Shift Left operation");
        print_result();
		  
		  // Test for Shift Right
        A = 20'h00020;
        B = 20'h00002;
        Opcode = 3'b111;
        #10;
        assert(Result == (A >> B)) else $error("Shift Right operation failed");
        assert(Z == 0) else $error("Zero flag assertion failed for Shift Right operation");
        print_result();
		  
		  $display("Testbench completed successfully");
        $finish;
    end

endmodule
