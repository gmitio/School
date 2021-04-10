module lfsr_short (
    input clk,
    input reset,
    input sym_clk_ena,
    output reg [1:0] lfsr_out,
    output reg rollover
);
// Two two bit outputs, updated every symbol clock
// Internal state updates on system clock

reg lfsr_feedback;
reg [14:0] lfsr_reg;

//assign rollover = lfsr_reg == 15'H7FFF;
reg [12:0] rollover_count;
always @(posedge clk)
	if(reset)
		rollover_count <= 13'd0;
	else if(sym_clk_ena == 1'b1)
		rollover_count <= rollover_count + 13'd1;
	else if(rollover_count == 13'd2048)
		begin
		rollover <= 1'b1;
		rollover_count <= 13'd0;
		end
	else
		begin
			rollover <= 1'b0;
			rollover_count <= rollover_count;
		end

always @ *
    lfsr_feedback <= lfsr_reg[0] ^ lfsr_reg[14];

always @ (posedge clk)
    if (reset)
        lfsr_reg <= 15'H7FFF;
    else
        lfsr_reg <= {lfsr_feedback, lfsr_reg[14:1]};

reg [6:0] test_counter;
always @ (posedge sym_clk_ena)
    if (reset)
        test_counter <= 1'b0;
    else
        test_counter <= test_counter + 1'b1;


always @ (posedge clk)
    if (reset) begin
        lfsr_out <= 2'b11;
    end
    else if (sym_clk_ena)	// Stimulus input
        lfsr_out <= lfsr_reg[1:0];
endmodule
