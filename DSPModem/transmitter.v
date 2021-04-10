module transmitter(
	input clk,
	input reset,
	input sam_clk_ena,
	input sym_clk_ena,
	input [1:0] syms_in_i, syms_in_q,
	output reg signed [17:0] transmitter_out);
	
	wire signed [17:0] baseband_i, baseband_q;
	// Route input through pulse-shaping filter
	ps_filter_practical tx_filt_i( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .delay(2'b00), .x_in(syms_in_i), .y(baseband_i) );
	ps_filter_practical tx_filt_q( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .delay(2'b00), .x_in(syms_in_q), .y(baseband_q) );
	
	// Upsample for I/Q channels; add em together and send it
	// TODO
	wire signed [17:0] upsampled_i, upsampled_q;
	upsampler upsamp_i( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .x_in(baseband_i), .y(upsampled_i) );
	upsampler upsamp_q( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .x_in(baseband_q), .y(upsampled_q) );
	
	reg [1:0] nco_phase;
	always @(posedge clk)
		if(reset)
			nco_phase <= 2'd0;
		else
			nco_phase <= nco_phase + 2'd1;
	
	always @ *
		case(nco_phase)
			2'd0: transmitter_out = upsampled_q;
			2'd1: transmitter_out = upsampled_i;
			2'd2: transmitter_out = -upsampled_q;
			2'd3: transmitter_out = -upsampled_i;
		endcase
endmodule