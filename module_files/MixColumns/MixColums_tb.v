`include "MixColumns.v"
module MixColums_tb ();
    
    reg [127:0] Data_in;
    wire [127:0] Data_out;

    MixColumns m(.state(Data_in), .result_state(Data_out));

    initial begin
        $display("Data_in\t\tData_out");
        $monitor("%h %h", Data_in, Data_out);

        Data_in= 128'h_d4bf5d30_e0b452ae_b84111f1_1e2798e5 ;
        #10;
        Data_in=128'h_84e1dd69_1a41d76f_792d3897_83fbac70 ;
        #10;
        Data_in=128'h_6353e08c_0960e104_cd70b751_bacad0e7;
        #10;
    end

endmodule