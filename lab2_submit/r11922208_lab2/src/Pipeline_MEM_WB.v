module Pipeline_MEM_WB(
    clk_i,
    rst_i,
    MemoryData_i,
    ALUout_i,
    Rd_i,
    RegWrite_i,
    MemtoReg_i,

    MemoryData_o,
    ALUout_o,
    Rd_o,
    RegWrite_o,
    MemtoReg_o,
);

    input clk_i, rst_i;
    input [31:0] ALUout_i, MemoryData_i;
    output reg [31:0] ALUout_o, MemoryData_o;

    input [4:0] Rd_i;    
    output reg [4:0] Rd_o;

    input RegWrite_i, MemtoReg_i;
    output reg RegWrite_o, MemtoReg_o;

    always@(posedge clk_i or negedge rst_i)
    if (~rst_i)
    begin
        ALUout_o <= 32'b0;
        MemoryData_o <= 32'b0;
        Rd_o <= 32'b0;
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
    end
    else
    begin
        ALUout_o <= ALUout_i;
        MemoryData_o <= MemoryData_i;
        Rd_o <= Rd_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
    end

endmodule
