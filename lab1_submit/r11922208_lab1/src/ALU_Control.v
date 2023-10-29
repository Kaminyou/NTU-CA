`define AND  3'b000
`define XOR  3'b001
`define SLL  3'b010
`define ADD  3'b011
`define SUB  3'b100
`define MUL  3'b101
`define ADDI 3'b110
`define SRAI 3'b111

module ALU_Control(ALUOp_i, func_i, ALUCtr_o);

    input [1:0] ALUOp_i;
    input [9:0] func_i;
    output [2:0] ALUCtr_o;

    assign ALUCtr_o = (
        (ALUOp_i == 2'b10) ? (
            (func_i == 10'b0000000111) ? `AND : 
                (func_i == 10'b0000000100) ? `XOR :
                    (func_i == 10'b0000000001) ? `SLL :
                        (func_i == 10'b0000000000) ? `ADD :
                            (func_i == 10'b0100000000) ? `SUB : `MUL) : 
            (
                (func_i == 10'b0100000101) ? `SRAI : `ADDI)
            );

endmodule
