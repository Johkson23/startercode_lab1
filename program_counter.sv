module program_counter(
    input logic clk,        // Clock signal
    input logic reset,      // Asynchronous reset signal
    input logic en,         // Enable signal to update the PC
    input logic [31:0] next_pc, // Input for the next value of PC, typically from branch logic or incrementer
    output logic [31:0] pc  // Current value of the program counter
);

    // On reset, set PC to zero or a predefined start address
    // On positive clock edge, if enabled, update PC to next_pc
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0; // Reset PC to 0 or change to a different starting address as needed
        end else if (en) begin
            pc <= next_pc; // Update PC to the next value if enabled
        end
    end

endmodule