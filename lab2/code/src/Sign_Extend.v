module Sign_Extend(
         in,
         out
       );

input [11:0] in;
output [31:0] out;

wire [19:0] ext = {20{in[11]}};

assign out = {ext, in} ;

endmodule
