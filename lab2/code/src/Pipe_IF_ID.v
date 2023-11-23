module Pipe_IF_ID (
         clk_i,
         rst_i,

         IR_i,
         PC_i,

         IR_o,
         PC_o,

         Flush_i,
         Stall_i,
       );

input clk_i;
input rst_i;
input [31:0] IR_i;
input [31:0] PC_i;
input Flush_i;
input Stall_i;

output reg [31:0] IR_o;
output reg [31:0] PC_o;

always@(posedge clk_i or negedge rst_i)
  begin
    if(~rst_i)
      begin
        PC_o <= 32'b0;
        IR_o <= 32'b0;
      end
    else if (Stall_i)
      // do nothing
      ;
    else if(Flush_i)
      begin
        PC_o <= 32'b0;
        IR_o <= 32'b0;
      end
    else
      begin
        PC_o <= PC_i;
        IR_o <= IR_i;
      end
  end

endmodule
