module Branch_Flusher(
    ID_predict_i,
    ID_Branch_i,
    EX_Branch_i, // if EX now a branch
    EX_predict_i,  // previous prediction for EX
    EX_zero_i, // if EX should take the branch
    IF_ID_flush_o,
    ID_EX_flush_o,
    next_pc_select_o,
);

    input ID_predict_i;
    input ID_Branch_i;
    input EX_Branch_i, EX_predict_i, EX_zero_i;

    output reg IF_ID_flush_o, ID_EX_flush_o;
    output reg [1:0] next_pc_select_o;

    wire ID_taken = ID_predict_i && ID_Branch_i; // ID predict taken and is branch
    wire EX_error = EX_predict_i != EX_zero_i; // if the prediction is not equal to gt

    always @(*)
    if (EX_Branch_i && EX_error) // predict error => flush both
    begin
        IF_ID_flush_o <= 1;
        ID_EX_flush_o <= 1;
        if (EX_predict_i) // predict taken, so the real is EX_pc_default
            next_pc_select_o <= 2'b10;
        else // predict non-taken, so the real is EX_pc_branch
            next_pc_select_o <= 2'b11;
    end
    else
    begin
        IF_ID_flush_o <= ID_taken;
        ID_EX_flush_o <= 0;

        if (ID_taken)
            next_pc_select_o <= 2'b01; // predict taken, so the pc change to ID_pc_branch
        else
            next_pc_select_o <= 2'b00; // predict non-taken, use default pc
    end
endmodule
