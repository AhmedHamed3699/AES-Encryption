`include "SPI_Master.v"
module Wrapper
(
    input clk,
    input reset,
    input [1:0] Nk_val,
    output reg wrapper_out_encrypt,
    output reg wrapper_out_decrypt,
    output reg done
);

wire done_out_Enc;
wire done_out_Dec;
reg [0:127] data_in;
reg [0:255] key_in;
wire [127:0] data_out;

SPI_Master SM(Nk_val , clk , reset , data_in , key_in , done_out_Enc , done_out_Dec , data_out);

always@(*)
begin
    if (reset) begin
        wrapper_out_encrypt = 0;
        wrapper_out_decrypt = 0;
        done = 0;
        data_in = 128'h00112233445566778899aabbccddeeff;
        key_in = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    end

    if(done_out_Enc)begin

        if (Nk_val == 2'b00) begin
            if(data_out == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
                wrapper_out_encrypt<= 1'b1;
            else
                wrapper_out_encrypt<= 1'b0;
            data_in = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
        end
        else if (Nk_val == 2'b01) begin
            if(data_out == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
                wrapper_out_encrypt<= 1'b1;
            else
                wrapper_out_encrypt<= 1'b0;
            data_in = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
        end
        else if (Nk_val == 2'b10) begin
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
            wrapper_out_decrypt = 1'b1;
        else
            wrapper_out_decrypt = 1'b0;

        done = 1;
    end
end

endmodule