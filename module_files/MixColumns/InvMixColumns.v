
module  InvMixColumns(
    input [0:127] state,
    output [0:127] result_state
);

function [7:0] mult2 (input [7:0] b);
    begin

        if(b[7] == 1)
            mult2 = ((b << 1) ^ 8'h1b);
        else
            mult2 = b << 1;

    end
endfunction

function [7:0] mult (input [3:0] a, input [7:0] b);
    begin
        case(a)

            4'h9: begin // (((b × 2) × 2) × 2) + b

                mult = mult2(b);
                mult = mult2(mult);
                mult = mult2(mult);
                mult = mult ^ b;

            end

            4'hb: begin // ((((b × 2) × 2) + b) × 2) + b

                mult = mult2(b);
                mult = mult2(mult);
                mult = mult ^ b;
                mult = mult2(mult);
                mult = mult ^ b;

            end

            4'hd: begin // ((((b × 2) + b) × 2) × 2) + b
                
                mult = mult2(b);
                mult = mult ^ b;
                mult = mult2(mult);
                mult = mult2(mult);
                mult = mult ^ b;

            end

            4'he: begin // ((((b × 2) + b) × 2) + b) × 2

                mult = mult2(b);
                mult = mult ^ b;
                mult = mult2(mult);
                mult = mult ^ b;
                mult = mult2(mult);

            end

            default: mult = mult;

        endcase
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