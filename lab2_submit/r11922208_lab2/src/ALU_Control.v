`define AND  3'b000
`define XOR  3'b001
`define SLL  3'b010
`define ADD  3'b011
`define SUB  3'b100
`define MUL  3'b101
`define ADDI 3'b110
`define SRAI 3'b111

module ALU_Control(ALUOp_i, funct7_i, funct3_i, ALUCtr_o);

    input [1:0] ALUOp_i;
    input [6:0] funct7_i;
    input [2:0] funct3_i;

    output reg [2:0] ALUCtr_o;

    always @*
    case (ALUOp_i)
    2'b00:
        ALUCtr_o <= `SUB;
    2'b01:
        ALUCtr_o <= `ADD;
    2'b10:
        case ({funct7_i, funct3_i})
        10'b0000000111:
            ALUCtr_o <= `AND;
        10'b0000000100:
            ALUCtr_o <= `XOR;
        10'b0000000001:
            ALUCtr_o <= `SLL;
        10'b0000000000:
            ALUCtr_o <= `ADD;
        10'b0100000000:
            ALUCtr_o <= `SUB;
        10'b0000001000:
            ALUCtr_o <= `MUL;
        endcase
    2'b11:
        case (funct3_i)
        3'b000:
            ALUCtr_o <= `ADDI;
        3'b101:
            ALUCtr_o <= `SRAI;
        endcase
    endcase

endmodule
