module MUX32_2(
         in00,
         in01,
         in10,
         in11,
         swt,
         res
       );

input [1:0] swt;
input [31:0] in00, in01, in10, in11;
output reg [31:0] res;

always @(*)
  begin
    if (swt[1])
      if( swt[0])
        res <= in11;
      else
        res <= in10;
    else
      if(swt[0])
        res <= in01;
      else
        res <= in00;
  end

endmodule
