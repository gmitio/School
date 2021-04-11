module channel(
	input clk,
	input reset,
	input sam_clk_ena,
	input sym_clk_ena,
	input awgn_en,
	input [1:0] gain_set,
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
	
	reg signed [17:0] gain;	//9s9 number?
	
	always @ *
		case(gain_set)
			2'b00:	gain = 18'd512;
			2'b01:	gain = 18'd1024;
			2'b10:	gain = 18'd2048;
			2'b11:	gain = 18'd4096;
			default: gain = 18'd512;
		endcase
	//assign gain = 18'sd512 * 8;
	reg signed [35:0] channel_app_gain;
	always @ *
		if(awgn_en)
			begin
			channel_app_gain = sig_in * gain;
			sig_out = noise + channel_app_gain[26:9];
			end
		else
			begin
			channel_app_gain = sig_in * gain;
			sig_out = channel_app_gain[26:9];
			end

//	always @ *
//		begin
//		channel_app_gain = sig_in * gain;
//		sig_out = noise + sig_in;
//		end
endmodule