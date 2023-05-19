`include "Encryption.v"
`include "Decryption.v"
module SPI_Slave #(parameter E_D = 1) (
    input wire [1:0]Nk_val,
    input wire clk,
    input wire rst,
    input wire SDI,
    output reg SDO,
    input wire CS
);

//states of Nk_val
parameter Nk_4=2'b00;
parameter Nk_6=2'b01;
parameter Nk_8=2'b10;

integer Nk=0;         
    

// E_D : 1 for encryption, 0 for decryption

// input consists of 128 bits of plaintext data then 32*Nk bits of key
reg [0:255] key;
reg [127:0] data_in;

// output consists of 128 bits of encrypted data
reg [0:127] data_out;
wire [0:127] data_encrypted_4;
wire [0:127] data_encrypted_6;
wire [0:127] data_encrypted_8;

wire [0:127] data_decrypted_4;
wire [0:127] data_decrypted_6;
wire [0:127] data_decrypted_8;


reg SDO_state;
reg SDI_state;

integer i = 0;
integer j = 0;

always @(posedge clk, posedge rst) begin

    if(rst) begin
        SDO_state = 0;
        SDI_state = 0; 
    end
    else begin
        SDO_state = data_out[j];
        SDI_state = SDI;    
    end

end

always @(negedge clk, posedge rst) begin
   
    if(Nk_val==Nk_4)
        Nk=4;
    else if(Nk_val==Nk_6)
        Nk=6;
    else 
        Nk=8;   

    if(rst) begin
        data_in <= 0;
        data_out <= 0;
        key <= 0;
        i = 0;
        j = 0;
    end

    else begin
        if(!CS) begin
            if(i < 130)begin
                data_in = {data_in[127:0], SDI_state};
                i = i + 1;
            end
            else if(i < (130 + 256)) begin
                key = {key[0:255], SDI_state};
                i = i + 1;
            end
            else if (i == (130 + 256)) begin
                if(E_D == 1) begin
                    if(Nk==4)
                        data_out = data_encrypted_4;
                    else if(Nk==6)
                        data_out = data_encrypted_6;
                    else
                        data_out = data_encrypted_8;

                end
                else begin
                    if(Nk==4)
                        data_out = data_decrypted_4;
                    else if(Nk==6)    
                        data_out = data_decrypted_6;
                    else    
                        data_out = data_decrypted_8;
                end
                i = i + 1;
            end
            else begin
                if (j <= 128) begin
                    SDO <= SDO_state;
                    j = j + 1;
                end
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



 //encryption for Nk=4 key
Encryption #(4, 10) Enc_4(
    .data_in(data_in),
    .key_in(key[0:127]),
    .data_encrypted(data_encrypted_4)
);

 //encryption for Nk=6 key
Encryption #(6, 12) Enc_6(
    .data_in(data_in),
    .key_in(key[0:191]),
    .data_encrypted(data_encrypted_6)
);

 //encryption for Nk=8 key
Encryption #(8, 14) Enc_8(
    .data_in(data_in),
    .key_in(key),
    .data_encrypted(data_encrypted_8)
);

 //decryption for Nk=4 key
Decryption #(4, 10) Dec_4(
    .data_in(data_in),
    .key_in(key[0:127]),
    .data_decrypted(data_decrypted_4)
);

 //decryption for Nk=6 key
Decryption #(6 , 12) Dec_6(
    .data_in(data_in),
    .key_in(key[0:191]),
    .data_decrypted(data_decrypted_6)
);

 //decryption for Nk=8 key
Decryption #(8, 14) Dec_8(
    .data_in(data_in),
    .key_in(key),
    .data_decrypted(data_decrypted_8)
);

endmodule