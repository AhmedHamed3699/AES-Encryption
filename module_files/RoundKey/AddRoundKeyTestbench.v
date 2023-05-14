`include "AddRoundKey.v"
module AddRoundKeyTestbench ();

reg [127:0] state_in;
reg [127:0] RoundKey;
wire [127:0]state_out;


initial begin
    state_in=128'h7a1e98bdacb6d1141a6944dd06eb2d3e;
    RoundKey=128'h58e151ab04a2a5557effb5416245080c;
 
 #5 if(state_out==128'h22ffc916a81474416496f19c64ae2532)
    $display("Passed!");
end

AddRoundKey A(state_in , RoundKey , state_out);

endmodule