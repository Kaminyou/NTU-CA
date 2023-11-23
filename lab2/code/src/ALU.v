module ALU(
         op1,
         op2,
         res,
         ctl,
       );

input [2:0] ctl;
input signed [31:0]op1, op2;
output reg [31:0] res;

reg [31:0] tmp;
always @(ctl or op1 or op2)
  begin
    case (ctl)
      0:  // and
        res <= op1 & op2;
      1:  // xor
        res <= op1 ^ op2;
      2:  // sll
        res <= op1 << op2;
      3:  // add
        res <= op1+op2;
      4:  // sub
        res <= op1-op2;
      5:  // mul
        res <= op1*op2;
      6:  // sra
        begin
          tmp = op2[4:0];
          res = op1 >>> tmp;
        end
    endcase

  end

endmodule
