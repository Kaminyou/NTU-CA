module Branch_Handler (

         clk_i,
         rst_i,

         Predict_i,

         IF_adder_pc_i,

         ID_Branch_i,
         ID_imme_i,
         ID_pc_i,

         EX_Branch_i,
         EX_Predict_i,
         EX_Zero_i,
         EX_imme_i,
         EX_pc_i,

         IF_ID_Flush_o,
         ID_EX_Flush_o,
         next_pc_o,
       );


input clk_i, rst_i;

input Predict_i;

input [31:0] IF_adder_pc_i;

input ID_Branch_i;
input [31:0] ID_imme_i, ID_pc_i;

input EX_Branch_i, EX_Predict_i, EX_Zero_i;
input [31:0] EX_imme_i, EX_pc_i;

output reg IF_ID_Flush_o, ID_EX_Flush_o;
output reg [31:0] next_pc_o;



always @(*)
  begin: branch

    reg WrongPredict;
    WrongPredict <= EX_Predict_i ^ EX_Zero_i;

    if (EX_Branch_i && WrongPredict)
      begin
        IF_ID_Flush_o <= 1;
        ID_EX_Flush_o <= 1;
        if(EX_Predict_i)
          next_pc_o <= EX_pc_i + 4;
        else
          next_pc_o <= EX_pc_i + (EX_imme_i << 1);
      end
    else
      begin
        IF_ID_Flush_o <= Predict_i && ID_Branch_i;
        ID_EX_Flush_o <= 0;

        if(Predict_i && ID_Branch_i)
          next_pc_o <= ID_pc_i + (ID_imme_i << 1);
        else
          next_pc_o <= IF_adder_pc_i;
      end
  end

endmodule