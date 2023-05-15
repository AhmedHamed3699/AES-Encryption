`include "master.v"
`include "SPI_Master.v"
module SPI_Testbench ();

parameter Nk=8;
parameter Nr=Nk+6;
reg sel_encrypt;
reg sel_decrypt;
reg clk_master;
reg rst;
reg [127:0] data_in;
reg [Nk*32-1:0]key;

wire done_out;
wire [127:0] data_out;

SPI_Master #(Nk,Nr) SM(sel_encrypt , sel_decrypt , clk_master , rst , data_in , key , done_out , data_out);

always @(*) begin
  #5  clk_master <= ~clk_master;
  if(done_out)begin
    if(data_out==128'h8ea2b7ca516745bfeafc49904b496089)
     $display("successfully encrypted");
    else
      $display("FAILEDDDDDDD");
    
    $finish;  
  end
end

initial begin
    rst=1;
    sel_encrypt=0;
    sel_decrypt=1;
    clk_master=0;
    data_in=128'h00112233445566778899aabbccddeeff;
    key=256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
#20 
  rst=0;
end
endmodule