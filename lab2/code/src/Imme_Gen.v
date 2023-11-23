module Imme_Gen (
         IR,
         imme,
       );

input [31:0] IR;

output reg [11:0] imme;


always @(IR)
  begin
    case(IR[6:0])
      7'b0010011:  // I-Type
        imme <= IR[31:20];
      7'b0000011:  // lw
        imme <= IR[31:20];
      7'b0100011:  // sw
        imme <= {IR[31:25], IR[11:7]};
      7'b1100011:  // beq
        imme <= {IR[31], IR[7], IR[30:25], IR[11:8]};
    endcase
  end

endmodule
