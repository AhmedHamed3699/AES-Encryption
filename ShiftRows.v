module ShiftRows(
input [127:0] state,
output [127:0] out    
);

//2d arrays of rows=4 , cols=4
wire [7:0]stateMatrix[3:0][3:0];
wire [7:0]outMatrix[3:0][3:0];

genvar i,j;

//changing state into matrix
for(i=3; i>=0 ; i=i-1)begin
    for(j=3; j>=0 ; j=j-1)begin
        assign stateMatrix[3-j][3-i]=state[8*j+32*i+7 : 8*j+32*i];
    end
end

/*
//shift left function function
function [31:0]shiftLeft;
    input [31:0]in;
    shiftLeft={in[23:0] ,in[31:24]};
endfunction
*/

//shifting rows by calling function
for(i=0 ; i<4 ; i=i+1) begin
    for(j=i ; j>=0 ; j=j-1)begin
        assign outMatrix[i][3:0]={stateMatrix[i][0][7:0] , stateMatrix[i][3][7:0]  ,stateMatrix[i][2][7:0]  , stateMatrix[i][1][7:0] };
    end
end

//retruning matrix into array
for(i=3 ; i>=0 ; i=i-1)begin
    for(j=3; j>=0 ; j=j-1)begin
   assign out[8*j+32*i+7 : 8*j+32*i]=outMatrix[3-j][3-i];
    end    
end

endmodule