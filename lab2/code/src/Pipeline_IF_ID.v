module Pipeline_IF_ID(clk_i, rst_i, instr_i, pc_i, instr_o, pc_o, Flush_i, Stall_i);

    input clk_i, rst_i;
    input [31:0] instr_i, pc_i;
    input Flush_i, Stall_i;

    output reg [31:0] instr_o, pc_o;

    always@(posedge clk_i or negedge rst_i)
    begin
        if (~rst_i)
        begin
            pc_o <= 32'b0;
            instr_o <= 32'b0;
        end
        else if (Stall_i);  // nothing
        else if (Flush_i)
        begin
            pc_o <= 32'b0;
            instr_o <= 32'b0;
        end else begin // general case
            pc_o <= pc_i;
            instr_o <= instr_i;
        end
    end

endmodule
