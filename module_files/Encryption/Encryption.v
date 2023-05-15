`include "keyExpansion.v"
`include "MixColumns.v"
`include "AddRoundKey.v"
`include "ShiftRows.v"
`include "SubBytes.v"
module Encryption #(parameter Nk =4 , parameter Nr=10)(
   input [127:0] data_in,
   input [Nk*32-1:0] key_in,
   output [127:0] data_encrypted
);


//KeyExpansion output
wire [128*(Nr+1)-1 : 0] k_sch;

//subBytes I/O
wire [127:0] SubBytes_out[Nr:0];

//shiftRows I/O
wire [127:0] ShiftRows_out[Nr:0];

//MixColumns I/O
wire [127:0] MixColumns_out[Nr:0];

//AddRoundKey I/O
wire [127:0] nextRound_in[Nr:0];

//integer indicating the current round
genvar Round_no;

keyExpansion #(Nk ,Nr) K(.key(key_in) , .schedule(k_sch));

AddRoundKey A(data_in ,k_sch[128*(Nr+1)-1 -:128], nextRound_in[0]);

generate

   for(Round_no=1 ; Round_no<Nr ; Round_no=Round_no+1)begin
      SubBytes Operation1(nextRound_in[Round_no-1], SubBytes_out[Round_no]);
      ShiftRows Operation2(SubBytes_out[Round_no] , ShiftRows_out[Round_no]);
      MixColumns Operation3(ShiftRows_out[Round_no] , MixColumns_out[Round_no]);
      AddRoundKey Operation4(MixColumns_out[Round_no] , k_sch[128*((Nr+1)-Round_no)-1-:128], nextRound_in[Round_no]);
   end

      SubBytes Operation5(nextRound_in[Nr-1] , SubBytes_out[Nr]);
      ShiftRows Operation6(SubBytes_out[Nr] , ShiftRows_out[Nr]);
      AddRoundKey Operation7(ShiftRows_out[Nr] ,k_sch[127:0], nextRound_in[Nr]);

endgenerate


assign data_encrypted=nextRound_in[Nr];

    
endmodule