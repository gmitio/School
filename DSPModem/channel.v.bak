module channel(
	input clk,
	input reset,
	input sam_clk_ena,
	input sym_clk_ena,
	input signed [17:0] sig_in,
	output reg signed [17:0] sig_out
	);	//TODO:  Add appropriate signals for the channel 
	
	wire noise_en;
	assign noise_en = 1'b0;
	
	reg del_reset;
	always @(posedge clk)
		del_reset <= reset;
		
	wire signed [17:0] noise;
	
	// TODO: Add this module
	awgn_generator noise_gen( .clk(clk), .clk_en(noise_en), .reset_n(~del_reset), .awgn_out(noise) );
	
	wire signed [17:0] gain;	//9s9 number?
	
	assign gain = 18'sd512 * 8;
	
	reg signed [35:0] channel_app_gain;
	always @ *
		begin
		channel_app_gain = sig_in * gain;
		sig_out = noise + channel_app_gain[26:9];
		end
endmodule