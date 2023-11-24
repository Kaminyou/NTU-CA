module CPU
(
    clk_i, 
    rst_i,
);

	input clk_i;
	input rst_i;

	// Program Counter Signals
	wire [31:0] pc, pc_next, IF_pc, IF_instr;

	// Instruction Fetch (IF) Stage Signals
	wire NoOp, PCWrite, Stall;
	wire [31:0] ID_pc, ID_instr;

	// Instruction Decode (ID) Stage Registers and Control Signals
	wire [31:0] ID_data1, ID_data2, ID_immed;
	wire [4:0] ID_Rd, ID_Rs1, ID_Rs2;
	wire [1:0] ID_ALUOp;
	wire ID_RegWrite, ID_MemtoReg, ID_MemRead, ID_MemWrite, ID_ALUSrc, ID_Branch;
	wire ID_branch_ctr, ID_FlushIF;

	// Instruction Decode (ID) Stage Assignments
	assign ID_Rd = ID_instr[11:7];
	assign ID_Rs1 = ID_instr[19:15];
	assign ID_Rs2 = ID_instr[24:20];
	assign ID_branch_ctr = (ID_data1 == ID_data2) & ID_Branch;
	assign ID_FlushIF = ID_branch_ctr;

	// Branch Calculation
	wire [31:0] ID_branch_pc;
	assign ID_branch_pc = (ID_immed << 1) + ID_pc;

	// Immediate Value Extraction
	wire [11:0] immed;

	// Execution (EX) Stage Signals
	wire [31:0] EX_data1, EX_data2, EX_immed, EX_pc, EX_instr;
	wire [4:0] EX_Rd, EX_Rs1, EX_Rs2;
	wire [1:0] EX_ALUOp;
	wire EX_RegWrite, EX_MemtoReg, EX_MemRead, EX_MemWrite, EX_ALUSrc;
	wire signed [31:0] EX_ALUout;

	// ALU Control
	wire [2:0] ALUctl;

	// Multiplexer Outputs for ALU
	wire [31:0] MUX_First_o, MUX_Second_o, ALUdata2_i;

	// Memory Access (MEM) Stage Signals
	wire [31:0] MEM_ALUout, MEM_WriteData, MEM_MemoryData;
	wire [4:0] MEM_Rd;
	wire MEM_RegWrite, MEM_MemtoReg, MEM_MemRead, MEM_MemWrite;

	// Write Back (WB) Stage Signals
	wire [31:0] WB_ALUout, WB_MemoryData, WB_RDdata;
	wire [4:0] WB_Rd;
	wire WB_MemtoReg, WB_RegWrite;

	// Forwarding Unit Signals
	wire [1:0] Forward_A, Forward_B;


	Forwarder Forwarder(
		.EX_Rs1(EX_Rs1),
		.EX_Rs2(EX_Rs2),
		.MEM_RegWrite(MEM_RegWrite),
		.MEM_Rd(MEM_Rd),
		.WB_RegWrite(WB_RegWrite),
		.WB_Rd(WB_Rd),
		.Forward_A(Forward_A),
		.Forward_B(Forward_B)
	);

	Hazard_Detection Hazard_Detection(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.ID_Rs1(ID_Rs1),
		.ID_Rs2(ID_Rs2),
		.EX_MemRead(EX_MemRead),
		.EX_Rd(EX_Rd),
		.NoOp(NoOp),
		.PCWrite(PCWrite),
		.Stall_o(Stall)
	);

	MUX32 MUX_PC(
		.src0_i(pc_next),
		.src1_i(ID_branch_pc),
		.select_i(ID_branch_ctr),
		.res_o(IF_pc)
	);

	PC PC(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.PCWrite_i(PCWrite),
		.pc_i(IF_pc),
		.pc_o(pc)
	);

	Adder Add_PC(
		.src1_i(pc),
		.src2_i(32'd4),
		.res_o(pc_next)
	);

	Instruction_Memory Instruction_Memory(
		.addr_i(pc),
		.instr_o(IF_instr)
	);

	Pipeline_IF_ID Pipeline_IF_ID(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.instr_i(IF_instr),
		.pc_i(pc),
		.instr_o(ID_instr),
		.pc_o(ID_pc),
		.Flush_i(ID_FlushIF),
		.Stall_i(Stall)
	);

	Registers Registers(
		.rst_i(rst_i),
		.clk_i(clk_i),
		.RS1addr_i(ID_Rs1),
		.RS2addr_i(ID_Rs2),
		.RDaddr_i(WB_Rd),
		.RDdata_i(WB_RDdata),
		.RegWrite_i(WB_RegWrite),
		.RS1data_o(ID_data1),
		.RS2data_o(ID_data2)
	);

	Imm_Gen Imm_Gen(
		.instr(ID_instr),
		.immed(immed)
	);

	Sign_Extend Sign_Extend(
		.data_i(immed),
		.data_o(ID_immed)
	);

	Control Control(
		.Op_i(ID_instr[6:0]),
		.NoOp_i(NoOp),
		.ALUOp_o(ID_ALUOp),
		.ALUSrc_o(ID_ALUSrc),
		.RegWrite_o(ID_RegWrite),
		.MemtoReg_o(ID_MemtoReg),
		.MemRead_o(ID_MemRead),
		.MemWrite_o(ID_MemWrite),
		.Branch_o(ID_Branch)
	);

	Pipeline_ID_EX Pipeline_ID_EX(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.RS1data_i(ID_data1),
		.RS2data_i(ID_data2),
		.immed_i(ID_immed),
		.pc_i(ID_pc),
		.Rd_i(ID_Rd),
		.RegWrite_i(ID_RegWrite),
		.MemtoReg_i(ID_MemtoReg),
		.MemRead_i(ID_MemRead),
		.MemWrite_i(ID_MemWrite),
		.ALUOp_i(ID_ALUOp),
		.ALUSrc_i(ID_ALUSrc),
		.instr_i(ID_instr),
		.RS1addr_i(ID_Rs1),
		.RS2addr_i(ID_Rs2),
		.RS1data_o(EX_data1),
		.RS2data_o(EX_data2),
		.immed_o(EX_immed),
		.pc_o(EX_pc),
		.Rd_o(EX_Rd),
		.RegWrite_o(EX_RegWrite),
		.MemtoReg_o(EX_MemtoReg),
		.MemRead_o(EX_MemRead),
		.MemWrite_o(EX_MemWrite),
		.ALUOp_o(EX_ALUOp),
		.ALUSrc_o(EX_ALUSrc),
		.instr_o(EX_instr),
		.RS1addr_o(EX_Rs1),
		.RS2addr_o(EX_Rs2)
	);

	MUX32_Double MUX_First(
		.src00_i(EX_data1),
		.src01_i(WB_RDdata),
		.src10_i(MEM_ALUout),
		.src11_i(0),
		.select_i(Forward_A),
		.res_o(MUX_First_o)
	);

	MUX32_Double MUX_Second(
		.src00_i(EX_data2),
		.src01_i(WB_RDdata),
		.src10_i(MEM_ALUout),
		.src11_i(0),
		.select_i(Forward_B),
		.res_o(MUX_Second_o)
	);

	MUX32 MUX_ALUSrc(
		.src0_i(MUX_Second_o),
		.src1_i(EX_immed),
		.select_i(EX_ALUSrc),
		.res_o(ALUdata2_i)
	);


	ALU ALU(
		.src1_i(MUX_First_o),
		.src2_i(ALUdata2_i),
		.ALUCtr_i(ALUctl),
		.res_o(EX_ALUout)
	);

	ALU_Control ALU_Control(
		.ALUOp_i(EX_ALUOp),
		.funct7_i(EX_instr[31:25]),
		.funct3_i(EX_instr[14:12]),
		.ALUCtr_o(ALUctl)
	);

	Pipeline_EX_MEM Pipeline_EX_MEM(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.ALUout_i(EX_ALUout),
		.WriteData_i(MUX_Second_o),
		.Rd_i(EX_Rd),
		.RegWrite_i(EX_RegWrite),
		.MemtoReg_i(EX_MemtoReg),
		.MemRead_i(EX_MemRead),
		.MemWrite_i(EX_MemWrite),
		.ALUout_o(MEM_ALUout),
		.WriteData_o(MEM_WriteData),
		.Rd_o(MEM_Rd),
		.RegWrite_o(MEM_RegWrite),
		.MemtoReg_o(MEM_MemtoReg),
		.MemRead_o(MEM_MemRead),
		.MemWrite_o(MEM_MemWrite)
	);


	Data_Memory Data_Memory(
		.clk_i(clk_i),
		.addr_i(MEM_ALUout),
		.MemRead_i(MEM_MemRead),
		.MemWrite_i(MEM_MemWrite),
		.data_i(MEM_WriteData),
		.data_o(MEM_MemoryData)
	);

	Pipeline_MEM_WB Pipeline_MEM_WB(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.MemoryData_i(MEM_MemoryData),
		.ALUout_i(MEM_ALUout),
		.Rd_i(MEM_Rd),
		.RegWrite_i(MEM_RegWrite),
		.MemtoReg_i(MEM_MemtoReg),
		.MemoryData_o(WB_MemoryData),
		.ALUout_o(WB_ALUout),
		.Rd_o(WB_Rd),
		.RegWrite_o(WB_RegWrite),
		.MemtoReg_o(WB_MemtoReg)
	);

	MUX32 MUX_WB(
		.src0_i(WB_ALUout),
		.src1_i(WB_MemoryData),
		.select_i(WB_MemtoReg),
		.res_o(WB_RDdata)
	);

endmodule
