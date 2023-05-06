
module  InvMixColumns(
    input [0:127] state,
    output [0:127] result_state
);

function [7:0] mult (input [3:0] a, input [7:0] b);
    reg [10:0] temp1;
    reg [10:0] temp2;
    reg [10:0] temp3;
    reg [10:0] temp4;
    begin
        temp1[7:0]  = a[0] & b;
        temp2[8:1]  = a[1] & b;
        temp3[9:2]  = a[2] & b;
        temp4[10:3] = a[3] & b;
        mult = temp1 + temp2 + temp3 + temp4;
    end
endfunction

genvar i;
generate

// the idea behind indexing is [ (i*32) + (j*8) ] where i is the column and j is the row , then move 8 bits to take the whole byte

for (i = 0; i < 4; i = i + 1) begin
    assign result_state[(i*32)+:8]      = mult(8'h0e, state[(i*32)+:8]) ^ mult(8'h0b, state[((i*32)+8)+:8]) ^ mult(8'h0d, state[((i*32)+16)+:8]) ^ mult(8'h09, state[((i*32)+24)+:8]);
    assign result_state[((i*32)+8)+:8]  = mult(8'h09, state[(i*32)+:8]) ^ mult(8'h0e, state[((i*32)+8)+:8]) ^ mult(8'h0b, state[((i*32)+16)+:8]) ^ mult(8'h0d, state[((i*32)+24)+:8]);
    assign result_state[((i*32)+16)+:8] = mult(8'h0d, state[(i*32)+:8]) ^ mult(8'h09, state[((i*32)+8)+:8]) ^ mult(8'h0e, state[((i*32)+16)+:8]) ^ mult(8'h0b, state[((i*32)+24)+:8]);
    assign result_state[((i*32)+24)+:8] = mult(8'h0b, state[(i*32)+:8]) ^ mult(8'h0d, state[((i*32)+8)+:8]) ^ mult(8'h09, state[((i*32)+16)+:8]) ^ mult(8'h0e, state[((i*32)+24)+:8]);
    
end

endgenerate
endmodule