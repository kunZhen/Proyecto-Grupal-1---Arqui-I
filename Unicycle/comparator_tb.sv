module comparator_tb;
    localparam DATA_WIDTH = 20;

    // Signal declaration
    reg [DATA_WIDTH-1:0] a, b;
    reg ge, lt;

    // Instantiate the comparator module
    comparator #(DATA_WIDTH) dut (
        .a(a),
        .b(b),
        .lt(lt),
        .ge(ge)
    );

    // Function to print results
    function void print_result();
        $display("a = %h, b = %h, lt = %b, ge = %b", a, b, lt, ge);
    endfunction
	 
    initial begin
	 
		  // Test for lt
        a = 32'h0000000f;
        b = 32'h00000010;
        #10;
        assert(lt == 1) else $error("lt flag assertion failed.");
        assert(ge == 0) else $error("ge flag assertion failed.");
        print_result();
		  
        // Test for ge
        a = 32'h0000000A;
        b = 32'h00000005;
        #10;
        assert(lt == 0) else $error("lt flag assertion failed.");
        assert(ge == 1) else $error("ge flag assertion failed.");
        print_result();

        $display("Testbench completed successfully");
        $finish;
    end

endmodule
