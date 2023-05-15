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
reg MOSI_reg;
reg MOSI_next;
reg done_sending;
wire [128+Nk*32-1:0]data_bus;
//wire of inputs locally used
reg [127:0] data_reg;
reg [127:0] data_next;


//counts the next
integer i=128+Nk*32;

//calling clock divider module
//ClockDivider C(clk_master , clk_master); 

//calling cipher slave
SPI_Slave s1( .clk(clk_master) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO), .CS(sel_encrypt));

//calling inverse cipher slave
//InvCipher_slave s2( .clk(clk_master) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO), .CS(sel_decrypt));

always @(negedge clk_master or posedge rst) begin
    
    //reset case
    if(rst==1'b1)begin
        data_reg<=128'h0;
        done_out<=1'b0;
        done_sending=1'b0;
        i=0;
        MOSI_reg<=1'bx;
    end

    
    else begin   

        //updating sending reg
        MOSI_reg<=MOSI_next;

        //in recieving mode-updating next
        if(done_sending==1'b1 && i>=0) begin

            data_next<={data_reg[126:0] , MISO};
            i=i-1;
        end
        
        //finished recieving
        else if(done_sending==1'b1 && i<0)
            done_out<=1'b1;

        //not in recieving mode
        else begin
            data_next<=128'b0;
        end
    end

end


always @(posedge clk_master) begin
    
    //in sending mode-updating next
    if(done_sending==1'b0 && i>=0)begin
        MOSI_next<=data_bus[i];
        i=i-1;
    end

    //finished sending
    else if(done_sending==1'b0 && i<0)begin
        MOSI_next<=1'bx;
        done_sending<=1'b1;
        i=128+Nk*32;
    end

    //in receiving mode-updating reg
    else
        data_reg<= data_next;
       
end

assign data_out=data_reg;
assign data_bus={data_in , key};
endmodule