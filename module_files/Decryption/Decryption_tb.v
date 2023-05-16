`include "Decryption.v"
module Decryption_tb ();

parameter Nk=4;
parameter Nr=Nk+6;
reg [127:0] data_in;
reg [Nk*32-1:0] key_in;
wire [127:0] data_decrypted;

Decryption #(Nk ,Nr) d(data_in , key_in , data_decrypted);

initial begin

data_in=128'h69c4e0d86a7b0430d8cdb78070b4c55a;

key_in=128'h000102030405060708090a0b0c0d0e0f;  // 128'h69c4e0d86a7b0430d8cdb78070b4c55a
//key_in=192'h000102030405060708090a0b0c0d0e0f1011121314151617;  // 128'hdda97ca4864cdfe06eaf70a0ec0d7191
//key_in=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;  // 128'h8ea2b7ca516745bfeafc49904b496089

#10
if(data_decrypted==128'h00112233445566778899aabbccddeeff)
$display("Successfully Decrypted");
else
$display("FAILEDDDDDDD");

end
endmodule