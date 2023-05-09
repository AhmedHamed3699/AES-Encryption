module keyExpansion #(parameter nk=4)(round, keyIn, keyOut);

input wire [0 : 3] round;
input wire [0 : (32*nk)-1] key;
output reg [0 : (32*nk)-1] keyOut;

wire [31:0] w0,w1,w2,w3,g;

function [0:31] RotWord;
    input [0:31] w;

    begin
        RotWord = {w[8:31],w[0:7]};
    end
    
endfunction

function [0:31] Rcon;
    input [0:31] w;
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
            4'hb: Rcon = 32'h6C_000000;
            4'hc: Rcon = 32'hD8_000000;
            4'hd: Rcon = 32'hAB_000000;
            4'he: Rcon = 32'h4D_000000;
            4'hf: Rcon = 32'h9A_000000;
            default: Rcon = 32'h00000000;
        endcase
    end

    always @(*) begin
        
    end

endfunction

endmodule