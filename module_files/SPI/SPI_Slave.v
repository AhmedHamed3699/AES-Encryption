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
reg SDI_state;
reg CS_state;
reg CS_next;

integer i = 0;
integer j = 0;

always @(posedge clk, posedge rst) begin

    if(!CS_next) begin
        SDO_state <= data_out[j];
        SDI_state <= SDI;
        CS_state <= CS_next;
    end

end

always @(negedge clk, posedge rst) begin
    if(rst) begin
        data_in <= 0;
        data_out <= 0;
        key <= 0;
        SDO_state <= 0;
        CS_next <= 1;
        i = 0;
        j = 0;
    end
    else begin
        CS_next = CS;
        if(!CS_state) begin
            if(i < 128)begin
                data_in <= {data_in[127:0], SDI_state};
                i = i + 1;
            end
            else if(i < (128 + (32*Nk))) begin
                key <= {key[(32*Nk)-1:0], SDI_state};
                i = i + 1;
            end
            else begin
                data_out = data_wire;
                SDO = SDO_state;
                j = j + 1;
            end
        end
        else begin
            data_in <= 0;
            data_out = data_wire;
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