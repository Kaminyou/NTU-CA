`define R_TYPE 7'b0110011
`define I_TYPE_ALU 7'b0010011
`define I_TYPE_LW 7'b0000011 // lw
`define S_TYPE 7'b0100011 // sw
`define SB_TYPE 7'b1100011 // beq

module Control(Op_i, NoOp_i, ALUOp_o, ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, Branch_o);

    input [6:0] Op_i;
    input NoOp_i;

    output reg [1:0] ALUOp_o;
    output reg ALUSrc_o, RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, Branch_o;

    always @*
    if (NoOp_i)
    begin
        ALUOp_o  <= 2'b00;
        ALUSrc_o <= 0;
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        Branch_o <= 0;
    end
    else
    case (Op_i)
        `R_TYPE:
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

endmodule

// module Control(
//          opcode,

//          RegWrite,
//          MemtoReg,
//          MemRead,
//          MemWrite,
//          ALUOp,
//          ALUSrc,
//          Branch,

//          NoOp,
//        );

// input [6:0] opcode;
// input NoOp;

// output reg [1:0] ALUOp;
// output reg ALUSrc;
// output reg RegWrite;
// output reg MemtoReg, MemRead,
//        MemWrite, Branch;

// wire R_type, I_type;
// assign R_type = 7'b0110011;
// assign I_type = 7'b0010011;

// always@(opcode or NoOp)
//   begin
//     if (NoOp)
//       begin
//         RegWrite <= 0;
//         MemtoReg <= 0;
//         MemRead <= 0;
//         MemWrite <= 0;
//         ALUOp  <= 2'b0;
//         ALUSrc <= 0;
//         Branch <= 0;
//       end
//     else
//       case (opcode)
//         7'b0110011:  // R-Type
//           begin
//             RegWrite <= 1;
//             MemtoReg <= 0;
//             MemRead <= 0;
//             MemWrite <= 0;
//             ALUOp  <= 2'b11;  // decided by funct code
//             ALUSrc <= 0;  // from data2
//             Branch <= 0;
//           end
//         7'b0010011:  // I-Type
//           begin
//             RegWrite <= 1;
//             MemtoReg <= 0;
//             MemRead <= 0;
//             MemWrite <= 0;
//             ALUOp <= 2'b10;  // decided by funct code, imme
//             ALUSrc <= 1;  // from imme
//             Branch <= 0;
//           end
//         7'b0000011:   // lw
//           begin
//             RegWrite <= 1;
//             MemtoReg <= 1;
//             MemRead <= 1;
//             MemWrite <= 0;
//             ALUOp <= 2'b01;  // always addition
//             ALUSrc <= 1;  // imme
//             Branch <= 0;
//           end
//         7'b0100011:   // sw
//           begin
//             RegWrite <= 0;
//             MemtoReg <= 0;
//             MemRead <= 0;
//             MemWrite <= 1;
//             ALUOp <= 2'b01;  // always addition
//             ALUSrc <= 1;  // imme
//             Branch <= 0;
//           end
//         7'b1100011:   // beq
//           begin
//             RegWrite <= 0;
//             MemtoReg <= 0;
//             MemRead <= 0;
//             MemWrite <= 0;
//             ALUOp <= 2'b00;  // always subtraction
//             ALUSrc <= 0;  // imme
//             Branch <= 1;
//           end
//         default:
//           begin
//             ALUOp <= 0;
//             ALUSrc <= 0;
//             RegWrite <= 0;
//             RegWrite <= 0;
//             MemtoReg <= 0;
//             MemRead <= 0;
//             MemWrite <= 0;
//             ALUOp <= 2'b00;
//             ALUSrc <= 0;
//             Branch <= 0;
//           end
//       endcase
//   end

// endmodule