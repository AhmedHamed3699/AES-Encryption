`include"Encryption.v"
`include"Decryption.v"
`include "SPI_Master.v"
module Wrapper #(parameter Nk =4 , parameter Nr=10)
(
    input clk,
    input reset,
    output reg wrapper_out_encrypt,
    output reg wrapper_out_decrypt,
    output reg done
);

wire done_out_Enc;
wire done_out_Dec;
reg [127:0] data_in;
reg [Nk*32-1:0] key_in;
wire [127:0] data_out;

SPI_Master #(Nk,Nr) SM(clk , reset , data_in , key_in , done_out_Enc , done_out_Dec , data_out);

always@*
begin
    if (reset) begin
        wrapper_out_encrypt = 0;
        wrapper_out_decrypt = 0;
        done = 0;
        data_in = 128'h00112233445566778899aabbccddeeff;
        key_in = 128'h000102030405060708090a0b0c0d0e0f;
    end
    if(done_out_Enc)begin
    if (Nk == 4) begin
        if(data_out == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            wrapper_out_encrypt<= 1'b1;
        else
            wrapper_out_encrypt<= 1'b0;
        data_in = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
    end
    else if (Nk == 6) begin
        if(data_out == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
            wrapper_out_encrypt<= 1'b1;
        else
            wrapper_out_encrypt<= 1'b0;
        data_in = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
    end
    else if(Nk == 8) begin
        if(data_out == 128'h8ea2b7ca516745bfeafc49904b496089)
            wrapper_out_encrypt<= 1'b1;
        else
            wrapper_out_encrypt<= 1'b0;
        data_in = 128'h8ea2b7ca516745bfeafc49904b496089;
    end
    else begin
        wrapper_out_encrypt = 0;
        wrapper_out_decrypt = 0;
        done = 0;
    end

    end
    if (done_out_Dec) begin
        if(data_out == 128'h00112233445566778899aabbccddeeff)
            wrapper_out_decrypt<= 1'b1;
        else
            wrapper_out_decrypt<=1'b0;

        done <= 1;
    end
end

endmodule