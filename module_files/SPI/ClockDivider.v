module ClockDivider  (
    input master_clk,
    output wire divide_clk
);

integer counter=0;

always @(master_clk) begin
    if(counter==50)begin
        
    end
end

endmodule