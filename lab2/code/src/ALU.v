`define AND  3'b000
`define XOR  3'b001
`define SLL  3'b010
`define ADD  3'b011
`define SUB  3'b100
`define MUL  3'b101
`define ADDI 3'b110
`define SRAI 3'b111

module ALU(src1_i, src2_i, res_o, ALUCtr_i);

    input [31:0] src1_i, src2_i;
    input [2:0] ALUCtr_i;
    output reg [31:0] res_o;
    reg [31:0] tmp;

    always @(ALUCtr_i or src1_i or src2_i)
    begin
        case (ALUCtr_i)
        `AND:
            res_o <= src1_i & src2_i;
        `XOR:
            res_o <= src1_i ^ src2_i;
        `SLL:
            res_o <= src1_i << src2_i;
        `ADD:
            res_o <= src1_i + src2_i;
        `SUB:
            res_o <= src1_i - src2_i;
        `MUL:
            res_o <= src1_i * src2_i;
        `ADDI:
            res_o <= src1_i + src2_i;
        `SRAI:
            res_o <= src1_i >>> src2_i[4:0];
        default:
            res_o <= 32'b0; // Default case to handle undefined ALUCtr_i values
        endcase

    end

endmodule
