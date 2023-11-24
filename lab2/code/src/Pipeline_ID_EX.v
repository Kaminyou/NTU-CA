module Pipeline_ID_EX(
    clk_i,
    rst_i,
    RS1data_i,
    RS2data_i,
    immed_i,
    pc_i,
    Rd_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    instr_i,
    RS1addr_i,
    RS2addr_i,

    RS1data_o,
    RS2data_o,
    immed_o,
    pc_o,
    Rd_o,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    instr_o,
    RS1addr_o,
    RS2addr_o,
);

    input clk_i;
    input rst_i;

    input [31:0] RS1data_i, RS2data_i;
    output reg [31:0] RS1data_o, RS2data_o;

    input [31:0] immed_i, pc_i;
    output reg [31:0] immed_o, pc_o;

    input [4:0] Rd_i;
    output reg [4:0] Rd_o;

    input [31:0] instr_i;
    output reg [31:0] instr_o;

    input RegWrite_i, MemtoReg_i, MemRead_i, MemWrite_i, ALUSrc_i;
    output reg RegWrite_o, MemtoReg_o, MemRead_o, MemWrite_o, ALUSrc_o;

    input [1:0] ALUOp_i;
    output reg [1:0] ALUOp_o;

    input [4:0] RS1addr_i, RS2addr_i;
    output reg [4:0] RS1addr_o, RS2addr_o;

    always@(posedge clk_i or negedge rst_i)
    if (~rst_i) // init
    begin
        RS1data_o <= 32'b0;
        RS2data_o <= 32'b0;
        immed_o <= 32'b0;
        pc_o <= 32'b0;
        Rd_o <= 32'b0;
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUOp_o <= 0;
        ALUSrc_o <= 0;
        instr_o <= 0;
        RS1addr_o <= 0;
        RS2addr_o <= 0;
    end
    else
    begin
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        immed_o <= immed_i;
        pc_o <= pc_i;
        Rd_o <= Rd_i;
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        instr_o <= instr_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
    end

endmodule
