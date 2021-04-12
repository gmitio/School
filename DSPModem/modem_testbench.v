// ModelSim Testbench for the EE465 16-QAM system
// By Graison Mitio, 2021
`timescale 1us/1ns
module modem_testbench(
	input CLOCK_50,
	input [17:0] PHYS_SW,
	input [3:0] PHYS_KEY,
	output reg [3:0] LEDG,
	output reg [17:0] LEDR,
	
	input [13:0] ADC_DA,
	input [13:0] ADC_DB,
	output reg [13:0] DAC_DA,
	output reg [13:0] DAC_DB,
	output ADC_CLK_A,
	output ADC_CLK_B,
	output ADC_OEB_A,
	output ADC_OEB_B,
	output DAC_CLK_A,
	output DAC_CLK_B,
	output DAC_MODE,
	output DAC_WRT_A,
	output DAC_WRT_B,
	
	output wire [1:0] sym_out_i, sym_out_q,
	output wire [1:0] syms_i, syms_q,
	output signed [17:0] transmitter_out	// Upconverted 6.25MHz signal from transmitter
);
/** TODO: GET CHANNEL & BER WORKING, SET UP TEST POINT TAPS **/

	//************************
	//				  Set up DACs
					
					assign DAC_CLK_A = clk;
					assign DAC_CLK_B = clk;
					
					
					assign DAC_MODE = 1'b1; //treat DACs seperately
					
					assign DAC_WRT_A = ~clk;
					assign DAC_WRT_B = ~clk;
						
		reg signed [17:0] DAC_B_sig;			
						
		always@ (posedge clk) 
						DAC_DB = {~DAC_B_sig[17],
						DAC_B_sig[16:4]} ;	
//  End DAC setup

	reg clk, reset;
	always @ (posedge CLOCK_50)
		clk <= ~clk;
	always @ *
		reset = issp_key[0];
	//(*keep*) wire signed [17:0] sig_out;

//	/** ModelSim Testing Stuff **/
//	initial #1200000 $stop;
//	initial reset = 1'b1;
//	initial #10 reset = 1'b0;
//		 
//	// Set up the main testbench clk
//	initial clk = 1'b0;
//	always #0.04 clk = ~clk; // 25 MHz clock
	
	/** Add clock dividers **/
	wire sym_clk_ena, sam_clk_ena;
	clk_enable_gen clk_gen( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena) );
	
	
	/** Use short LFSRs for symbol generation and testing in ModelSim **/
	
	wire rollover_sig_i, rollover_sig_q;	// For setting clear accumulator signal in MER test system 
	lfsr lfsr_i( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .lfsr_out(syms_i), .rollover(rollover_sig_i) );
	lfsr lfsr_q( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .lfsr_out_q(syms_q), .rollover(rollover_sig_q) );


	
	transmitter tx_sys( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .syms_in_i(syms_i), .syms_in_q(syms_q), .transmitter_out(transmitter_out), .del_i(SW[1:0]), .del_q(SW[1:0]) );
	
	/** Send testpoint 2 to the DAC **/
	//assign DAC_out = transmitter_out[17:4];
	always @(posedge clk)
		case(SW[17:16])
			2'b00: DAC_B_sig <= 18'd0;
			2'b01: DAC_B_sig <= transmitter_out;
			2'b10: DAC_B_sig <= channel_out;
			2'b11: DAC_B_sig <= tp3;
		endcase

	wire signed [17:0] channel_out;	// 6.25MHz signal after being routed thru the channel
	channel ch_sys( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .sig_in(transmitter_out), .sig_out(channel_out), .awgn_en(SW[4]));//, .gain_set(SW[1:0]) );
	
	wire signed [17:0] tp3;
	receiver rx_sys( .clk(clk), .reset(reset), .sam_clk_ena(sam_clk_ena), .sym_clk_ena(sym_clk_ena), .signal_in(transmitter_out), .syms_out_i(sym_out_i), .syms_out_q(sym_out_q), .ds_del(SW[3:2]), .testpoint_3(tp3));


	// Do the BER measurement here or in the receiver? Probably just do it here
	// Also do the MER measurement
	
	
	
	// ------------------------------------------------------------------------------
// In-System Sources and Probes (ISSP) Code
//
// - instantiate ISSP cores; two cores are used:
// -- one to emulate switches and LEDs on the DE2 board (active high)
// -- one to emulate push-button keys on the DE2 board (active low)
// 
// - connect relevant signals to and from the core
//
// - note 1: push-button key outputs from ISSP will be passed through
//   a hold circuit to better simulate what happens when a button is pushed
// - note 2: core outputs will be used by the circuit only if 
//   the 'ISSP enable' bit is active (set to 1)
// -------------------------------------------------------------------------------                   

// direct connections to ISSP core
wire [49:0] issp_sw_sources;
wire [49:0] issp_probes;

// demultiplexed outputs from ISSP cores
wire [17:0] issp_sw;
wire  [3:0] issp_key;
wire        issp_en;

// outputs to remainder of circuit
reg [17:0] SW;
reg  [3:0] KEY;


// Instantiate ISSP core #1 (switch and LED emulator)
switch_led_emulator switch_led_emulator_inst (
  .source (issp_sw_sources[49:0]), // outputs from core
  .probe  (issp_probes[49:0])   // inputs to core
);

// de-multiplex output bus from ISSP
//
assign issp_en = issp_sw_sources[49];
// bits 48:22 are currently unused for this lab
assign issp_sw[17:0] = issp_sw_sources[17:0];

// combine inputs to ISSP
assign issp_probes[17:0] = LEDR[17:0];
assign issp_probes[21:18] = LEDG[3:0];
assign issp_probes[49:22] = 'b0; // set unused inputs to 0


// Instantiate ISSP core #2 (push-button key emulator)
// 4 output ports, no input ports
// (core configured to set outputs to 1 by default)

key_emulator key_emulator_inst (
  .source (issp_key[3:0])
);

// -------------------------------------------------------------
// Instantiate pulse generator circuit for each key here
// -------------------------------------------------------------

wire [3:0] issp_key_pulse;

KeyCCT	#(.PERSIST(1)) k0	(.clk(clk), .key(issp_key[0]), .key_out(issp_key_pulse[0]));
KeyCCT	#(.PERSIST(1)) k1	(.clk(clk), .key(issp_key[1]), .key_out(issp_key_pulse[1]));
KeyCCT	#(.PERSIST(1)) k2	(.clk(clk), .key(issp_key[2]), .key_out(issp_key_pulse[2]));
KeyCCT	#(.PERSIST(1)) k3	(.clk(clk), .key(issp_key[3]), .key_out(issp_key_pulse[3]));


// Only use ISSP outputs if the enable bit is set (otherwise use on-board components).
// This allows students to use the physical switches and keys if they have a board.
always @ (*)
    if(issp_en == 1'b1)
      begin
        SW[17:0] <= issp_sw[17:0];
        KEY[3:0] <= issp_key_pulse[3:0];
      end
    else
      begin
        SW[17:0] <= PHYS_SW[17:0];
        KEY[3:0] <= PHYS_KEY[3:0];
      end

endmodule