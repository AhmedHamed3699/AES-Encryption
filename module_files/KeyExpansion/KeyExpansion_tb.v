`include "KeyExpansion.v"

module keyExpansion_tb();

parameter Nk=8;
parameter Nr=14;
reg [0:(32*Nk) - 1] key;
wire[(128*(Nr+1)) - 1:0] exp;

keyExpansion #(Nk, Nr) ks(key,exp);

initial begin

    //key=128'h_2b7e1516_28aed2a6_abf71588_09cf4f3c;
    //key=192'h_8e73b0f7_da0e6452_c810f32b_809079e5_62f8ead2_522c6b7b;
    key=256'h_603deb10_15ca71be_2b73aef0_857d7781_1f352c07_3b6108d7_2d9810a3_0914dff4;
    $monitor("key= %h \nexp= %h",key,exp);


end
endmodule
