`include "Decryption.v"
module DecryptionTestBench ();

parameter Nk=4;
parameter Nr=Nk+6;
reg [127:0] data_in;
reg [Nk*32-1:0] key_in;
wire [127:0] data_decrypted;

Decryption #(Nk ,Nr) d(data_in , key_in , data_decrypted);

initial begin

data_in=128'h69c4e0d86a7b0430d8cdb78070b4c55a;
key_in=128'h000102030405060708090a0b0c0d0e0f;

#10
if(data_decrypted==128'h00112233445566778899aabbccddeeff)
$display("successfully decrypted");
else
$display("FAILEDDDDDDD");

end
endmodule