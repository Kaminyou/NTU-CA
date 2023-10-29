`define AND  3'b000
`define XOR  3'b001
`define SLL  3'b010
`define ADD  3'b011
`define SUB  3'b100
`define MUL  3'b101
`define ADDI 3'b110
`define SRAI 3'b111

module ALU(src1_i, src2_i, ALUCtr_i, res_o, zero_o);

    input [31:0] src1_i, src2_i;
    input [2:0] ALUCtr_i;
    output [31:0] res_o;
    output zero_o;

    assign res_o = (
        (ALUCtr_i == `AND) ? src1_i & src2_i : 
            (ALUCtr_i == `XOR) ? src1_i ^ src2_i :
                (ALUCtr_i == `SLL) ? src1_i << src2_i :
                    (ALUCtr_i == `ADD) ? src1_i + src2_i :
                        (ALUCtr_i == `SUB) ? src1_i - src2_i :
                            (ALUCtr_i == `MUL) ? src1_i * src2_i :
                                (ALUCtr_i == `ADDI) ? src1_i + src2_i : src1_i >>> src2_i[4:0]);
    assign zero_o = ((src1_i - src2_i == 0) ? 1'b1 : 1'b0);

endmodule
