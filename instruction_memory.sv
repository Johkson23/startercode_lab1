module instruction_memory_sv(
    input logic [31:0] addr, // 32-bit address from the PC
    output logic [31:0] instruction // 32-bit instruction code
);
    // Define memory depth based on RISC-V Green Card specifications and requirements
    parameter int MEM_DEPTH = 1024; // Example, adjust based on requirements
    logic [31:0] mem[0:MEM_DEPTH-1]; // 32-bit wide memory with MEM_DEPTH depth

    // Load instructions from a file for simulation purposes
    initial begin
        $readmemh("instructions.hex", mem);
    end

    // Fetch instruction
    assign instruction = mem[addr >> 2]; // Assuming word-aligned addresses
endmodule