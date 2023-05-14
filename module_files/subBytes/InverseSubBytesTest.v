`include "InverseSubBytes.v"
module InverseSubBytesTest ();

reg [127:0] sub_byte;
wire [127:0] byte;

InverseSubBytes SM(.sub_byte(sub_byte) , .byte_out(byte));

initial begin
    sub_byte=128'h 2d6d7ef03f33e334093602dd5bfb12c7;
    #10
    if(byte==128'h fab38a1725664d2840246ac957633931)
    $display("passed!");
    else
    $display("failed!");
end

endmodule