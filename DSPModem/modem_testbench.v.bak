// ModelSim Testbench for the EE465 16-QAM system
// By Graison Mitio, 2021
`timescale 1us/1ns
module modem_testbench();

	reg clk, reset;
	//(*keep*) wire signed [17:0] sig_out;

	/** ModelSim Testing Stuff **/
	initial #1200000 $stop;
	initial reset = 1'b1;
	initial #10 reset = 1'b0;
		 
	// Set up the main testbench clk
	initial clk = 1'b0;
	always #0.04 clk = ~clk; // 25 MHz clock
	
	/** Add clock dividers **/
	wire sym_clk_ena, sam_clk_ena;
	clk_enable_gen clk_gen( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena) );
	
	
	/** Use short LFSRs for symbol generation and testing in ModelSim **/
	wire [1:0] syms_i, syms_q;
	wire rollover_sig_i, rollover_sig_q;	// For setting clear accumulator signal in MER test system 
	lfsr lfsr_i( .clk(clk), .reset(reset), .sym_clk_ena(sym_clk_ena), .lfsr_out(syms_i), .rollover(rollover_sig_i) );
	lfsr lfsr_q( .clk(clk), .reset(reset), .sym_clk_ena(sym_clk_ena), .lfsr_out_q(syms_q), .rollover(rollover_sig_q) );


	wire signed [17:0] transmitter_out;	// Upconverted 6.25MHz signal from transmitter
	transmitter tx_sys( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .syms_in_i(syms_i), .syms_in_q(syms_q), .transmitter_out(transmitter_out) );
	
	
	wire signed [17:0] channel_out;	// 6.25MHz signal after being routed thru the channel
	channel ch_sys( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .sig_in(transmitter_out), .sig_out(channel_out) );
	
	wire [1:0] sym_out_i, sym_out_q;
	receiver rx_sys( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .signal_in(channel_out), .syms_out_i(sym_out_i), .syms_out_q(sym_out_q) );


	// Do the BER measurement here or in the receiver? Probably just do it here
	// Also do the MER measurement
	
	
endmodule