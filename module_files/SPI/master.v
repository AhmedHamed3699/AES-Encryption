`include "SPI_Slave.v"
`include "ClockDivider.v"
module master #(parameter Nk=4 , parameter Nr=10)(
input sel_encrypt,
input sel_decrypt,
input clk_master,
input rst,
input [127:0] data_in,
input [Nk*32-1:0]key,
output reg done_out,
output [127:0] data_out
);

//elements passed to slave
wire MISO;
reg MOSI;
reg done_slave;
wire [128+Nk*32-1:0]data_bus;
//wire of inputs locally used
reg [127:0] data_reg;


//counts the next
integer i=128+Nk*32;

//calling clock divider module
//ClockDivider C(clk_master , clk_master); 

//calling cipher slave
SPI_Slave s1( .clk(clk_master) ,.rst(rst) , .SDI(MOSI) , .SDO(MISO), .CS(sel_encrypt));

//calling inverse cipher slave
//InvCipher_slave s2( .clk(clk_master) ,.rst(rst) , .SDI(MOSI) , .SDO(MISO), .CS(sel_decrypt));

always @(negedge clk_master or posedge rst) begin
    if(rst==1'b1)begin
        data_reg<=128'h0;
        done_out<=1'b0;
        done_slave=1'b0;
        i=0;
    end
    else begin
       
        if(i>=0)begin
            MOSI<=data_bus[i];
            i=i-1;      
        end    
        else begin 
            done_slave<=1'b1; 
            i=128+Nk*32;
        end
    end
end


always @(posedge clk_master) begin
    if(done_slave && i>=0)begin
            data_reg<={data_reg[126:0] , MISO}; 
            i=i-1;   
    end
    
    else if(done_slave && i<0)
        done_out<=1'b1;
    else
        data_reg<=128'h0;    
end

assign data_out=data_reg;
assign data_bus={data_in , key};
endmodule