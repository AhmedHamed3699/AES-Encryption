module master #(parameter Nk=4 , parameter Nr=10)(
input sel_encrypt,
input sel-decrypt,
input clk,
input rst,
input [127:0] data_in,
input [Nk*32-1:0]key,

output[127:0] data_out
);

reg MISO;
reg MOSI;

always @(posedge clk || posedge rst) begin
    if(rst==1'b1)begin
        
    end

end

endmodule