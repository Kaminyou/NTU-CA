module Branch_Predictor
       (
         clk_i,
         rst_i,

         update_i,
         result_i,
         predict_o
       );
input clk_i, rst_i, update_i, result_i;
output predict_o;

// TODO

reg [1:0] state;  // 0: strongly taken -> 3: strongly non-taken

always @(posedge clk_i or negedge rst_i)
  begin
    if (~rst_i)
      state <= 0;
    else if (update_i)
      case (state)
        0:
          if(result_i)  // taken
            ;
          else          // non-taken
            state <= 1;
        1:
          if(result_i)  // taken
            state <= 0;
          else          // non-taken
            state <= 2;
        2:
          if(result_i)  // taken
            state <= 1;
          else          // non-taken
            state <= 3;
        3:
          if(result_i)  // taken
            state <= 2;
          else          // non-taken
            ;
      endcase
  end

assign predict_o = ~state[1];

endmodule