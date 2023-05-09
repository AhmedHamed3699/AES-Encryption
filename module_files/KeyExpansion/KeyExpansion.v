module keyExpansion #(parameter nk=4,parameter nr=10)(key,w);

input wire [0 : (32*nk)-1] key;
output reg [0 : (128*(nr+1))-1] w; // 32*nb -> 128

endmodule