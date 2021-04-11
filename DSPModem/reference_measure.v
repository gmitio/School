

module reference_measure(
	input clk,
	input reset,
	input sym_clk_ena,
	input [17:0] recovered_i, recovered_q,
	output reg [17:0] measured_ref_i, measured_ref_q,
	/** Throw the signals in here for MER measurement because why not **/
	output reg [54:0] mapper_output_power_i, mapper_output_power_q,	// 1s17^2 * 2s16
	input [1:0] syms_i, syms_q,
	input [17:0] filt_out_i, filt_out_q,
	output reg [35+20:0] accumulated_square_error_i, accumulated_square_error_q
	
);


	parameter BITS_ACCUMULATED = 20;
	reg [BITS_ACCUMULATED-1:0] accum_count;
	always @ (posedge clk)
		if(reset)
			accum_count <= 1'b0;
		else if(sym_clk_ena)
			accum_count <= accum_count + 1'b1;
			
	reg [BITS_ACCUMULATED-1:0] last_clked_count; 
	reg clear_accumulator;
	always @(posedge clk)
		last_clked_count <= accum_count;

	always @ *
		if( (accum_count == 1'b0) && (last_clked_count != 1'b0) )
			clear_accumulator = 1'b1;
		else
			clear_accumulator = 1'b0;

	/** Reference level calculation stuff **/
	reg signed [17:0] abs_dv_out_i, abs_dv_out_q;
	always @ *
		if(recovered_i[17] == 1'b1)
			abs_dv_out_i = -recovered_i;
		else
			abs_dv_out_i = recovered_i;	// 1s17
	
	always @ *
		if(recovered_q[17] == 1'b1)
			abs_dv_out_q = -recovered_q;
		else
			abs_dv_out_q = recovered_q;	// 1s17
	

	reg [17+BITS_ACCUMULATED:0] dv_accumulator_i, dv_accumulator_q;	//1s17 + 11 integer bits = 12s17
	always @(posedge clk)
		if(reset)
			dv_accumulator_i <= 36'b0;
		else if(clear_accumulator)
			dv_accumulator_i <= 36'b0;
		else if(sym_clk_ena)
			dv_accumulator_i <= dv_accumulator_i + abs_dv_out_i;
	always @(posedge clk)
		if(reset)
			dv_accumulator_q <= 36'b0;
		else if(clear_accumulator)
			dv_accumulator_q <= 36'b0;
		else if(sym_clk_ena)
			dv_accumulator_q <= dv_accumulator_q + abs_dv_out_q;
				
	
	always @(posedge clk)
		if(reset)
			measured_ref_i <= 18'sd1460;
		else if(clear_accumulator)
			measured_ref_i <= dv_accumulator_i[17+BITS_ACCUMULATED:BITS_ACCUMULATED];
			//measured_reference_level <= dv_accumulator[28:11];	// 8M stuff
		else
			measured_ref_i <= measured_ref_i;
	always @(posedge clk)
		if(reset)
			measured_ref_q <= 18'sd1460;
		else if(clear_accumulator)
			measured_ref_q <= dv_accumulator_q[17+BITS_ACCUMULATED:BITS_ACCUMULATED];
			//measured_reference_level <= dv_accumulator[28:11];	// 8M stuff
		else
			measured_ref_q <= measured_ref_q;
			
	always @(posedge clk)
		begin
		mapper_output_power_i <= measured_ref_i * measured_ref_i * 18'sd81920;
		mapper_output_power_q <= measured_ref_q * measured_ref_q * 18'sd81920;
		end
		
		
		// Measure BER and MER
	wire signed [17:0] remapped_i, remapped_q;
	mapper remap_i( .mapper_in(syms_i), .ref_level(measured_ref_i), .mapper_out(remapped_i) );
	mapper remap_q( .mapper_in(syms_q), .ref_level(measured_ref_q), .mapper_out(remapped_q) );
	
	reg signed [17:0] error_i, error_q;
	always @ *
		begin
		error_i <= filt_out_i - remapped_i;
		error_q <= filt_out_q - remapped_q;
		end 
		
	
	reg [35+BITS_ACCUMULATED:0] accum_sq_error_i, accum_sq_error_q;
	reg [35:0] error_product_i, error_product_q;	//2s34
	always @ *
		error_product_i = error_i * error_i;
	always @ *
		error_product_q = error_q * error_q;
		
	always @ (posedge clk)
		if(reset)
			accum_sq_error_i <= 1'b0;
		else if(clear_accumulator == 1'b1)
			accum_sq_error_i <= error_product_i;
		else if(sym_clk_ena == 1'b1)
			accum_sq_error_i <= accum_sq_error_i + error_product_i;
	always @(posedge clear_accumulator)
		accumulated_square_error_i <= accum_sq_error_i;
		
	always @ (posedge clk)
		if(reset)
			accum_sq_error_q <= 1'b0;
		else if(clear_accumulator == 1'b1)
			accum_sq_error_q <= error_product_q;
		else if(sym_clk_ena == 1'b1)
			accum_sq_error_q <= accum_sq_error_q + error_product_q;
	always @(posedge clear_accumulator)
		accumulated_square_error_q <= accum_sq_error_q;
		
endmodule