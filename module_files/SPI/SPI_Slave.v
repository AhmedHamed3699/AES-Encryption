`include "Encryption.v"
`include "Decryption.v"
module SPI_Slave #(parameter Nk = 4 , parameter Nr = 10 , parameter E_D = 1) (
    input wire clk,
    input wire rst,
    input wire SDI,
    output reg SDO,
    input wire CS
);

// E_D : 1 for encryption, 0 for decryption

// input consists of 128 bits of plaintext data then 32*Nk bits of key
reg [(32*Nk)-1:0] key;
reg [127:0] data_in;

// output consists of 128 bits of encrypted data
reg [0:127] data_out;
wire [0:127] data_encrypted;
wire [0:127] data_decrypted;

reg SDO_state;
reg SDI_state;

integer i = 0;
integer j = 0;

always @(posedge clk, posedge rst) begin

    if(!CS) begin
        SDO_state = data_out[j];
        SDI_state = SDI; 
    end

end

always @(negedge clk, posedge rst) begin
    if(rst) begin
        data_in <= 0;
        data_out <= 0;
        key <= 0;
        SDO_state <= 0;
        SDI_state <= 0;
        i = 0;
        j = 0;
    end
    else begin
        if(!CS) begin
            if(i < 130)begin
                data_in = {data_in[127:0], SDI_state};
                i = i + 1;
            end
            else if(i < (130 + (32*Nk))) begin
                key = {key[(32*Nk)-1:0], SDI_state};
                i = i + 1;
            end
            else if (i == (130 + (32*Nk))) begin
                if(E_D == 1) begin
                    data_out = data_encrypted;
                end
                else begin
                    data_out = data_decrypted;
                end
                i = i + 1;
            end
            else begin
                if (j <= 128) begin
                    SDO = SDO_state;
                    j = j + 1;
                end
            end

        end
        else begin
            data_in <= 0;
            data_out <= 0;
            key <= 0;
            SDO_state <= 0;
            SDI_state <= 0;
            i = 0;
            j = 0;
        end
    end
end

Encryption #(Nk, Nr) Enc(
    .data_in(data_in),
    .key_in(key),
    .data_encrypted(data_encrypted)
);

Decryption #(Nk, Nr) Dec(
    .data_in(data_in),
    .key_in(key),
    .data_decrypted(data_decrypted)
);
    
endmodule