module SPI_Slave #(parameter Nk = 4 , parameter Nr = 10) (
    input wire clk,
    input wire rst,
    input wire SDI,
    output wire SDO,
    input wire CS
);

// input consists of 128 bits of plaintext data then 32*Nk bits of key
reg [(32*Nk)-1:0] key;
reg [127:0] data_in;

// output consists of 128 bits of encrypted data
reg [127:0] data_out;

always @(posedge clk, posedge rst) begin
    if(rst) begin
        data_in <= 0;
        data_out <= 0;
    end
    else begin
        if(!CS) begin
            data_in <= {data_in[127:0], SDI};
        end
        else begin
            data_in <= 0;
        end
    end
end
    
endmodule