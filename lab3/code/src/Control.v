module Control(
         opcode,

         RegWrite,
         MemtoReg,
         MemRead,
         MemWrite,
         ALUOp,
         ALUSrc,
         Branch,

         NoOp,
       );

input [6:0] opcode;
input NoOp;

output reg [1:0] ALUOp;
output reg ALUSrc;
output reg RegWrite;
output reg MemtoReg, MemRead,
       MemWrite, Branch;

wire R_type, I_type;
assign R_type = 7'b0110011;
assign I_type = 7'b0010011;

always@(opcode or NoOp)
  begin
    if (NoOp)
      begin
        RegWrite <= 0;
        MemtoReg <= 0;
        MemRead <= 0;
        MemWrite <= 0;
        ALUOp  <= 2'b0;
        ALUSrc <= 0;
        Branch <= 0;
      end
    else
      case (opcode)
        7'b0110011:  // R-Type
          begin
            RegWrite <= 1;
            MemtoReg <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            ALUOp  <= 2'b11;  // decided by funct code
            ALUSrc <= 0;  // from data2
            Branch <= 0;
          end
        7'b0010011:  // I-Type
          begin
            RegWrite <= 1;
            MemtoReg <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            ALUOp <= 2'b10;  // decided by funct code, imme
            ALUSrc <= 1;  // from imme
            Branch <= 0;
          end
        7'b0000011:   // lw
          begin
            RegWrite <= 1;
            MemtoReg <= 1;
            MemRead <= 1;
            MemWrite <= 0;
            ALUOp <= 2'b01;  // always addition
            ALUSrc <= 1;  // imme
            Branch <= 0;
          end
        7'b0100011:   // sw
          begin
            RegWrite <= 0;
            MemtoReg <= 0;
            MemRead <= 0;
            MemWrite <= 1;
            ALUOp <= 2'b01;  // always addition
            ALUSrc <= 1;  // imme
            Branch <= 0;
          end
        7'b1100011:   // beq
          begin
            RegWrite <= 0;
            MemtoReg <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            ALUOp <= 2'b00;  // always subtraction
            ALUSrc <= 0;  // imme
            Branch <= 1;
          end
        default:
          begin
            ALUOp <= 0;
            ALUSrc <= 0;
            RegWrite <= 0;
            RegWrite <= 0;
            MemtoReg <= 0;
            MemRead <= 0;
            MemWrite <= 0;
            ALUOp <= 2'b00;
            ALUSrc <= 0;
            Branch <= 0;
          end
      endcase
  end

endmodule