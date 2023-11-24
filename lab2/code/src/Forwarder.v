module Forwarder(EX_Rs1_i, EX_Rs2_i, MEM_RegWrite_i, MEM_Rd_i, WB_RegWrite_i, WB_Rd_i, Forward_A_o, Forward_B_o);

    input [4:0] EX_Rs1_i, EX_Rs2_i; // target rs
    input [4:0] MEM_Rd_i, WB_Rd_i;
    input MEM_RegWrite_i, WB_RegWrite_i;

    output reg [1:0] Forward_A_o, Forward_B_o;

    always @(EX_Rs1_i or EX_Rs2_i or MEM_Rd_i or WB_Rd_i or MEM_RegWrite_i or WB_RegWrite_i)
    begin
        // check from MEM to EX
        if (MEM_RegWrite_i && MEM_Rd_i != 0 && MEM_Rd_i == EX_Rs1_i)
            Forward_A_o <= 2'b10;
        // check from WB to EX
        else if (WB_RegWrite_i && WB_Rd_i != 0 && WB_Rd_i == EX_Rs1_i)
            Forward_A_o <= 2'b01;
        // no need
        else
            Forward_A_o <= 2'b00;

        // check from MEM to EX
        if (MEM_RegWrite_i && MEM_Rd_i != 0 && MEM_Rd_i == EX_Rs2_i)
            Forward_B_o <= 2'b10;
        // check from WB to EX
        else if (WB_RegWrite_i && WB_Rd_i != 0 && WB_Rd_i == EX_Rs2_i)
            Forward_B_o <= 2'b01;
        // no need
        else
            Forward_B_o <= 2'b00;
    end

endmodule
