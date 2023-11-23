`define RTYPE 7'b0110011
`define I_TYPE_ALU 7'b0010011
`define I_TYPE_LW 7'b0000011 // lw
`define S_TYPE 7'b0100011 // sw
`define SB_TYPE 7'b1100011 // beq

module Control(Op_i, NoOp_i, ALUOp_o, ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, Branch_o);

    input [6:0] Op_i;
    input NoOp_i;

    output reg [1:0] ALUOp_o;
    output reg ALUSrc_o;
    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, Branch_o;

    always @*
    begin
        if (NoOp_i)
        begin
            RegWrite_o <= 0;
            MemtoReg_o <= 0;
            MemRead_o <= 0;
            MemWrite_o <= 0;
            ALUOp_o  <= 2'b00;
            ALUSrc_o <= 0;
            Branch_o <= 0;
        end
        else
        case (Op_i)
            `RTYPE:
            begin
                ALUOp_o  <= 2'b10;
                ALUSrc_o <= 0;
                RegWrite_o <= 1;
                MemtoReg_o <= 0;
                MemRead_o <= 0;
                MemWrite_o <= 0;
                Branch_o <= 0;
            end
            `I_TYPE_ALU:
            begin
                ALUOp_o <= 2'b11;
                ALUSrc_o <= 1;
                RegWrite_o <= 1;
                MemtoReg_o <= 0;
                MemRead_o <= 0;
                MemWrite_o <= 0;
                Branch_o <= 0;
            end
            `I_TYPE_LW:
            begin
                ALUOp_o <= 2'b01; // add
                ALUSrc_o <= 1;
                RegWrite_o <= 1;
                MemtoReg_o <= 1;
                MemRead_o <= 1;
                MemWrite_o <= 0;
                Branch_o <= 0;
            end
            `S_TYPE:
            begin
                ALUOp_o <= 2'b01; // add
                ALUSrc_o <= 1;
                RegWrite_o <= 0;
                MemtoReg_o <= 0;
                MemRead_o <= 0;
                MemWrite_o <= 1;
                Branch_o <= 0;
            end
            `SB_TYPE:
            begin
                ALUOp_o <= 2'b00; //sub
                ALUSrc_o <= 0;
                RegWrite_o <= 0;
                MemtoReg_o <= 0;
                MemRead_o <= 0;
                MemWrite_o <= 0;
                Branch_o <= 1;
            end
            default:
            begin
                ALUOp_o <= 2'b00;
                ALUSrc_o <= 0;
                RegWrite_o <= 0;
                RegWrite_o <= 0;
                MemtoReg_o <= 0;
                MemRead_o <= 0;
                MemWrite_o <= 0;
                Branch_o <= 0;
            end
        endcase
    end

endmodule
