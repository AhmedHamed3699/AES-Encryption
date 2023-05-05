`include "ShiftRows.v"
module Testing();
wire [127:0] out;
reg [127:0] in ;

initial begin
    in=128'h A5_A4_A3_A2_B5_B4_B3_B2_C5_C4_C3_C2_D5_D4_D3_D2;
end

ShiftRows S(in , out);

always @(out) begin
   $display("%0h",out);
end

endmodule