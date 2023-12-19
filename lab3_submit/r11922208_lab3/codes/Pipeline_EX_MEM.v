module Pipeline_EX_MEM(
    clk_i,
    rst_i,
    ALUout_i,
    WriteData_i,
    Rd_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,

    ALUout_o,
    WriteData_o,
    Rd_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
);

    input clk_i;
    input rst_i;
    input [31:0] ALUout_i, WriteData_i;
    output reg [31:0] ALUout_o, WriteData_o;

    input [4:0] Rd_i;
    output reg [4:0] Rd_o;

    input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i;
    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o;

    always@(posedge clk_i or negedge rst_i)
    if (~rst_i) // init
    begin
        ALUout_o <= 32'b0;
        WriteData_o <= 32'b0;
        Rd_o <= 4'b0;
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
    end
    else
    begin
        ALUout_o <= ALUout_i;
        WriteData_o <= WriteData_i;
        Rd_o <= Rd_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
    end

endmodule