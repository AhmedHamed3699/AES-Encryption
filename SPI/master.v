`include "slave.v"
`include "ClockDivider.v"
module master #(parameter Nk=4 , parameter Nr=10)(
input sel_encrypt,
input sel-decrypt,
input clk_master,
input rst,
input [127:0] data_in_wire,
input [Nk*32-1:0]key,
input done_in;

output done_out;
output reg [127:0] data_out
);

//elements passed to slave
reg MISO;
reg MOSI;
reg done_slave;
wire clk_divided;

//wire of inputs locally used
wire [127:0] data_in_wire;
reg [127:0] data_reg;


//counts the next
integer i=127;

//calling clock divider module
ClockDivider C(clk_master , clk_divided); 

//calling cipher slave
Cipher_slave s1( .clk(clk_divided) ,.rst(rst) , .SDI(MOSI) , .SDO(MISO), .CS(sel_encrypt));

//calling inverse cipher slave
InvCipher_slave s2( .clk(clk_divided) ,.rst(rst) , .SDI(MOSI) , .SDO(MISO), .CS(sel_decrypt));

always @(negedge clk_divided || posedge rst) begin
    if(rst==1'b1)begin
        data_in_wire<=128'h0;
        MOSI<=1'b0;
        MISO<=1'b0;
        data_reg<=128'h0;
    end
    else begin
       
        if(i>=0)begin
            MOSI<=data_in_wire[i];
            i=i-1;      
            
        end    
        else begin 
            done_slave<=1'b1; 
            i=127;
        end
    end
end


always @(posedge clk_divided) begin
    if(done_slave && i>=0)begin
            data_reg<={data_reg[126:0] , MISO}; 
            i=i-1;   
    end
end

assign data_in_wire=data_in;
assign data_out=data_reg;

endmodule