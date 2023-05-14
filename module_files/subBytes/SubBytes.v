`include "SBox.v"
module SubBytes (byte,sub_byte);
input [127:0] byte;
output [127:0] sub_byte;

genvar i;
generate 
for(i = 0; i < 128; i = i+8)  
	SBox s(byte[i +:8], sub_byte[i +:8]);
endgenerate


endmodule