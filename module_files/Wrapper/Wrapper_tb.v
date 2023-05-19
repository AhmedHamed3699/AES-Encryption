`include"Wrapper.v"
module Wrapper_tb();


parameter Nk=4;
parameter Nr=Nk+6;
reg clk;
reg reset;
wire wrapper_out_encrypt;
wire wrapper_out_decrypt;
wire done;
Wrapper  #(Nk,Nr) wrab(clk, reset, wrapper_out_encrypt, wrapper_out_decrypt, done);


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
    
    clk = 0;
    reset=1;

    #20
    reset = 0; 


end

endmodule