`include "SPI_Slave.v"
`include "ClockDivider.v"
module SPI_Master #(parameter Nk=4 , parameter Nr=10)(
input sel_encrypt,
input sel_decrypt,
input clk,
input rst,
input [127:0] data_in,
input [Nk*32-1:0]key,
output reg done_out,
output [127:0] data_out
);

//elements passed to slave
wire MISO;
reg MOSI_reg;
reg MOSI_next;
reg CS_enc_reg;
reg CS_enc_next;
reg CS_dec_reg;
reg CS_dec_next;
reg [127:0]data_out_reg;
wire [0:(128+Nk*32)-1]data_bus;


//counts the next
integer i = 0;
integer j = 0;

//calling clock divider module
//ClockDivider C(clk_master , clk_master); 

//calling cipher slave
SPI_Slave Enc_s( .clk(clk) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO), .CS(CS_enc_reg));

//calling inverse cipher slave
//SPI_Slave Dec_s( .clk(clk) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO), .CS(CS_dec_reg));

always @(posedge clk, posedge rst) begin
    
     //reset case
    if(rst)begin
        data_out_reg <= 0;
        done_out <= 0;
        MOSI_reg <= 0;
        CS_enc_next <= 1;
        CS_dec_next <= 1;
    end
    else begin
        MOSI_reg <= MOSI_next;
        CS_enc_reg <= CS_enc_next;
        CS_dec_reg <= CS_dec_next;
    end
       
end

always @(negedge clk, posedge rst) begin
    
    //reset case
    if(rst)begin
        data_out_reg <= 0;
        done_out <= 0;
        MOSI_reg <= 0;
        CS_enc_next <= 1;
        CS_dec_next <= 1;
        i = 0;
        j = 0;
    end
    else begin  

        CS_enc_next = sel_encrypt;
        CS_dec_next = sel_decrypt;
        if(i < (128+Nk*32))begin
            MOSI_next = data_bus[i];
            i = i + 1;
        end
        else begin
            if (j < 3) begin
                MOSI_next = 0;
                j = j + 1;
            end
            else if(j < 131) begin
                data_out_reg = {data_out_reg[127:0], MISO};
                j = j + 1;
            end
            else begin
                done_out <= 1;
                CS_enc_next = 1;
                CS_dec_next = 1;
            end
        end
    end
end

assign data_bus = {data_in , key};
assign data_out = data_out_reg;

endmodule