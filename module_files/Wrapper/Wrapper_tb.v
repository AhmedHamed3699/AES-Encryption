`include"Wrapper.v"
module Wrapper_tb();

reg clk;
reg reset;
reg [1:0] Nk_val;
wire wrapper_out_encrypt;
wire wrapper_out_decrypt;
wire done;

Wrapper wrab(clk, reset, Nk_val, wrapper_out_encrypt ,wrapper_out_decrypt, done);

always @(*) begin
    #5  clk <= ~clk;
end

always @(*) begin
    if(done)begin

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
end

initial begin
    
    reset = 1;
    clk = 0;
    Nk_val = 2'b00;


    #20
    reset = 0;

end

endmodule