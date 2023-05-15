`include "Encryption.v"
module SPI_Slave #(parameter Nk = 4 , parameter Nr = 10) (
    input wire clk,
    input wire rst,
    input wire SDI,
    output reg SDO,
    input wire CS
);

// input consists of 128 bits of plaintext data then 32*Nk bits of key
reg [(32*Nk)-1:0] key;
reg [127:0] data_in;

// output consists of 128 bits of encrypted data
reg [0:127] data_out;
wire [0:127] data_wire;

reg SDO_state;
reg SDO_next;
reg SDI_state;
reg SDI_next;
reg CS_state;
reg CS_next;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        data_in <= 0;
        data_out <= 0;
        key <= 0;
    end
    else begin
        SDO_state <= SDO_next;
        SDI_state <= SDI_next;
        CS_state <= CS_next;
    end
end

parameter total_time = 128 + (32*Nk) + 128;

integer i = 0;
integer j = 0;

always @(negedge clk, posedge rst) begin
    if(rst) begin
        data_in <= 0;
        data_out <= 0;
        key <= 0;
        i = 0;
        j = 0;
    end
    else begin
        CS_next<= CS;
        if(!CS_state) begin
            if(i < 128)begin
                data_in <= {data_in[127:0], SDI_state};
                SDI_next = SDI;
                i = i + 1;
            end
            else if(i < (128 + (32*Nk))) begin
                key <= {key[(32*Nk)-1:0], SDI_state};
                SDI_next = SDI;
                i = i + 1;
            end
            else begin
                data_out = data_wire;
                SDO = SDO_state;
                SDO_next = data_out[j];
                j = j + 1;
            end
        end
        else begin
            data_in <= 0;
            data_out <= 0;
            key <= 0;
            i = 0;
            j = 0;
        end
    end
end

Encryption Enc(
    .data_in(data_in),
    .key_in(key),
    .data_encrypted(data_wire)
);  
    
endmodule