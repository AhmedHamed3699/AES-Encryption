`include "master.v"
`include "SPI_Master.v"
module SPI_Testbench ();

parameter Nk=4;
parameter Nr=10;
reg sel_encrypt;
reg sel_decrypt;
reg clk_master;
reg rst;
reg [127:0] data_in;
reg [Nk*32-1:0]key;

wire done_out;
wire [127:0] data_out;

//master m(sel_encrypt , sel_decrypt , clk_master , rst , data_in , key , done_out , data_out);
SPI_Master SM(sel_encrypt , sel_decrypt , clk_master , rst , data_in , key , done_out , data_out);

always @(*) begin
  #5  clk_master <= ~clk_master;
  if(done_out)begin
    if(data_out==128'h69c4e0d86a7b0430d8cdb78070b4c55a)
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
    key=128'h000102030405060708090a0b0c0d0e0f;
#20 
  rst=0;
end
endmodule