
module  InvMixColumns(
    input [0:127] state,
    output [0:127] result_state
);

function [7:0] mult (input [1:0] a, input [7:0] b);
    begin

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