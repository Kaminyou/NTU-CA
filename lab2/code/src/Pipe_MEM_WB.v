module Pipe_MEM_WB (
         clk_i,
         rst_i,

         MD_i,
         ALUout_i,
         RD_i,

         MD_o,
         ALUout_o,
         RD_o,

         RegWrite_i,
         MemtoReg_i,
         RegWrite_o,
         MemtoReg_o,

       );

input clk_i;
input rst_i;
input [31:0] ALUout_i;
input [31:0] MD_i;
input [4:0] RD_i;

output reg [31:0] ALUout_o;
output reg [31:0] MD_o;
output reg [4:0] RD_o;

input RegWrite_i, MemtoReg_i;
output reg RegWrite_o, MemtoReg_o;

always@(posedge clk_i or negedge rst_i)
  begin
    if(~rst_i)
      begin
        ALUout_o <= 32'b0;
        MD_o <= 32'b0;
        RD_o <= 32'b0;
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
      end
    else
      begin
        ALUout_o <= ALUout_i;
        MD_o <= MD_i;
        RD_o <= RD_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
      end
  end



endmodule
