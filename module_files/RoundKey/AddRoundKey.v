module AddRoundKey (
    input [127:0] state_in,
    input [127:0] RoundKey,
    output [127:0]state_out
);

genvar i;

for(i=127 ; i>=0 ; i=i-1)begin
   assign state_out[i]=state_in[i]^RoundKey[i];
end
    
endmodule
