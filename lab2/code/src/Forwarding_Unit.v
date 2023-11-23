module Forwarding_Unit(
         EX_Rs1,
         EX_Rs2,
         MEM_RegWrite,
         MEM_Rd,
         WB_RegWrite,
         WB_RD,

         ForwardA,
         ForwardB,
       );

input [4:0] EX_Rs1, EX_Rs2, MEM_Rd, WB_RD;
input MEM_RegWrite, WB_RegWrite;

output reg [1:0] ForwardA, ForwardB;

always @(EX_Rs1 or EX_Rs2 or MEM_Rd or WB_RD or MEM_RegWrite or WB_RegWrite)
  begin
    if (MEM_RegWrite && MEM_Rd != 0  && MEM_Rd == EX_Rs1)
      ForwardA <= 2'b10;  // forward: MEM -> EX
    else if(WB_RegWrite && WB_RD != 0 && WB_RD == EX_Rs1)
      ForwardA <= 2'b01;  // forward: WB -> EX
    else
      ForwardA <= 2'b00;  // no forward

    if (MEM_RegWrite && MEM_Rd != 0  && MEM_Rd == EX_Rs2)
      ForwardB <= 2'b10;  // forward: MEM -> EX
    else if(WB_RegWrite && WB_RD != 0 && WB_RD == EX_Rs2)
      ForwardB <= 2'b01;  // forward: WB -> EX
    else
      ForwardB <= 2'b00;  // no forward
  end

endmodule
