module decoder(
    'include "risc32_starter"
    input wire [31:0] inst,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [6:0] opcode,
    output logic [2:0] funct3,
    output logic [6:0] funct7,
    output logic RegWrite,
    output logic ALUSrc,
    output logic MemRead,
    output logic MemWrite,
    output logic MemToReg,
    output logic Branch,
    output logic [3:0] ALUOp
);
    always_comb begin
        opcode = inst[6:0];
        funct3 = inst[14:12];
        funct7 = inst[31:25];
        rd = inst[11:7];
        rs1 = inst[19:15];
        rs2 = inst[24:20];

        // Default signal assignments
        RegWrite = 0;
        ALUSrc = 0;
        MemRead = 0;
        MemWrite = 0;
        MemToReg = 0;
        Branch = 0;
        ALUOp = 4'b0000;

        // Decode logic
        unique case (opcode)
            // Implement opcode-based control signal assignments
            // Example for R-type instructions
            7'b0110011: begin
                RegWrite = 1;
                ALUOp = 4'b0010; // Specific operation code for ALU
            end
            // Extend for other opcodes...
        endcase
    end
endmodule