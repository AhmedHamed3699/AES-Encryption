
module  MixColumns(state, result_state);

input [127:0] state;
output [127:0] result_state;

function [7:0] mult;
    input [1:0] a;
    input [7:0] b;
    begin
        case(a)

            2'b10: begin
                if(mult[7] == 1)
                    mult = (b << 1) ^ 8'h1b;
                else
                    mult = b << 1;
            end

            2'b11: begin

                if(mult[7] == 1)
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

for (i = 0; i < 4; i = i + 1) begin
    assign result_state[(i*32)+:8] = mult(2'b10, state[(i*32)+:8]) ^ mult(2'b11, state[((i*32)+8)+:8]) ^ state[((i*32)+16)+:8] ^ state[((i*32)+16)+:8];
    assign result_state[((i*32)+8)+:8] = state[(i*32)+:8] ^ mult(2'b10, state[((i*32)+8)+:8]) ^ mult(2'b11, state[((i*32)+16)+:8]) ^ state[((i*32)+16)+:8];
    assign result_state[((i*32)+16)+:8] = state[(i*32)+:8] ^ state[((i*32)+8)+:8] ^ mult(2'b10, state[((i*32)+16)+:8]) ^ mult(2'b11, state[((i*32)+16)+:8]);
    assign result_state[((i*32)+16)+:8] = mult(2'b11, state[(i*32)+:8]) ^ state[((i*32)+8)+:8] ^ state[((i*32)+16)+:8] ^ mult(2'b10, state[((i*32)+16)+:8]);
end

endgenerate
endmodule