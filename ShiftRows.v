module ShiftRows(
input [127:0] state,
output [127:0] out    
);

wire [7:0]b0;
wire [7:0]b1;
wire [7:0]b2;
wire [7:0]b3;

wire [7:0]b4;
wire [7:0]b5;
wire [7:0]b6;
wire [7:0]b7;

wire [7:0]b8;
wire [7:0]b9;
wire [7:0]b10;
wire [7:0]b11;

wire [7:0]b12;
wire [7:0]b13;
wire [7:0]b14;
wire [7:0]b15;

//copying col1
assign b0=state[127-(0*8)-:8];
assign b1=state[127-(1*8)-:8];
assign b2=state[127-(2*8)-:8];
assign b3=state[127-(3*8)-:8];

//copying col2
assign b4=state[95-(0*8)-:8];
assign b5=state[95-(1*8)-:8];
assign b6=state[95-(2*8)-:8];
assign b7=state[95-(3*8)-:8];

//copying col3
assign b8=state[63-(0*8)-:8];
assign b9=state[63-(1*8)-:8];
assign b10=state[63-(2*8)-:8];
assign b11=state[63-(3*8)-:8];

//copying col4
assign b12=state[31-(0*8)-:8];
assign b13=state[31-(1*8)-:8];
assign b14=state[31-(2*8)-:8];
assign b15=state[31-(3*8)-:8];

//setting out

//col1
assign out[127-(0*8)-:8]=b0;
assign out[127-(1*8)-:8]=b5;
assign out[127-(2*8)-:8]=b10;
assign out[127-(3*8)-:8]=b15;

//col2
assign out[95-(0*8)-:8]=b4;
assign out[95-(1*8)-:8]=b9;
assign out[95-(2*8)-:8]=b14;
assign out[95-(3*8)-:8]=b3;

//col3
assign out[63-(0*8)-:8]=b8;
assign out[63-(1*8)-:8]=b13;
assign out[63-(2*8)-:8]=b2;
assign out[63-(3*8)-:8]=b7;

//col4
assign out[31-(0*8)-:8]=b12;
assign out[31-(1*8)-:8]=b1;
assign out[31-(2*8)-:8]=b6;
assign out[31-(3*8)-:8]=b11;

endmodule