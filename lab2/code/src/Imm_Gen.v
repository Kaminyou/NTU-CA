`define I_TYPE_ALU 7'b0010011
`define I_TYPE_LW 7'b0000011 // lw
`define S_TYPE 7'b0100011 // sw
`define SB_TYPE 7'b1100011 // beq

module Imm_Gen(instr, immed);

    input [31:0] instr;
    output reg [11:0] immed;

    always @(instr)
        begin
            case(instr[6:0])
                `I_TYPE_ALU:
                    immed <= instr[31:20];
                `I_TYPE_LW:
                    immed <= instr[31:20];
                `S_TYPE:
                    immed <= {instr[31:25], instr[11:7]};
                `SB_TYPE:
                    immed <= {instr[31], instr[7], instr[30:25], instr[11:8]};
            endcase
        end

endmodule
