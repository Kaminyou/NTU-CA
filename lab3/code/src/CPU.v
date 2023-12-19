module CPU
(
    clk_i,
    rst_i,
);
input               clk_i;
input               rst_i;

wire [31:0] IF_PC_o, IF_Adder_o, IF_PC_i, IF_IR;


PC PC (
     .clk_i(clk_i),
     .rst_i(rst_i),
     .PCWrite_i(PCWrite),
     .pc_i(IF_PC_i),
     .pc_o(IF_PC_o)
   );

Adder Add_PC(
    .src1_i(IF_PC_o),
    .src2_i(32'd4),
    .res_o(IF_Adder_o)
);

Instruction_Memory Instruction_Memory(
                     .addr_i(IF_PC_o),
                     .instr_o(IF_IR)
                   );

Pipe_IF_ID IF_ID(
             .clk_i(clk_i),
             .rst_i(rst_i),

             .IR_i(IF_IR),
             .PC_i(IF_PC_o),

             .IR_o(ID_IR),
             .PC_o(ID_PC),

             .flush_i(ID_Flush),
             .Stall_i(Stall)
           );


// * ID

// ? input
wire [31:0] ID_IR;
wire [31:0] ID_PC;

// ? output
wire [31:0] ID_data1, ID_data2, ID_imme;
wire [4:0] ID_RD, ID_Rs1, ID_Rs2;
assign ID_RD = ID_IR[11:7];
assign ID_Rs1 = ID_IR[19:15];
assign ID_Rs2 = ID_IR[24:20];

// ! output signals
wire ID_RegWrite, ID_MemtoReg,
     ID_MemRead, ID_MemWrite,
     ID_ALUSrc, ID_Branch;
wire [1:0] ID_ALUOp;


// wire ID_to_branch, ID_Flush;
// assign ID_to_branch = (ID_data1 == ID_data2) & ID_Branch;
// assign ID_Flush = ID_to_branch;

// wire [31:0] ID_branch_PC;
// assign ID_branch_PC = (ID_imme << 1) + ID_PC;

wire [11:0] imme_o;

Registers Registers(
            .rst_i(rst_i),
            .clk_i(clk_i),

            .RS1addr_i(ID_Rs1),
            .RS2addr_i(ID_Rs2),

            .RDaddr_i(WB_RD),
            .RDdata_i(WB_RDdata),
            .RegWrite_i(WB_RegWrite),

            .RS1data_o(ID_data1),
            .RS2data_o(ID_data2)
          );


Imm_Gen Imm_Gen (
    .instr_i(ID_IR),
    .immed_o(imme_o)
);

Sign_Extend Sign_Extend(
    .data_i(imme_o),
    .data_o(ID_imme)
);

Control Control(
    .Op_i(ID_IR[6:0]),
    .NoOp_i(NoOp),
    .ALUOp_o(ID_ALUOp),
    .ALUSrc_o(ID_ALUSrc),
    .RegWrite_o(ID_RegWrite),
    .MemtoReg_o(ID_MemtoReg),
    .MemRead_o(ID_MemRead),
    .MemWrite_o(ID_MemWrite),
    .Branch_o(ID_Branch)
);

Pipe_ID_EX ID_EX(
             .clk_i(clk_i),
             .rst_i(rst_i),

             .A_i(ID_data1),
             .B_i(ID_data2),
             .imme_i(ID_imme),
             .PC_i(ID_PC),
             .RD_i(ID_RD),

             .A_o(EX_A),
             .B_o(EX_B),
             .imme_o(EX_imme),
             .PC_o(EX_PC),
             .RD_o(EX_RD),

             .RegWrite_i(ID_RegWrite),
             .MemtoReg_i(ID_MemtoReg),
             .MemRead_i(ID_MemRead),
             .MemWrite_i(ID_MemWrite),
             .ALUOp_i(ID_ALUOp),
             .ALUSrc_i(ID_ALUSrc),

             .RegWrite_o(EX_RegWrite),
             .MemtoReg_o(EX_MemtoReg),
             .MemRead_o(EX_MemRead),
             .MemWrite_o(EX_MemWrite),
             .ALUOp_o(EX_ALUOp),
             .ALUSrc_o(EX_ALUSrc),

             .Rs1_i(ID_Rs1),
             .Rs2_i(ID_Rs2),
             .Rs1_o(EX_Rs1),
             .Rs2_o(EX_Rs2),

             .IR_i(ID_IR),
             .IR_o(EX_IR),

             .Branch_i(ID_Branch),
             .Predict_i(Predict)
           );


// * EX

// ? input
wire [31:0] EX_A, EX_B, EX_imme, EX_PC;
wire [4:0] EX_RD, EX_Rs1, EX_Rs2;
wire [31:0] EX_IR;

wire EX_RegWrite, EX_MemtoReg, EX_MemRead, EX_MemWrite, EX_ALUSrc;
wire [1:0] EX_ALUOp;

// ? output
wire signed [31:0] EX_ALUout;

// ? internal
wire [31:0] MUX_A_o, MUX_B_o;
wire [31:0] ALU_A_i, ALU_B_i;
wire [2:0] ALUctl;

assign ALU_A_i = MUX_A_o;

MUX32_Double MUX_A(
    .src00_i(EX_A),
    .src01_i(WB_RDdata),
    .src10_i(MEM_ALUout),
    .src11_i(0),
    .select_i(ForwardA),
    .res_o(MUX_A_o)
);

MUX32_Double MUX_B(
    .src00_i(EX_B),
    .src01_i(WB_RDdata),
    .src10_i(MEM_ALUout),
    .src11_i(0),
    .select_i(ForwardB),
    .res_o(MUX_B_o)
);

MUX32 MUX_ALUSrc(
    .src0_i(MUX_B_o),
    .src1_i(EX_imme),
    .select_i(EX_ALUSrc),
    .res_o(ALU_B_i)
);


ALU ALU(
    .src1_i(ALU_A_i),
    .src2_i(ALU_B_i),
    .data_o(EX_ALUout),
    .ALUCtr_i(ALUctl)
);

ALU_Control ALU_Control(
              .ALUOp(EX_ALUOp),
              .funct7(EX_IR[31:25]),
              .funct3(EX_IR[14:12]),
              .ALUctl(ALUctl)
            );

Pipe_EX_MEM EX_MEM (
              .clk_i(clk_i),
              .rst_i(rst_i),

              .ALUout_i(EX_ALUout),
              .WD_i(MUX_B_o),
              .RD_i(EX_RD),

              .ALUout_o(MEM_ALUout),
              .WD_o(MEM_WD),
              .RD_o(MEM_RD),

              .RegWrite_i(EX_RegWrite),
              .MemtoReg_i(EX_MemtoReg),
              .MemRead_i(EX_MemRead),
              .MemWrite_i(EX_MemWrite),

              .RegWrite_o(MEM_RegWrite),
              .MemtoReg_o(MEM_MemtoReg),
              .MemRead_o(MEM_MemRead),
              .MemWrite_o(MEM_MemWrite)
            );

// * MEM

// ? inputs
wire [31:0] MEM_ALUout, MEM_WD;
wire [4:0] MEM_RD;
wire MEM_RegWrite, MEM_MemtoReg, MEM_MemRead,MEM_MemWrite;

// ? output
wire [31:0] MEM_MD;  // memory data

Data_Memory Data_Memory(
              .clk_i(clk_i),

              .addr_i(MEM_ALUout),
              .MemRead_i(MEM_MemRead),
              .MemWrite_i(MEM_MemWrite),
              .data_i(MEM_WD),

              .data_o(MEM_MD)
            );

Pipe_MEM_WB MEM_WB(
              .clk_i(clk_i),
              .rst_i(rst_i),

              .MD_i(MEM_MD),
              .ALUout_i(MEM_ALUout),
              .RD_i(MEM_RD),

              .MD_o(WB_MD),
              .ALUout_o(WB_ALUout),
              .RD_o(WB_RD),

              .RegWrite_i(MEM_RegWrite),
              .MemtoReg_i(MEM_MemtoReg),
              .RegWrite_o(WB_RegWrite),
              .MemtoReg_o(WB_MemtoReg)
            );

// * WB

// ? input
wire [31:0] WB_ALUout, WB_MD;
wire [4:0] WB_RD;
wire WB_MemtoReg, WB_RegWrite;

// ? output
wire [31:0] WB_RDdata;

MUX32 WB_MUX(
    .src0_i(WB_ALUout),
    .src1_i(WB_MD),
    .select_i(WB_MemtoReg),
    .res_o(WB_RDdata)
);


// * Forwarding Unit

wire [1:0] ForwardA, ForwardB;
Forwarding_Unit Forwarding_Unit (
                  .EX_Rs1(EX_Rs1),
                  .EX_Rs2(EX_Rs2),
                  .MEM_RegWrite(MEM_RegWrite),
                  .MEM_Rd(MEM_RD),
                  .WB_RegWrite(WB_RegWrite),
                  .WB_RD(WB_RD),

                  .ForwardA(ForwardA),
                  .ForwardB(ForwardB)
                );

// * Hazard Detection

// ! Signals
wire NoOp, PCWrite, Stall;

Hazard_Detection_Unit Hazard_Detection_Unit(
                        .clk_i(clk_i),
                        .rst_i(rst_i),

                        .ID_Rs1(ID_Rs1),
                        .ID_Rs2(ID_Rs2),
                        .EX_Rd(EX_RD),
                        .EX_MemRead(EX_MemRead),

                        .NoOp(NoOp),
                        .PCWrite(PCWrite),
                        .Stall(Stall)
                      );


wire Predict;

Branch_Predictor branch_predictor(
                   .clk_i(clk_i),
                   .rst_i(rst_i),

                   .update_i(ID_EX.Branch_o),
                   .result_i(ALU.Zero_o),
                   .predict_o(Predict)
                 );

Branch_Handler Branch_Handler(
                 .clk_i(clk_i),
                 .rst_i(rst_i),

                 .Predict_i(Predict),

                 .IF_adder_pc_i(IF_Adder_o),

                 .ID_Branch_i(ID_Branch),
                 .ID_imme_i(ID_imme),
                 .ID_pc_i(ID_PC),

                 .EX_Branch_i(ID_EX.Branch_o),
                 .EX_Predict_i(ID_EX.Predict_o),
                 .EX_Zero_i(ALU.Zero_o),
                 .EX_imme_i(EX_imme),
                 .EX_pc_i(EX_PC),

                 .IF_ID_Flush_o(IF_ID.flush_i),
                 .ID_EX_Flush_o(ID_EX.flush_i),
                 .next_pc_o(IF_PC_i)
               );


endmodule
