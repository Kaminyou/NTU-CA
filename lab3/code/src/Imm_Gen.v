`define I_TYPE_ALU 7'b0010011
`define I_TYPE_LW 7'b0000011 // lw
`define S_TYPE 7'b0100011 // sw
`define SB_TYPE 7'b1100011 // beq

module Imm_Gen(instr_i, immed_o);

    input [31:0] instr_i;
    output reg [11:0] immed_o;

    always @*
    case(instr_i[6:0])
    `I_TYPE_ALU:
        immed_o <= instr_i[31:20];
    `I_TYPE_LW:
        immed_o <= instr_i[31:20];
    `S_TYPE:
        immed_o <= {instr_i[31:25], instr_i[11:7]};
    `SB_TYPE:
        immed_o <= {instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};
    endcase

endmodule
