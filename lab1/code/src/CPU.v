module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] instr, pc, pc_next;
wire zero;
wire [1:0] ALUOp;
wire [2:0] ALUCtr;
wire ALUSrc, RegWrite;
wire [31:0] RS1data, RS2data;
wire [31:0] IMMdata;
wire [31:0] ALUrst;
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
    .RDdata_i(ALUrst),
    .RegWrite_i(RegWrite), 
    .RS1data_o(RS1data), 
    .RS2data_o(RS2data)
);

MUX32 MUX_ALUSrc(
    .src0_i(RS2data),
    .src1_i(IMMdata),
    .select_i(ALUSrc),
    .res_o(ALUdata2_i)
);

Sign_Extend Sign_Extend(
    .data_i(instr[31:20]),
    .data_o(IMMdata)
);
  
ALU ALU(
    .src1_i(RS1data),
    .src2_i(ALUdata2_i),
    .ALUCtr_i(ALUCtr),
    .res_o(ALUrst),
    .zero_o(zero)
);

ALU_Control ALU_Control(
    .ALUOp_i(ALUOp),
    .func_i({instr[31:25], instr[14:12]}),
    .ALUCtr_o(ALUCtr)
);
// ALU_Control ALU_Control(
//     .ALUOp_i(ALUOp),
//     .func_i({instr[31:25], instr[14:12]}),
//     .ALUCtr_o(ALUCtr)
// );


endmodule

