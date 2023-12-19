`define AND  3'b000
`define XOR  3'b001
`define SLL  3'b010
`define ADD  3'b011
`define SUB  3'b100
`define MUL  3'b101
`define ADDI 3'b110
`define SRAI 3'b111

module ALU(src1_i, src2_i, ALUCtr_i, data_o, Zero_o);

    input [31:0] src1_i, src2_i;
    input [2:0] ALUCtr_i;
    output reg [31:0] data_o;
    output Zero_o;

    assign Zero_o = (src1_i == src2_i);

    always @*
    case (ALUCtr_i)
    `AND:
        data_o <= src1_i & src2_i;
    `XOR:
        data_o <= src1_i ^ src2_i;
    `SLL:
        data_o <= src1_i << src2_i;
    `ADD:
        data_o <= src1_i + src2_i;
    `SUB:
        data_o <= src1_i - src2_i;
    `MUL:
        data_o <= src1_i * src2_i;
    `ADDI:
        data_o <= src1_i + src2_i;
    `SRAI:
        data_o <= src1_i >>> src2_i[4:0];
    default:
        data_o <= 32'b0; // Default case to handle undefined ALUCtr_i values
    endcase

endmodule