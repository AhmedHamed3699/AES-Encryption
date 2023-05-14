module moduleName #(parameter divNo=50) (
    input master_clk,
    output reg [divNO-1:0] divide_clk
);


always @(divNO) begin
    if(divNo==1'1b1)
        divide_clk<=divNO'b1;
    else
        divide_clk<=divNO'b0;    
end

endmodule