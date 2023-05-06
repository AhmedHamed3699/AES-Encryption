
module MixColumns_tb ();
    
    reg [3:0] a;
    reg [7:0] b;
    wire [7:0] out;

function [7:0] mult (input [3:0] a, input [7:0] b);
    reg [10:0] temp1;
    reg [10:0] temp2;
    reg [10:0] temp3;
    reg [10:0] temp4;
    begin
        temp1[7:0]  = a[0] & b;
        temp2[8:1]  = a[1] & b;
        temp3[9:2]  = a[2] & b;
        temp4[10:3] = a[3] & b;
        mult = temp1 + temp2 + temp3 + temp4;
    end
endfunction

    initial begin
        $display("a b out");
        $monitor("%g %g %g", a, b, out);
        a <= 4'd7;
        b <= 4'd6;
        out <= mult(a,b);
    end

endmodule