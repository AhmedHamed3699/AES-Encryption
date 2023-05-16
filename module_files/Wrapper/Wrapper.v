`include"Encryption.v"
`include"Decryption.v"
`include "SPI_Master.v"
module Wrapper #(parameter Nk =4 , parameter Nr=10)
(
    input clk,
    input reset,
    input [127:0] data_in_encrypt,
    input [Nk*32-1:0] key_in,
    output reg wrapper_out_encrypt,
    output reg wrapper_out_decrypt
);

SPI_Master #(Nk,Nr) SM(clk , reset , data_in_encrypt , key_in , done_out_Enc , done_out_Dec , data_out);


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

always @(*) begin
  if(done_out_Enc)begin
      if(data_out == 128'h8ea2b7ca516745bfeafc49904b496089)
        $display("successfully encrypted");
      else
        $display("failed encryption");

      data_in = 128'h8ea2b7ca516745bfeafc49904b496089;
  end
  if (done_out_Dec) begin

      if(data_out == 128'h00112233445566778899aabbccddeeff)
        $display("successfully decrypted");
      else
        $display("failed decryption");
      $finish;  
  end
  end

endmodule