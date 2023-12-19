`define STRONGLY_NON_TAKEN 2'b00
`define WEAKLY_NON_TAKEN   2'b01
`define WEAKLY_TAKEN       2'b10
`define STRONGLY_TAKEN     2'b11

module Branch_Predictor(
    clk_i,
    rst_i,
    EX_Branch_i, // is now EX stage execute a branch?
    EX_gtTaken_i, // is now EX stage execute a branch and it should taken (zero=1)
    predict_o,
);
    input clk_i, rst_i;
    input EX_Branch_i, EX_gtTaken_i;
    output predict_o;

    reg [1:0] state;

    assign predict_o = state[1];

    always @(posedge clk_i or negedge rst_i)
    begin
        if (~rst_i)
            state <= `STRONGLY_TAKEN;
        else if (EX_Branch_i)
        case (state)
            `STRONGLY_TAKEN:
                if (EX_gtTaken_i);
                else
                    state <= `WEAKLY_TAKEN;
            `WEAKLY_TAKEN:
                if (EX_gtTaken_i)
                    state <= `STRONGLY_TAKEN;
                else
                    state <= `WEAKLY_NON_TAKEN;
            `WEAKLY_NON_TAKEN:
                if(EX_gtTaken_i)
                    state <= `WEAKLY_TAKEN;
                else
                    state <= `STRONGLY_NON_TAKEN;
            `STRONGLY_NON_TAKEN:
                if (EX_gtTaken_i)
                    state <= `WEAKLY_NON_TAKEN;
                else;
        endcase
    end
endmodule
