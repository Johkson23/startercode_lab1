module immediate_gen(
    'include "risc32_starter"

    input wire [31:0] inst,
    output logic [31:0] immGenOut
);
    // Use always_comb for combinational logic
    always_comb begin
        unique case (inst[6:0]) // Using 'unique case' for exhaustive cases
            7'b0010011, // I-type: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
            7'b0000011: // Load instructions are I-type
                immGenOut = {{20{inst[31]}}, inst[31:20]}; // Sign-extended
            7'b0100011: // S-type: SW, SH, SB
                immGenOut = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            7'b1100011: // B-type: BEQ, BNE, BLT, BGE, BLTU, BGEU
                immGenOut = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            7'b1101111: // J-type: JAL
                immGenOut = {{11{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            // Add cases for other types as needed
            default: immGenOut = 32'b0; // Default for unsupported opcodes
        endcase
    end
endmodule 
