module lfsr (
    input clk,
    input reset,
    input sym_clk_ena,
    output reg [1:0] lfsr_out, lfsr_out_q,
    output wire rollover
);
// Two two bit outputs, updated every symbol clock
// Internal state updates on system clock

reg lfsr_feedback;
reg [21:0] lfsr_reg;

assign rollover = lfsr_reg == 22'H3FFFFF;

always @ *
    lfsr_feedback <= lfsr_reg[1] ^ lfsr_reg[0];

always @ (posedge clk)
    if (reset)
        lfsr_reg <= 22'H3FFFFF;
    else
        lfsr_reg <= {lfsr_feedback, lfsr_reg[21:1]};

reg [6:0] test_counter;
always @ (posedge sym_clk_ena)
    if (reset)
        test_counter <= 1'b0;
    else
        test_counter <= test_counter + 1'b1;


always @ (posedge clk)
    if (reset) begin
        lfsr_out <= 2'b11;
		lfsr_out_q <= 2'b11;
    end
    else if (sym_clk_ena)	// Stimulus input
		begin
        lfsr_out <= lfsr_reg[1:0];
		lfsr_out_q <= lfsr_reg[3:2];
		end
endmodule
