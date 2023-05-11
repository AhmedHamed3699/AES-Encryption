
module  MixColumns(
    input [0:127] state,
    output [0:127] result_state
);

function [7:0] mult (input [1:0] a, input [7:0] b);
    begin
        case(a)

            2'b10: begin
                if(b[7] == 1)
                    mult = ((b << 1) ^ 8'h1b);
                else
                    mult = b << 1;
            end

            2'b11: begin

                
                if(b[7] == 1)
                    mult = (b << 1) ^ 8'h1b;
                else
                    mult = b << 1;

                mult = mult ^ b;

            end

            default: mult = mult;

        endcase
    end
endfunction

genvar i;
generate

// the idea behind indexing is [ (i*32) + (j*8) ] where i is the column and j is the row , then move 8 bits to take the whole byte

for (i = 0; i < 4; i = i + 1) begin
    assign result_state[(i*32)+:8] = mult(2'b10, state[(i*32)+:8]) ^ mult(2'b11, state[((i*32)+8)+:8]) ^ state[((i*32)+16)+:8] ^ state[((i*32)+24)+:8];
    assign result_state[((i*32)+8)+:8] = state[(i*32)+:8] ^ mult(2'b10, state[((i*32)+8)+:8]) ^ mult(2'b11, state[((i*32)+16)+:8]) ^ state[((i*32)+24)+:8];
    assign result_state[((i*32)+16)+:8] = state[(i*32)+:8] ^ state[((i*32)+8)+:8] ^ mult(2'b10, state[((i*32)+16)+:8]) ^ mult(2'b11, state[((i*32)+24)+:8]);
    assign result_state[((i*32)+24)+:8] = mult(2'b11, state[(i*32)+:8]) ^ state[((i*32)+8)+:8] ^ state[((i*32)+16)+:8] ^ mult(2'b10, state[((i*32)+24)+:8]);
    
end

endgenerate
endmodule