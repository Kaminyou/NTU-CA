module Branch_Handler (
         Predict_i,


         ID_Branch_i,

         EX_Branch_i,
         EX_Predict_i,
         EX_Zero_i,

         IF_ID_Flush_o,
         ID_EX_Flush_o,
         next_pc_select_o,
       );

input Predict_i;


input ID_Branch_i;

input EX_Branch_i, EX_Predict_i, EX_Zero_i;

output reg IF_ID_Flush_o, ID_EX_Flush_o;
output reg [1:0] next_pc_select_o;



always @(*)
  begin: branch

    reg WrongPredict;
    WrongPredict <= EX_Predict_i ^ EX_Zero_i;

    if (EX_Branch_i && WrongPredict)
      begin
        IF_ID_Flush_o <= 1;
        ID_EX_Flush_o <= 1;
        if(EX_Predict_i)
          next_pc_select_o <= 2'b10;
        else
          next_pc_select_o <= 2'b11;
      end
    else
      begin
        IF_ID_Flush_o <= Predict_i && ID_Branch_i;
        ID_EX_Flush_o <= 0;

        if(Predict_i && ID_Branch_i)
          next_pc_select_o <= 2'b01;
        else
          next_pc_select_o <= 2'b00;
      end
  end

endmodule