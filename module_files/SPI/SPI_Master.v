`include "SPI_Slave.v"
`include "ClockDivider.v"
module SPI_Master #(parameter Nk=4 , parameter Nr=10)(
input clk,
input rst,
input [0:127] data_in,
input [0:Nk*32-1]key,
output reg done_out_Enc,
output reg done_out_Dec,
output [127:0] data_out
);

//elements passed to slave
wire MISO_Enc;
wire MISO_Dec;
reg MOSI_reg;
reg MOSI_next;
reg CS_enc;
reg CS_dec;
reg [127:0]data_out_reg;


//counts the next
integer i = 0;
integer ik = 0;
integer j = 0;

//calling clock divider module
//ClockDivider C(clk_master , clk_master); 

//calling cipher slave
SPI_Slave #(Nk,Nr,1) Enc_s( .clk(clk) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO_Enc), .CS(CS_enc));

//calling inverse cipher slave
SPI_Slave #(Nk,Nr,0) Dec_s( .clk(clk) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO_Dec), .CS(CS_dec));

always @(posedge clk) begin
    MOSI_reg <= MOSI_next;
end

always @(negedge clk, posedge rst) begin

    
    //reset case
    if(rst)begin
        data_out_reg = 0;
        done_out_Enc = 0;
        done_out_Dec = 0;
        MOSI_next = 0;
        CS_enc = 0;
        CS_dec = 1;
        i = 0;
        ik = 0;
        j = 0;
    end
    else begin  
        done_out_Enc = 0;
        done_out_Dec = 0;
        if(i < 128)begin
            MOSI_next = data_in[i];
            i = i + 1;
        end
        else if (ik < Nk*32) begin
            MOSI_next = key[ik];
            ik = ik + 1;   
        end
        else begin
            if (j < 4) begin
                MOSI_next = 0;
                j = j + 1;
            end
            else if(j < 132) begin
                if(!CS_enc) begin
                    data_out_reg = {data_out_reg[127:0], MISO_Enc};
                end
                else if(!CS_dec) begin
                    data_out_reg = {data_out_reg[127:0], MISO_Dec};
                end
                else begin
                    data_out_reg = data_out_reg;
                end
                j = j + 1;
            end
            else if(!CS_enc) begin
                CS_enc <= 1;
                CS_dec <= 0;
                done_out_Enc = 1; 
                i = 0;
                ik = 0;
                j = 0;
            end
            else begin
                done_out_Dec = 1;
                MOSI_next = 0;
                CS_enc = 0;
                CS_dec = 1;
                i = 0;
                ik = 0;
                j = 0;
            end
        end
    end
end

assign data_out = data_out_reg;      

endmodule