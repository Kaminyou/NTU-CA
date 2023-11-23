module MUX32(src0_i, src1_i, select_i, res_o);
    input [31:0] src0_i, src1_i;
    input select_i;
    output [31:0] res_o;

    assign res_o = ((select_i == 1'b0) ? src0_i : src1_i);

endmodule
