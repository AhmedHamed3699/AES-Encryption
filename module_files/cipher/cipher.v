`include "KeyExpansion.v"
`include "MixColumns.v"
`include "AddRoundKey.v"
`include "ShiftRows.v"
`include "SubBytes.v"
module cipher #(parameter Nk =4 , parameter Nr=10)(
   input [127:0] data_in,
   input [Nk*32-1:0] key_in,
   output [127:0] data_encrypted
);

//KeyExpansion output
reg [128*(Nr+1)-1 : 0] k_sch;

//subBytes I/O
reg [127:0] SubBytes_in;
wire [127:0] SubBytes_out;

//shiftRows I/O
reg [127:0] ShiftRows_in;
wire [127:0] ShiftRows_out;

//MixColumns I/O
reg [127:0] MixColumns_in;
wire [127:0] MixColumns_out;

//AddRoundKey I/O
reg [127:0] RoundKey_in;
wire [127:0] RoundKey_out;

//integer indicating the current round
genvar Round_no;

//wires needed each round
//reg [127:0] state;

generate
   Round_no=0;
   KeyExpansion #(.Nk(NK) , .Nr(Nr)) K(.key(key_in) , .schedule(k_sch));
   AddRoundKey A(data_in ,RoundKey_in, RoundKey_out);

   for(Round_no=0 ; Round_no<Nr-1 ; Round_no=Round_no+1)begin
      SubBytes Operation1(RoundKey_out , SubBytes_out);
      ShiftRows Operation2(SubBytes_out , ShiftRows_out);
      MixColumns Operation3(ShiftRows_out , MixColumns_out);
      AddRoundKey Operation4(MixColumns_out ,RoundKey_in, RoundKey_out);
   end

      SubBytes Operation1(RoundKey_out , SubBytes_out);
      ShiftRows Operation2(SubBytes_out , ShiftRows_out);
      AddRoundKey Operation4(ShiftRows_out ,RoundKey_in, RoundKey_out);

endgenerate


assign RoundKey_in= k_sch[128*(Round_no+1)-1:128*Round_no];
assign data_encrypted=RoundKey_out;

    
endmodule