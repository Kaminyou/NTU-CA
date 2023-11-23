module Pipe_ID_EX (
         clk_i,
         rst_i,

         A_i,
         B_i,
         imme_i,
         PC_i,
         RD_i,

         A_o,
         B_o,
         imme_o,
         PC_o,
         RD_o,

         RegWrite_i,
         MemtoReg_i,
         MemRead_i,
         MemWrite_i,
         ALUOp_i,
         ALUSrc_i,

         RegWrite_o,
         MemtoReg_o,
         MemRead_o,
         MemWrite_o,
         ALUOp_o,
         ALUSrc_o,

         IR_i,
         IR_o,

         Rs1_i,
         Rs2_i,
         Rs1_o,
         Rs2_o,
       );

input clk_i;
input rst_i;
input [31:0] A_i;
input [31:0] B_i;
input [31:0] imme_i;
input [31:0] PC_i;
input [4:0] RD_i;

output reg [31:0] A_o;
output reg [31:0] B_o;
output reg [31:0] imme_o;
output reg [31:0] PC_o;
output reg [4:0] RD_o;

input [31:0] IR_i;
output reg [31:0] IR_o;

// ! Signals
input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
input [1:0] ALUOp_i;
output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;
output reg [1:0] ALUOp_o;

// ! Forwarding
input [4:0] Rs1_i, Rs2_i;
output reg [4:0] Rs1_o, Rs2_o;

always@(posedge clk_i or negedge rst_i)
  begin
    if(~rst_i)
      begin
        A_o <= 32'b0;
        B_o <= 32'b0;
        imme_o <= 32'b0;
        PC_o <= 32'b0;
        RD_o <= 32'b0;

        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUOp_o <= 0;
        ALUSrc_o <= 0;

        Rs1_o <= 0;
        Rs2_o <= 0;

        IR_o <= 0;
      end
    else
      begin
        A_o <= A_i;
        B_o <= B_i;
        imme_o <= imme_i;
        PC_o <= PC_i;
        RD_o <= RD_i;

        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;

        Rs1_o <= Rs1_i;
        Rs2_o <= Rs2_i;

        IR_o <= IR_i;
      end
  end



endmodule
