module ALU(data1_i, data2_i, ALUctl_i, data_o, Zero_o);

input signed [31:0] data1_i, data2_i;
input  [2:0]  ALUctl_i;
output reg [31:0] data_o;
output        Zero_o;


assign Zero_o = (data2_i == data1_i);

reg [31:0] tmp;
always @(ALUctl_i or data1_i or data2_i)
  begin
    case (ALUctl_i)
      0:  // and
        data_o <= data1_i & data2_i;
      1:  // xor
        data_o <= data1_i ^ data2_i;
      2:  // sll
        data_o <= data1_i << data2_i;
      3:  // add
        data_o <= data1_i+data2_i;
      4:  // sub
        data_o <= data1_i-data2_i;
      5:  // mul
        data_o <= data1_i*data2_i;
      6:  // sra
        begin
          tmp = data2_i[4:0];
          data_o = data1_i >>> tmp;
        end
    endcase

  end

endmodule