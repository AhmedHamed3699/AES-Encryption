`include"Encryption.v"
`include"Decryption.v"
module Wrapper #(parameter Nk =4 , parameter Nr=10)
(
    // input clk,
    // input reset,
    input [127:0] data_in_encrypt,
    input [Nk*32-1:0] key_in,
    output reg wrapper_out_encrypt,
    output reg wrapper_out_decrypt
);

// Parameteres passed to (Encryption Module)
wire [127:0] data_encrypted; 


Encryption  #(Nk,Nr) encrypt_me
(
.data_in(data_in_encrypt),
.key_in(key_in),
.data_encrypted(data_encrypted)
);

// Parameteres passed to (Decryption Module)
wire [127:0] data_decrypted; 


Decryption  #(Nk,Nr)decrypt_me
(
.data_in(data_encrypted),
.key_in(key_in),
.data_decrypted(data_decrypted)
);

always@*
begin
    if (Nk == 4) begin
        if(data_encrypted == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            wrapper_out_encrypt<= 1'b1;
        else
            wrapper_out_encrypt<= 1'b0;
    end
    else if (Nk == 6) begin
        if(data_encrypted == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
            wrapper_out_encrypt<= 1'b1;
        else
            wrapper_out_encrypt<= 1'b0;
    end
    else begin
        if(data_encrypted == 128'h8ea2b7ca516745bfeafc49904b496089)
            wrapper_out_encrypt<= 1'b1;
        else
            wrapper_out_encrypt<= 1'b0;
    end

    if(data_decrypted == 128'h00112233445566778899aabbccddeeff)
    wrapper_out_decrypt<= 1'b1;
    else
    wrapper_out_decrypt<=1'b0;
end

endmodule