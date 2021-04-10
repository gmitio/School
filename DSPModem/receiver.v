module receiver(
	input clk,
	input reset,
	input sam_clk_ena,
	input sym_clk_ena,
	input signed [17:0] signal_in,
	output [1:0] syms_out_i, syms_out_q);
	

	
	// Downconvert each channel, apply matched filter, downsample, and decode
	reg [1:0] nco_phase;
	always @(posedge clk)
		if(reset)
			nco_phase <= 2'd1;
		else
			nco_phase <= nco_phase + 2'd1;
			
	reg signed [17:0] mixed_down_i, mixed_down_q;
	always @ *
		case(nco_phase)
			2'd0: mixed_down_i = 18'sd0;
			2'd1: mixed_down_i = signal_in;
			2'd2: mixed_down_i = 18'sd0;
			2'd3: mixed_down_i = -signal_in;
		endcase
		
	always @ *
		case(nco_phase)
			2'd0: mixed_down_q  = signal_in;
			2'd1: mixed_down_q = 18'sd0;
			2'd2: mixed_down_q = -signal_in;
			2'd3: mixed_down_q = 18'sd0;
		endcase
	

	wire signed [17:0] downsamp_i, downsamp_q;
	downsampler downsampler_i( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .x_in(mixed_down_i), .y(downsamp_i) );
	downsampler downsampler_q( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .x_in(mixed_down_q), .y(downsamp_q) );
	
	/** Apply matched filter to recover originally transmitted 18 bit signal **/
	wire signed [17:0] recovered_i, recovered_q;
	matched_filter_grm011 matched_filt_i( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .x_in(downsamp_i), .y(recovered_i) );
	matched_filter_grm011 matched_filt_q( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .x_in(downsamp_q), .y(recovered_q) );
	
	/** Measure the reference levels of these incoming signals to process them accordingly	**/
	/**
	input clk,
	input reset,
	input sym_clk_ena,
	input reg [17:0] recovered_i, recovered_q,
	output reg [17:0] measured_ref_i, measured_ref_q
	**/
	wire [17:0] measured_ref_i, measured_ref_q;
	wire [54:0] mapper_output_power_i, mapper_output_power_q;
	wire [35+16:0] accumulated_square_error_i, accumulated_square_error_q;
	
		/** Slice the 18 bit signal to recover originally transmitted symbols **/
	slicer slicer_i( .clk(clk), .slicer_in(recovered_i), .ref_level(measured_ref_i), .slicer_out(syms_out_i) );
	slicer slicer_q( .clk(clk), .slicer_in(recovered_q), .ref_level(measured_ref_q), .slicer_out(syms_out_q) );
	
	reference_measure ref_lev( .clk(clk), .reset(reset), .sym_clk_ena(sym_clk_ena), .recovered_i(recovered_i), .recovered_q(recovered_q), .measured_ref_i(measured_ref_i), .measured_ref_q(measured_ref_q),
								.mapper_output_power_i(mapper_output_power_i), .mapper_output_power_q(mapper_output_power_q), .syms_i(syms_out_i), .syms_q(syms_out_q), .filt_out_i(recovered_i), .filt_out_q(recovered_q),
								.accumulated_square_error_i(accumulated_square_error_i), .accumulated_square_error_q(accumulated_square_error_q));
	

	
	

/**
    input [1:0] mapper_in,
    input signed [17:0] ref_level,
    output reg [17:0] mapper_out
**/

endmodule