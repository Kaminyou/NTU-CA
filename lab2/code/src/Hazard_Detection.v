module Hazard_Detection(ID_Rs1_i, ID_Rs2_i, EX_MemRead_i, EX_Rd_i, NoOp_o, PCWrite_o, Stall_o);

    input [4:0] ID_Rs1_i, ID_Rs2_i, EX_Rd_i;
    input EX_MemRead_i;

    output reg NoOp_o, PCWrite_o, Stall_o;

    always @*
    // Hazard detected
    if (EX_MemRead_i && (ID_Rs1_i == EX_Rd_i || ID_Rs2_i == EX_Rd_i))
    begin
        NoOp_o <= 1;
        PCWrite_o <= 0;
        Stall_o <= 1;
    // nothing
    end
    else
    begin
        NoOp_o <= 0;
        PCWrite_o <= 1;
        Stall_o <= 0;
    end

endmodule
