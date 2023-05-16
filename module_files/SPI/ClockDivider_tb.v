`include"ClockDivider.v"
module ClockDivider_tb();

parameter step=50;
reg master_clk;
reg divide_clock;

ClockDivider #(step) divider ( .master_clk(master_clk) , .divide_clk(divide_clk) );
always@*
begin
   #5 master_clk <= ~master_clk;
end

initial
begin
    master_clk<=1'b0;
end

endmodule