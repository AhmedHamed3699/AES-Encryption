`include "../subBytes/SubBytes.v"

module keyExpansion #(parameter nk = 4, parameter nr = 10)(
    input wire [0 : (32*nk) - 1] key,
    output reg [0 : (128*(nr+1)) - 1] schedule
);

integer i;

function [0:31] RotWord;
    input [0:31] word;

    begin
        RotWord = {word[8:31],word[0:7]};
    end
    
endfunction

function [0:31] Rcon;
    input [0:3] round;
    begin
        case(round)
            4'h1: Rcon = 32'h01_000000;
            4'h2: Rcon = 32'h02_000000;
            4'h3: Rcon = 32'h04_000000;
            4'h4: Rcon = 32'h08_000000;
            4'h5: Rcon = 32'h10_000000;
            4'h6: Rcon = 32'h20_000000;
            4'h7: Rcon = 32'h40_000000;
            4'h8: Rcon = 32'h80_000000;
            4'h9: Rcon = 32'h1b_000000;
            4'ha: Rcon = 32'h36_000000;
        endcase
    end
endfunction

always @(*) begin
    keyOut[0:31] = key[(32*nk)-32 +: 32];
    keyOut[0:31] = RotWord(keyOut[0:31]);
    // keyOut[0:31] = subword(keyOut[0:31]);
    keyOut[0:31] = keyOut[0:31] ^ key[0:31] ^ Rcon(round);

    for (i = 1 ; i < nk ; i = i + 1) begin
        keyOut[(32*i) +: 32] = keyOut[(32*(i-1)) +: 32] ^ key[(32*i) +: 32];
    end
end

endmodule