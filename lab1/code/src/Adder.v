module Adder(src1_i, src2_i, res_o);
    input [31:0] src1_i, src2_i;
    output [31:0] res_o;

    assign res_o = src1_i + src2_i;
endmodule