
module  MixColumns(state, result_state);

input [7:0] state [0:3][0:3];
output [7:0] result_state [0:3][0:3];

function [7:0] multiply;
    input [1:0] a;
    input [7:0] b;
    begin
        case(a)

            2'b10: begin
                if(multiply[7] == 1)
                    multiply = (b << 1) ^ 8'h1b;
                else
                    multiply = b << 1;
            end

            2'b11: begin

                if(multiply[7] == 1)
                    multiply = (b << 1) ^ 8'h1b;
                else
                    multiply = b << 1;

                multiply = multiply ^ b;

            end

            default: multiply = multiply;

        endcase
    end 
    
endfunction
genvar j;
generate
    
for (j = 0; j < 4; j = j + 1) begin
    result_state[0][j] = multiply(.a(2'b10), .b(state[0][j])) ^ multiply(.a(2'b11), .b(state[1][j])) ^ state[2][j] ^ state[3][j];
    result_state[1][j] = state[0][j] ^ multiply(.a(2'b10), .b(state[1][j])) ^ multiply(.a(2'b11), .b(state[2][j])) ^ state[3][j];
    result_state[2][j] = state[0][j] ^ state[1][j] ^ multiply(.a(2'b10), .b(state[2][j])) ^ multiply(.a(2'b11), .b(state[3][j]));
    result_state[3][j] = multiply(.a(2'b11), .b(state[0][j])) ^ state[1][j] ^ state[2][j] ^ multiply(.a(2'b10), .b(state[3][j]));
end

endgenerate
endmodule