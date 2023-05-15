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
wire [128+Nk*32-1:0]data_bus;

reg MOSI_reg;
reg MOSI_next;
reg done_sending;
reg sel_encrypt_slave;
reg sel_decrypt_slave;

//wire of inputs locally used
reg [127:0] data_reg;
reg [127:0] data_next;


//counts the next
integer i=128+Nk*32-1;

//calling clock divider module
//ClockDivider C(clk_master , clk_master); 

//calling cipher slave
SPI_Slave s1( .clk(clk_master) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO), .CS(sel_encrypt_slave));

//calling inverse cipher slave
//InvCipher_slave s2( .clk(clk_master) ,.rst(rst) , .SDI(MOSI_reg) , .SDO(MISO), .CS(sel_decrypt));

always @(negedge clk_master or posedge rst) begin
    
    //reset case
    if(rst==1'b1)begin
        MOSI_reg<=1'b0;
        MOSI_next<=1'b0;
        done_sending=1'b0;
        sel_encrypt_slave=sel_encrypt;
        sel_decrypt_slave=sel_decrypt;
        data_reg<=128'h0;
        data_next<=128'h0;
        done_out<=1'b0;
        i=128+Nk*32-1;
    end

    
    else begin   

        //in sending mode
        if(i==128+Nk*32-1) 
            sel_encrypt_slave=sel_encrypt;
        
         if(done_sending==1'b0 && i>=0)begin
            
            MOSI_next<=data_bus[i];
            i=i-1;

            if(i<0)begin
                MOSI_next<=1'bx;
                done_sending<=1'b1;
                i=128-1;
            end           
        end

        //in recieving mode
        else if(done_sending==1'b1 && i>=-1) begin
            
            data_next<={data_next[126:0] , MISO};
            i=i-1;
          
            if(i<0)begin
                done_out<=1'b1;
                sel_encrypt_slave<=1'b1;
                sel_decrypt_slave<=1'b1;
            end
        end
        
        
        else begin
            data_next<=128'h0;
            MOSI_next<=128'h0;
        end     

    end

end


always @(posedge clk_master) begin  
   
    if(rst==1'b0)begin
        data_reg<= data_next;
        MOSI_reg<=MOSI_next;
    end
    
end

assign data_out=data_reg;
assign data_bus={data_in , key};
endmodule
