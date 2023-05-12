`include "InverseSbox.v"
module InverseSubBytes(sub_byte,byte);
input [127:0] sub_byte;
output [127:0] byte;

genvar i;
generate 
for(i = 0; i < 128; i = i+8) 
	InverseSbox s(sub_byte[i +:8],byte[i +:8]);
endgenerate


endmodule