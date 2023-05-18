`include"Wrapper.v"
module Wrapper_tb();

reg clk;
reg reset;
wire wrapper_out_encrypt;
wire wrapper_out_decrypt;
Wrapper  #(Nk,Nr) wrab(clk, reset, wrapper_out_encrypt ,wrapper_out_decrypt);


always @(*) begin
    #5  clk <= ~clk;
end

initial begin

    clk = 0;
    reset = 1;

    #20
    reset = 0;
    #10000

        if(wrapper_out_encrypt == 1'b1)
        $display("Data Successfully Encrypted");
        else
        $display("Encryption Failed");
        if(wrapper_out_decrypt == 1'b1)
        $display("Data Successfully Decrypted");
        else
        $display("Decryption Failed");

    $finish; 


end

endmodule