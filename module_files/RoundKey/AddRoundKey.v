module AddRoundKey (
    input [127:0] state_in,
    input [127:0] RoundKey,
    output [127:0]state_out
);


   assign state_out=state_in^RoundKey;
    
endmodule
