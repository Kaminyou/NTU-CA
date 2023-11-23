module Forwarder(EX_Rs1, EX_Rs2, MEM_RegWrite, MEM_Rd, WB_RegWrite, WB_Rd, Forward_A, Forward_B);

    input [4:0] EX_Rs1, EX_Rs2; // target rs
    input [4:0] MEM_Rd, WB_Rd;
    input MEM_RegWrite, WB_RegWrite;

    output reg [1:0] Forward_A, Forward_B;

    always @(EX_Rs1 or EX_Rs2 or MEM_Rd or WB_Rd or MEM_RegWrite or WB_RegWrite)
    begin
        // check from MEM to EX
        if (MEM_RegWrite && MEM_Rd != 0 && MEM_Rd == EX_Rs1)
            Forward_A <= 2'b10;
        // check from WB to EX
        else if(WB_RegWrite && WB_Rd != 0 && WB_Rd == EX_Rs1)
            Forward_A <= 2'b01;
        // no need
        else
            Forward_A <= 2'b00;

        // check from MEM to EX
        if (MEM_RegWrite && MEM_Rd != 0 && MEM_Rd == EX_Rs2)
            Forward_B <= 2'b10;
        // check from WB to EX
        else if(WB_RegWrite && WB_Rd != 0 && WB_Rd == EX_Rs2)
            Forward_B <= 2'b01;
        // no need
        else
            Forward_B <= 2'b00;
    end

endmodule
