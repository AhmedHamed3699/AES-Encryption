`include "master.v"
`include "SPI_Master.v"
module SPI_Testbench ();

reg [1:0] Nk_val;
reg clk_master;
reg rst;
reg [127:0] data_in;
reg [255:0]key;

wire done_out_Enc;
wire done_out_Dec;
wire [127:0] data_out;

SPI_Master SM(Nk_val , clk_master , rst , data_in , key , done_out_Enc , done_out_Dec , data_out);

always @(*) begin
    #5  clk_master <= ~clk_master;
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

initial begin
    rst=1;
    clk_master=0;
    data_in=128'h00112233445566778899aabbccddeeff;
    key=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
    Nk_val=2'b10;
#20 
  rst=0;
end
endmodule