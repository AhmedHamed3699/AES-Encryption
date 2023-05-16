`include"Encryption.v"
`include"Decryption.v"
`include "SPI_Master.v"
module Wrapper #(parameter Nk =4 , parameter Nr=10)
(
    input clk,
    input reset,
    input [127:0] data_in,
    input [Nk*32-1:0] key_in,
    output reg wrapper_out_encrypt,
    output reg wrapper_out_decrypt
);

wire done_out_Enc;
wire done_out_Dec;
reg done_reg;
wire [127:0] data_out;
reg [127:0] data;

SPI_Master #(Nk,Nr) SM(clk , reset , data , key_in , done_out_Enc , done_out_Dec , data_out);

always @(data_in) begin
    data <= data_in;
end

always@*
begin
  if(done_out_Enc)begin
  if (Nk == 4) begin
      if(data_out == 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
          wrapper_out_encrypt<= 1'b1;
      else
          wrapper_out_encrypt<= 1'b0;
      data = 128'h69c4e0d86a7b0430d8cdb78070b4c55a;
  end
  else if (Nk == 6) begin
      if(data_out == 128'hdda97ca4864cdfe06eaf70a0ec0d7191)
          wrapper_out_encrypt<= 1'b1;
      else
          wrapper_out_encrypt<= 1'b0;
      data = 128'hdda97ca4864cdfe06eaf70a0ec0d7191;
  end
  else begin
      if(data_out == 128'h8ea2b7ca516745bfeafc49904b496089)
          wrapper_out_encrypt<= 1'b1;
      else
          wrapper_out_encrypt<= 1'b0;
      data = 128'h8ea2b7ca516745bfeafc49904b496089;
  end

  end
    if (done_out_Dec) begin
      if(data_out == 128'h00112233445566778899aabbccddeeff)
          wrapper_out_decrypt<= 1'b1;
      else
          wrapper_out_decrypt<=1'b0;
    end
end

assign done = done_reg;

endmodule