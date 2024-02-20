module register_file(
    input logic clk,
    input logic reset,
    input logic regWrite, // Enable signal for writing to a register
    input logic [4:0] readReg1, // Address of the first register to read
    input logic [4:0] readReg2, // Address of the second register to read
    input logic [4:0] writeReg, // Address of the register to write
    input logic [31:0] writeData, // Data to write into the register
    output logic [31:0] readData1, // Output data from the first read register
    output logic [31:0] readData2  // Output data from the second read register
);

// 32 registers each 32 bits wide
logic [31:0] registers[0:31];

// Initialize the registers to 0 upon reset
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        for (int i = 0; i < 32; i++) begin
            registers[i] <= 0;
        end
    end else if (regWrite && (writeReg != 5'b0)) begin // Write data to register if regWrite is enabled and not writing to x0
        registers[writeReg] <= writeData;
    end
end

// Asynchronous read from the registers
// Register x0 is hardwired to 0
assign readData1 = (readReg1 == 5'b0) ? 32'b0 : registers[readReg1];
assign readData2 = (readReg2 == 5'b0) ? 32'b0 : registers[readReg2];

endmodule