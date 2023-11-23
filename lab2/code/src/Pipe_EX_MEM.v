module Pipe_EX_MEM (
         clk_i,
         rst_i,

         ALUout_i,
         WD_i,
         RD_i,

         ALUout_o,
         WD_o,
         RD_o,

         RegWrite_i,
         MemtoReg_i,
         MemRead_i,
         MemWrite_i,

         RegWrite_o,
         MemtoReg_o,
         MemRead_o,
         MemWrite_o,
       );

input clk_i;
input rst_i;
input [31:0] ALUout_i;
input [31:0] WD_i;
input [4:0] RD_i;

output reg [31:0] ALUout_o;
output reg [31:0] WD_o;
output reg [4:0] RD_o;

// ! Signals
input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;


always@(posedge clk_i or negedge rst_i)
  begin
    if(~rst_i)
      begin
        ALUout_o <= 32'b0;
        WD_o <= 32'b0;
        RD_o <= 4'b0;

        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
      end
    else
      begin
        ALUout_o <= ALUout_i;
        WD_o <= WD_i;
        RD_o <= RD_i;

        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
      end
  end



endmodule
