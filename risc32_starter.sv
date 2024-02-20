
typedef logic bool;
localparam logic true = 1;
localparam logic false = 0;

`define enable_ext_m        1
`define tag_size            5
`define word_size           32
`define word_address_size   32
typedef logic [`tag_size - 1:0]             tag;
typedef logic [4:0]                         shamt;
typedef logic [31:0]                        instr32;
typedef logic [2:0]                         funct3;
typedef logic [6:0]                         funct7;
typedef logic [6:0]                         opcode;
typedef logic [`word_size:0]                ext_operand;
typedef logic [`word_size - 1:0]            operand;
typedef logic [`word_size - 1:0]            word;
typedef logic [`word_address_size - 1:0]    word_address;

typedef enum {
     r_format = 0
    ,i_format
    ,s_format
    ,u_format
    ,b_format
    ,j_format
} instr_format;

function automatic bool is_16bit_instruction(logic [31:0] instr);
    if (instr[1:0] == 2'b11)
        return false;
    else
        return true;
endfunction

////// 32 bit instruction decode helpers.
function automatic tag decode32_rs2(instr32 instr);
    return instr[24:20];
endfunction

function automatic shamt decode32_shamt(instr32 instr);
    return instr[24:20];
endfunction

function automatic tag decode32_rs1(instr32 instr);
    return instr[19:15];
endfunction

function automatic tag decode32_rd(instr32 instr);
    return instr[11:7];
endfunction

// Must match instruction encoding
typedef enum logic [2:0] {
    f3_addsub  = 0
    ,f3_sll = 1
    ,f3_slt = 2
    ,f3_sltu = 3
    ,f3_xor = 4
    ,f3_sral = 5
    ,f3_or = 6
    ,f3_and = 7
}   f3_op;

// Must match instruction encoding
typedef enum logic [2:0] {
     f3_ext_m_mul = 0
    ,f3_ext_m_mulh = 1
    ,f3_ext_m_mulhsu = 2
    ,f3_ext_m_mulhu = 3
    ,f3_ext_m_div = 4
    ,f3_ext_m_divu = 5
    ,f3_ext_m_rem = 6
    ,f3_ext_m_remu = 7
}   f3_ext_m_op;

function funct3 decode32_funct3(instr32 instr);
    return instr[14:12];
endfunction

localparam f7_add = 7'b0000000;
localparam f7_sub = 7'b0100000;
localparam f7_ext_mul = 7'b0000001;

function bool cast_to_f3_mod(funct7 in);
    return in[5];
endfunction

function automatic f3_ext_m_op cast_to_ext_m(funct3 in);
    return in;
endfunction


function automatic opcode decode32_opcode(instr32 instr);
    return instr[6:0];
endfunction

function automatic logic [31:0] decode32_imm(instr32 instr, instr_format format);
    case(format)
        i_format : return { {21{instr[31]}},           instr[30:25], instr[24:21], instr[20] };
        s_format : return { {21{instr[31]}},           instr[30:25], instr[11:8], instr[7] };
        b_format : return { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0 };
        u_format : return { instr[31], instr[30:20], instr[19:12], {12{1'b0}} };
        j_format : return { {12{instr[31]}}, instr[19:12], instr[20], instr[30:25], instr[24:21], 1'b0 };
        default: return {32{1'b0}};       
    endcase 
endfunction

function automatic ext_operand cast_to_ext_operand(operand in);
    return { in[31], in };
endfunction 

function automatic operand cast_to_operand(ext_operand in);
    return in[31:0];
endfunction

function automatic bool is_negative(ext_operand in);
    return in[31];
endfunction

function automatic bool is_over_or_under(ext_operand in);
    return in[32];
endfunction 

typedef enum logic [4:0] {
    q_load        = 5'b00000
    ,q_store      = 5'b01000
    ,q_madd       = 5'b10000
    ,q_branch     = 5'b11000
    ,q_load_fp    = 5'b00001
    ,q_store_fp   = 5'b01001
    ,q_msub       = 5'b10001
    ,q_jalr       = 5'b11001
    ,q_custom_0   = 5'b00010
    ,q_custom_1   = 5'b01010
    ,q_nmsub      = 5'b10010
    ,q_reserved_0 = 5'b11010
    ,q_misc_mem   = 5'b00011
    ,q_amo        = 5'b01011
    ,q_nmadd      = 5'b10011
    ,q_jal        = 5'b11011
    ,q_op_imm     = 5'b00100
    ,q_op         = 5'b01100
    ,q_op_fp      = 5'b10100
    ,q_system     = 5'b11100
    ,q_auipc      = 5'b00101
    ,q_lui        = 5'b01101
    ,q_reserved_1 = 5'b10101
    ,q_reserved_2 = 5'b11101
    ,q_op_imm32   = 5'b00110
    ,q_op32       = 5'b01110
    ,q_custom_2   = 5'b10110
    ,q_custom_3   = 5'b11110
    ,q_unknown    = 5'b00111
} opcode_q;

function automatic opcode_q decode32_opcode_q(instr32 instr);
    // return instr[6:2]   --- this works too, but the code below detects opcodes we don't support
    case (instr[6:2])
// Unfortunately Vivado complains about the simple way. So we take the long way (below)
//        q_load, q_store, q_branch, q_jalr,
//        q_jal, q_op_imm, q_op, q_auipc, q_lui:   return instr[6:2];
            q_load:     return q_load;
            q_store:    return q_store;
            q_branch:   return q_branch;
            q_jalr:     return q_jalr;
            q_jal:      return q_jal;
            q_op_imm:   return q_op_imm;
            q_op:       return q_op;
            q_auipc:    return q_auipc;
            q_lui:      return q_lui;
        default:
            return q_unknown;
    endcase
endfunction

function automatic bool decode32_writeback(opcode_q in);
    case (in)
        q_load, q_jalr, q_jal, q_op_imm, q_op, q_auipc, q_lui:  return true;
        default: return false;
    endcase
endfunction

// Must match instruction encoding
typedef enum logic [2:0] {
     memory_b = 0
    ,memory_h = 1
    ,memory_w = 2
    ,memory_bu = 4
    ,memory_hu = 5
}   memory_op;

function automatic memory_op cast_to_memory_op(funct3 in);
// This works, except Vivado complains. So we take the long way (below)
//    return in;  // Yes really
    case (in)
        memory_b: return memory_b;
        memory_h: return memory_h;
        memory_w: return memory_w;
        memory_bu: return memory_bu;
        memory_hu: return memory_hu;
        default: return memory_b;
    endcase;
endfunction

function automatic instr_format decode32_format(opcode_q op_q);
    case (op_q)
        q_load, q_op_imm, q_jalr:  return i_format;
        q_jal:              return j_format;
        q_branch:           return b_format;
        q_op:               return r_format;
        q_store:            return s_format;
        q_lui, q_auipc:     return u_format;
        default:
            return r_format;
    endcase
endfunction

function automatic funct7 decode32_funct7(instr32 instr, instr_format format);
    if (format == r_format)
        return instr[31:25];
    return 7'd0;
endfunction

// Must match instruction encoding
typedef enum logic [2:0] {
     beq = 0
    ,bne = 1
    ,blt = 4
    ,bge = 5
    ,bltu = 6
    ,bgeu = 7
}   branch_ops;
