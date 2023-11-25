module Branch(
    immed_i,
    pc_i,
    RS1data_i,
    RS2data_i,
    ID_Branch_i,
    ID_branch_pc_o,
    ID_branch_ctr_o,
);
    input [31:0] immed_i, pc_i;
    input [31:0] RS1data_i, RS2data_i;
    input ID_Branch_i;

    output [31:0] ID_branch_pc_o;
    output ID_branch_ctr_o;

    assign ID_branch_pc_o = (immed_i << 1) + pc_i;
    assign ID_branch_ctr_o = (RS1data_i == RS2data_i) & ID_Branch_i;

endmodule
