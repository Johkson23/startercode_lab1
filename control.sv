module control(
    input logic [6:0] opcode,
    output logic ALUSrc,
    output logic MemtoReg,
    output logic RegWrite,
    output logic MemRead,
    output logic MemWrite,
    output logic Branch,
    output logic [3:0] ALUOp
);

    // Opcode definitions for RISC-V instruction types
    localparam OPCODE_RTYPE  = 7'b0110011,
               OPCODE_ITYPE  = 7'b0010011,
               OPCODE_STYPE  = 7'b0100011,
               OPCODE_BTYPE  = 7'b1100011,
               OPCODE_UTYPE  = 7'b0110111, // Includes LUI
               OPCODE_JTYPE  = 7'b1101111, // Includes JAL
               OPCODE_LOAD   = 7'b0000011;

    always_comb begin
        // Default signal values for safety
        ALUSrc = 0; MemtoReg = 0; RegWrite = 0;
        MemRead = 0; MemWrite = 0; Branch = 0; ALUOp = 4'b0000;

        case (opcode)
            OPCODE_RTYPE: begin
                ALUSrc = 0; RegWrite = 1; ALUOp = 4'b0010; // Example ALU operation code for ADD
            end
            OPCODE_ITYPE: begin
                ALUSrc = 1; RegWrite = 1; ALUOp = 4'b0011; // Immediate type operations
            end
            OPCODE_STYPE: begin
                ALUSrc = 1; MemWrite = 1; ALUOp = 4'b0100; // Store operations
            end
            OPCODE_BTYPE: begin
                Branch = 1; ALUOp = 4'b0101; // Branch operations
            end
            OPCODE_UTYPE: begin
                // U-type typically involves operations like LUI (load upper immediate)
                ALUSrc = 1; RegWrite = 1; ALUOp = 4'b0110;
            end
            OPCODE_JTYPE: begin
                // JAL (jump and link)
                ALUSrc = 1; RegWrite = 1; ALUOp = 4'b0111;
            end
            OPCODE_LOAD: begin
                ALUSrc = 1; MemtoReg = 1; RegWrite = 1; MemRead = 1; ALUOp = 4'b1000; // Load operations
            end
            // Add more cases for other instruction types as needed
        endcase
    end
endmodule