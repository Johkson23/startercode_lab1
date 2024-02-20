module ifu(
    input logic clk,
    input logic reset,
    output logic [31:0] pc, // Program Counter
    output logic [31:0] instruction // Fetched instruction
);
    // Assuming InstructionMemory_sv is an updated SystemVerilog module
    InstructionMemory_sv instMem(
        .addr(pc),
        .instruction(instruction)
    );

    // PC update logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0; // Reset PC to start of memory
        end else begin
            pc <= pc + 4; // Increment PC to point to the next instruction
        end
    end
endmodule