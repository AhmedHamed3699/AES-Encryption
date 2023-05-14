`include "keyExpansion.v"
`include "InvMixColumns.v"
`include "AddRoundKey.v"
`include "InvShiftRows.v"
`include "InverseSubBytes.v"
module Decryption #(parameter Nk =4 , parameter Nr=10)
(
   input [127:0] data_in,
   input [Nk*32-1:0] key_in,
   output [127:0] data_decrypted
);


//KeyExpansion output
wire [128*(Nr+1)-1 : 0] k_sch;

//Inverse_subBytes I/O
wire [127:0] InvSubBytes_out[Nr:0];

//Inverse_shift_Rows I/O
wire [127:0] InvShiftRows_out[Nr:0];

//Inverse_MixColumns I/O
wire [127:0] InvMixColumns_out[Nr:0];

//AddRoundKey I/O
wire [127:0] nextRound_in[Nr:0];

//integer indicating the current round
genvar Round_no;

keyExpansion #(Nk ,Nr) K(.key(key_in) , .schedule(k_sch));

AddRoundKey A(data_in ,k_sch[127:0], InvMixColumns_out[0]);

generate

   for(Round_no=1 ; Round_no<Nr ; Round_no=Round_no+1)
   begin
      InvShiftRows Operation2(InvMixColumns_out[Round_no-1] , InvShiftRows_out[Round_no]);
      InverseSubBytes Operation1(InvShiftRows_out[Round_no], InvSubBytes_out[Round_no]);
      AddRoundKey Operation4(InvSubBytes_out[Round_no] , k_sch[Round_no*128 +:128], nextRound_in[Round_no]); 
      InvMixColumns Operation3(nextRound_in[Round_no] , InvMixColumns_out[Round_no]);
   end

      InvShiftRows Operation6(InvMixColumns_out[Nr-1] ,InvShiftRows_out[Nr]);
      InverseSubBytes Operation5(InvShiftRows_out[Nr] , InvSubBytes_out[Nr]);
      AddRoundKey Operation7(InvSubBytes_out[Nr] ,k_sch[128*(Nr+1)-1 -:128], nextRound_in[Nr]);

endgenerate


assign data_decrypted=nextRound_in[Nr];

    
endmodule