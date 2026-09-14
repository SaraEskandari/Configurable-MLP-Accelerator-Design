`timescale 1ns/1ns

module matrix_multiplier_gate_tb;

    reg  [31:0]   A; 
    reg  [31:0]   B; 
    wire [35:0] OUT_MULTIPLIER; 

    MATRIX_MULTIPLIER UUT1(
        .A(A),
        .B(B),
        .OUT_MULTIPLIER(OUT_MULTIPLIER)
    );
initial begin
        #1000;
        A = 32'h0;
        B = 32'h0;
        
        #1000;
        A = 32'h0001_0002; 
        B = 32'h0001_0001;
        
        #500;
        A = 32'h0002_0002; 
        B = 32'h0005_0005;

         #500;
        $display("SIMULATION DONE.");
        $stop;
    end

endmodule
