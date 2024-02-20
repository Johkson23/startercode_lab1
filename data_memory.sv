module data_memory #(
    parameter MEM_SIZE = 1024 // Define the memory size, adjust as necessary
) (
    input logic clk,
    input logic memRead,  // Enable reading from memory
    input logic memWrite, // Enable writing to memory
    input logic [31:0] address, // Memory address
    input logic [31:0] writeData, // Data to write to memory
    input logic [2:0] func3, // For determining access size/type
    output logic [31:0] readData // Data read from memory
);
    // Byte-addressable memory with MEM_SIZE depth
    logic [7:0] memory [0:MEM_SIZE-1];

    // Handle memory read operation
    always_ff @(posedge clk) begin
        if (memRead) begin
            case (func3)
                3'b000: readData <= {{24{memory[address][7]}}, memory[address]}; // LB
                3'b001: readData <= {{16{memory[address+1][7]}}, memory[address+1], memory[address]}; // LH
                3'b010: readData <= {memory[address+3], memory[address+2], memory[address+1], memory[address]}; // LW
                3'b100: readData <= {24'b0, memory[address]}; // LBU
                3'b101: readData <= {16'b0, memory[address+1], memory[address]}; // LHU
                default: readData <= 32'b0; // Default case for safety
            endcase
        end
    end

    // Handle memory write operation
    always_ff @(posedge clk) begin
        if (memWrite) begin
            case (func3)
                3'b000: memory[address] <= writeData[7:0]; // SB
                3'b001: {memory[address+1], memory[address]} <= writeData[15:0]; // SH
                3'b010: {memory[address+3], memory[address+2], memory[address+1], memory[address]} <= writeData; // SW
                // For other sizes or atomic operations, extend cases as necessary
            endcase
        end
    end

    // Optionally, initialize the memory with a file for simulation purposes
    initial begin
        // $readmemh("<path_to_initialization_file>", memory);
    end

endmodule