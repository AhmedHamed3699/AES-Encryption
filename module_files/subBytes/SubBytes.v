`include "SBox.v"
module SubBytes #(parameter n = 128)(byte,sub_byte);
input [n-1:0] byte;
output [n-1:0] sub_byte;

genvar i;
generate 
for(i = 0; i < n; i = i+8)  
	SBox s(byte[i +:8], sub_byte[i +:8]);
endgenerate


endmodule