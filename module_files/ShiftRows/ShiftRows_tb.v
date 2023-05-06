`include "ShiftRows.v"
`include "InvShiftRows.v"
module Testing();

wire [127:0] out;
reg [127:0] in;

wire [127:0] out2;
reg [127:0] in2;


initial begin
    in=128'h A5_A4_A3_A2_B5_B4_B3_B2_C5_C4_C3_C2_D5_D4_D3_D2;
    in2=128'h A5_B4_C3_D2_B5_C4_D3_A2_C5_D4_A3_B2_D5_A4_B3_C2;
end

ShiftRows S(in , out);
InvShiftRows I(in2 , out2);
always @(out || out2) begin
   $display("out=%0h   
out2=%0h",out , out2);
end

endmodule