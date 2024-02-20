module top(input clk, input reset, output logic halt);

memory_io_req 	inst_mem_req;
memory_io_rsp 	inst_mem_rsp;
memory_io_req 	data_mem_req;
memory_io_rsp 	data_mem_rsp;

core32 core(
	.clk(clk)
	,.reset(reset)
	,.reset_pc(32'h0001_0000)
	,.inst_mem_req(inst_mem_req)
	,.inst_mem_rsp(inst_mem_rsp)
	,.inst_mem_req_ack(inst_mem_req.valid)

	,.data_mem_req(data_mem_req)
	,.data_mem_rsp(data_mem_rsp)
	,.data_mem_req_ack(data_mem_req.valid)
    );

memory #(
    .size(32'h0001_0000)
    ,.initialize_mem(true)
    ,.byte0("code0.hex")
    ,.byte1("code1.hex")
    ,.byte2("code2.hex")
    ,.byte3("code3.hex")
    ) code_mem (
    .clk(clk)
    ,.req(inst_mem_req)
    ,.rsp(inst_mem_rsp)
    );

memory #(
    .size(32'h0001_0000)
    ,.initialize_mem(true)
    ,.byte0("data0.hex")
    ,.byte1("data1.hex")
    ,.byte2("data2.hex")
    ,.byte3("data3.hex")
    ) data_mem (
    .clk(clk)
    ,.req(data_mem_req)
    ,.rsp(data_mem_rsp)
    );

always_ff @(posedge clk)
	if (data_mem_req.valid && data_mem_req.addr == 32'h0002_FFF8 && data_mem_req.do_write == 4'b1111) begin
		//$display("yay!");
		$write("%c", data_mem_req.data[7:0]);
	end

always_ff @(posedge clk)
	if (data_mem_req.valid && data_mem_req.addr == 32'h0002_FFFC && data_mem_req.do_write == 4'b1111)
		halt <= true;
	else
		halt <= false;


endmodule
