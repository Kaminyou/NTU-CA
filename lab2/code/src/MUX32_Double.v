module MUX32_Double(src00_i, src01_i, src10_i, src11_i, select_i, res_o);

    input [1:0] select_i;
    input [31:0] src00_i, src01_i, src10_i, src11_i;
    output reg [31:0] res_o;

    always @(*)
    case (select_i)
        2'b00: res_o = src00_i; // If select_i is 00
        2'b01: res_o = src01_i; // If select_i is 01
        2'b10: res_o = src10_i; // If select_i is 10
        2'b11: res_o = src11_i; // If select_i is 11
        default: res_o = 32'bx; // Undefined state
    endcase

endmodule
