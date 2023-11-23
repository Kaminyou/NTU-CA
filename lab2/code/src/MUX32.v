module MUX32(
         in0,
         in1,
         swt,
         res
       );

input swt;
input [31:0] in0, in1;
output reg [31:0] res;

always @(*)
  begin
    if (swt)
      res <= in1;
    else
      res <= in0;
  end

endmodule
