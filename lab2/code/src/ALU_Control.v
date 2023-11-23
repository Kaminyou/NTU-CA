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

    always @(ALUOp_i or funct3_i or funct7_i)
    begin
        case (ALUOp_i)
        2'b10:
            begin
            case (funct3_i)
                3'b111:
                ALUCtr_o <= `AND;
                3'b100:
                ALUCtr_o <= `XOR;
                3'b001:
                ALUCtr_o <= `SLL;
                3'b000:
                begin
                    case (funct7_i)
                    7'b0000000:
                        ALUCtr_o <= `ADD;
                    7'b0100000:
                        ALUCtr_o <= `SUB;
                    7'b0000001:
                        ALUCtr_o <= `MUL;
                    endcase
                end
            endcase
            end
        2'b11:
            case (funct3_i)
            3'b000:
                ALUCtr_o <= `ADDI;
            3'b101:
                ALUCtr_o <= `SRAI;
            endcase
        2'b01:
            ALUCtr_o <= `ADD;
        2'b00:
            ALUCtr_o <= `SUB;
        endcase
    end

endmodule
