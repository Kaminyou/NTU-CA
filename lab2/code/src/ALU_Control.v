module ALU_Control(
         ALUOp,
         funct7,
         funct3,
         ALUctl
       );

input [1:0] ALUOp;
input [6:0] funct7;
input [2:0] funct3;

output reg [2:0] ALUctl;

always @(ALUOp or funct3 or funct7)
  begin
    case (ALUOp)
      2'b11:  // decided by funct
        begin
          case (funct3)
            3'b111:
              ALUctl <= 0;
            3'b100:
              ALUctl <= 1;
            3'b001:
              ALUctl <= 2;
            3'b000:
              begin
                case (funct7)
                  0:
                    ALUctl <= 3;
                  32:
                    ALUctl <= 4;
                  1:
                    ALUctl <= 5;
                endcase
              end
          endcase
        end
      2'b10:  // decided by funct, with imme
        case (funct3)
          0:
            ALUctl <= 3;
          3'b101:
            ALUctl <= 6;
        endcase
      2'b01:  // always add
        ALUctl <= 3;
      2'b00:  // don't care
        ALUctl <= 0;
    endcase
  end


endmodule
