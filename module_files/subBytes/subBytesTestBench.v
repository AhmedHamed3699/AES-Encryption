`include "SubBytes.v"
module subBytesTestBench ();
    
reg [127:0] byte;
wire [127:0] sub_byte;

SubBytes s(byte , sub_byte);

always@(sub_byte)begin
if(sub_byte==128'h 06_49_0a_3a_d5_8d_6d_37_a6_1c_2e_25_03_48_66_b5)
    $display("passed!");
end

initial begin
    byte=128'h A5_A4_A3_A2_B5_B4_B3_B2_C5_C4_C3_C2_D5_D4_D3_D2;
end

endmodule