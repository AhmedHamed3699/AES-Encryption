integer Rb;
function  [7:0][Rb-1:0][3:0] InvshiftRows(integer Rb , Byte state[Rb:0][15:0]);
parameter  Byte [7:0];
integer i;
for(i=1 ; i<Rb ; i=i+1) begin
InvshiftRows[i]={[i-1:0] , [Rb-1:i]};
end
endfunction