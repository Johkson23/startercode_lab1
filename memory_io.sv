`ifndef _memory_io_
`define _memory_io_

typedef struct packed {
    logic [31:0]    addr;
    logic [31:0]    data;
    logic [3:0]     do_read;
    logic [3:0]     do_write;
    logic           valid;
    logic [2:0]     dummy;
}   memory_io_req;

localparam memory_io_no_req = { 32'd0, 4'b0, 4'b0, 32'b0, 1'b0, 1'b0, 2'b00  };

typedef struct packed {
    logic [31:0]    addr;
    logic [31:0]    data;
    logic           valid;
    logic [2:0]     dummy;
}   memory_io_rsp;

localparam memory_io_no_rsp = { 32'd0, 32'd0, 1'b0, 1'b0, 2'b00 };

`define whole_word  4'b1111

function automatic logic is_whole_word(logic [3:0] control);
    return control[0] & control[1] & control[2] & control[3];
endfunction

function automatic logic is_any_byte(logic [3:0] control);
    return control[0] | control[1] | control[2] | control[3];
endfunction

`endif
