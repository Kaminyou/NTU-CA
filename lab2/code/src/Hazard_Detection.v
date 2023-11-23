module Hazard_Detection(clk_i, rst_i, ID_Rs1, ID_Rs2, EX_MemRead, EX_Rd, NoOp, PCWrite, Stall_o);

    input rst_i, clk_i;
    input [4:0] ID_Rs1, ID_Rs2, EX_Rd;
    input EX_MemRead;

    output reg NoOp, PCWrite, Stall_o;

    always @*
    begin
        // Hazard detected
        if (EX_MemRead && (ID_Rs1 == EX_Rd || ID_Rs2 == EX_Rd)) begin
            NoOp <= 1;
            PCWrite <= 0;
            Stall_o <= 1;
        // nothing
        end else begin
            NoOp <= 0;
            PCWrite <= 1;
            Stall_o <= 0;
        end
    end

endmodule
