module ClockDivider #(parameter step=20) 
(
    input master_clk,
    output reg divide_clk
);

integer counter=0;
wire en;
assign en = 0;
always @(posedge master_clk) begin
    if(counter == 0 && !en)
    divide_clk = 0;

    if(counter == step)
    begin
        divide_clk<= ~divide_clk;
        counter=0;
    end
    counter=counter+1;
end

endmodule