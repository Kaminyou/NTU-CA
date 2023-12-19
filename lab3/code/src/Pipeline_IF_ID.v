module Pipeline_IF_ID(clk_i, rst_i, instr_i, pc_i, flush_i, Stall_i, instr_o, pc_o, pc_default_i, pc_default_o);

    input clk_i, rst_i;
    input [31:0] instr_i, pc_i;
    input flush_i, Stall_i;

    input [31:0] pc_default_i;
    output reg [31:0] instr_o, pc_o;
    output reg [31:0] pc_default_o;

    always@(posedge clk_i or negedge rst_i)
    if (~rst_i || flush_i)
    begin
        pc_o <= 32'b0;
        instr_o <= 32'b0;
        pc_default_o <= 32'b0;
    end
    else if (Stall_i);  // nothing
    else
    begin // general case
        pc_o <= pc_i;
        instr_o <= instr_i;
        pc_default_o <= pc_default_i;
    end

endmodule