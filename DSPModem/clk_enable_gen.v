module clk_enable_gen (
    input clk,
(* noprune *)    input reset,
(* noprune *)     output reg sam_clk_ena, sym_clk_ena
);

reg [4:0] counter;

always @ (posedge clk)
    if(reset)
        counter <= 4'b0000;
    else
        counter <= counter + 1'b1;

always @ * begin
    sam_clk_ena <= !counter[1] & !counter[0];
    sym_clk_ena <= !counter[3] & !counter[2] & !counter[1] & !counter[0];
end

endmodule
