module mux2_to_1 #(
    parameter WIDTH = 32
)(
    input logic [WIDTH-1:0] input0,
    input logic [WIDTH-1:0] input1,
    input logic sel,
    output logic [WIDTH-1:0] out
);

    always_comb begin
        out = sel ? input1 : input0;
    end
endmodule