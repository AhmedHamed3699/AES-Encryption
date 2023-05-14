`include "PRBS.v"
module wrapper(
input  clk,
input enable,
input reset,
input load,
input [95:0] inp,
output checkout 
); 

reg reg_checkout;
wire [95:0] out;

PRBS P(inp , enable , clk , reset , load , out);

always@(posedge clk)
begin
if(out==96'h 55_8A_C4_A5_3A_17_24_E1_63_AC_2B_F9)
reg_checkout<=1'b1;
else
reg_checkout<=1'b0;
end

assign checkout=reg_checkout;

endmodule
