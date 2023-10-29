module CPU
(
    clk_i, 
    rst_i,
);

input               clk_i;
input               rst_i;

// pc & instruction
wire [31:0] instr, immed;
wire [31:0] pc, pc_next;

// register
wire [31:0] RS1data, RS2data;

// control
wire zero, ALUSrc, RegWrite;
wire [1:0] ALUOp;
wire [2:0] ALUCtr;

// ALU
wire [31:0] ALUres;
wire [31:0] ALUdata2_i;

Control Control(
    .Op_i(instr[6:0]),
    .ALUOp_o(ALUOp),
    .ALUSrc_o(ALUSrc),
    .RegWrite_o(RegWrite)
);

Adder Add_PC(
    .src1_i(pc),
    .src2_i(32'd4),
    .res_o(pc_next)
);

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_i(pc_next),
    .pc_o(pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i(pc),
    .instr_o(instr)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(instr[19:15]),
    .RS2addr_i(instr[24:20]),
    .RDaddr_i(instr[11:7]),
    .RDdata_i(ALUres),
    .RegWrite_i(RegWrite), 
    .RS1data_o(RS1data), 
    .RS2data_o(RS2data)
);

MUX32 MUX_ALUSrc(
    .src0_i(RS2data),
    .src1_i(immed),
    .select_i(ALUSrc),
    .res_o(ALUdata2_i)
);

Sign_Extend Sign_Extend(
    .data_i(instr[31:20]),
    .data_o(immed)
);
  
ALU ALU(
    .src1_i(RS1data),
    .src2_i(ALUdata2_i),
    .ALUCtr_i(ALUCtr),
    .res_o(ALUres),
    .zero_o(zero)
);

ALU_Control ALU_Control(
    .ALUOp_i(ALUOp),
    .func_i({instr[31:25], instr[14:12]}),
    .ALUCtr_o(ALUCtr)
);

endmodule
