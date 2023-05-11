
`include "InvMixColumns.v"
module InvMixColumns_tb ();
    
    reg [127:0] Data_in;
    wire [127:0] Data_out;

    InvMixColumns m(.state(Data_in), .result_state(Data_out));

    initial begin
        $display("Data_in\t\tData_out");
        $monitor("%h %h", Data_in, Data_out);
        Data_in = 128'h_046681e5_e0cb199a_48f8d37a_2806264c;
        #20
        if(Data_out == 128'h_d4bf5d30_e0b452ae_b84111f1_1e2798e5)
            $display("Passed");
        else
            $display("Failed");
        #10;
    end

endmodule