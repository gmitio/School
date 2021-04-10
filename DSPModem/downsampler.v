/** ALEX'S DOWNSAMPLER -- WRITE YOUR OWN **/
module downsampler (
    input clk,
    input reset,
    input sam_clk_ena,
    input sym_clk_ena,
    input [17:0] x_in,
    output reg signed [17:0] y
);
// Downsamples an input from sys_clk to sam_clk and applies a low pass filter

integer i;
parameter N = 20; // Must be multiple of four
parameter N_BY_4 = N / 4;
wire signed [17:0] b[N-1:0];


// B Definition
assign b[0] = 18'sd55;
assign b[1] = 18'sd558;
assign b[2] = 18'sd722;
assign b[3] = -18'sd460;
assign b[4] = -18'sd3107;
assign b[5] = -18'sd4665;
assign b[6] = -18'sd842;
assign b[7] = 18'sd10507;
assign b[8] = 18'sd25826;
assign b[9] = 18'sd36942;
assign b[10] = 18'sd36942;
assign b[11] = 18'sd25826;
assign b[12] = 18'sd10507;
assign b[13] = -18'sd842;
assign b[14] = -18'sd4665;
assign b[15] = -18'sd3107;
assign b[16] = -18'sd460;
assign b[17] = 18'sd722;
assign b[18] = 18'sd558;
assign b[19] = 18'sd55;


// X Definition (Updates at sys_clk)
reg signed [17:0] x[N-1:0];
always @ (posedge clk)
    if (reset)
        for (i = 0; i < N; i = i + 1)
            x[i] <= 2'b0;
    else begin
        x[0] <= x_in;
        for (i = 1; i < N; i = i + 1)
            x[i] <= x[i-1];
    end


// Staggered sam_clk_ena definition
// This counts from 0 to 3, and indicates which of each four adjacent taps should output a signal for a given sample
reg [1:0] sam_clk_counter;
always @ (posedge clk)
    if (reset)
        sam_clk_counter <= 2'd3;
    else
        sam_clk_counter <= sam_clk_counter + 2'd3;


// Multiplier Multiplexed B input definition
reg signed [17:0] b_into_mult[N_BY_4-1:0];
always @ *
    for (i = 0; i < N_BY_4; i=i+1)
        case (sam_clk_counter)
            2'd0: b_into_mult[i] <= b[i * 4 + 0];
            2'd1: b_into_mult[i] <= b[i * 4 + 1];
            2'd2: b_into_mult[i] <= b[i * 4 + 2];
            2'd3: b_into_mult[i] <= b[i * 4 + 3];
        endcase

// Multiplier definition
reg signed [35:0] mult_out[N_BY_4-1:0];
always @ *
    for (i = 0; i < N_BY_4; i=i+1)
        mult_out[i] <= b_into_mult[i] * x[i * 4];

reg signed [35:0] mult_out_shifted[N-1:0];
always @ (posedge clk)
    if (reset)
        for (i = 0; i < N; i=i+1)
            mult_out_shifted[i] <= 1'b0;
    else
        for (i = 0; i < N_BY_4; i=i+1) begin
            mult_out_shifted[i*4 + 0] <= mult_out[i];
            mult_out_shifted[i*4 + 1] <= mult_out_shifted[i*4 + 0];
            mult_out_shifted[i*4 + 2] <= mult_out_shifted[i*4 + 1];
            mult_out_shifted[i*4 + 3] <= mult_out_shifted[i*4 + 2];
        end

// Adder Definitions

reg signed [35:0] sum_level_0[9:0];
always @ (posedge clk) begin
    for (i = 0; i < 10; i = i + 1)
        if (reset)
            sum_level_0[i] <= 36'b0;
        else if (sam_clk_ena)
            sum_level_0[i] <= mult_out_shifted[i] + mult_out_shifted[i+10];
end

reg signed [35:0] sum_level_1[4:0];
always @ (posedge clk) begin
    for (i = 0; i < 5; i = i + 1)
        if (reset)
            sum_level_1[i] <= 36'b0;
        else if (sam_clk_ena)
            sum_level_1[i] <= sum_level_0[i] + sum_level_0[i+5];
end

reg signed [35:0] sum_level_2[2:0];
always @ (posedge clk) begin
    for (i = 0; i < 2; i = i + 1)
        if (reset)
            sum_level_2[i] <= 36'b0;
        else if (sam_clk_ena)
            sum_level_2[i] <= sum_level_1[i] + sum_level_1[i+2];
    if (reset)
        sum_level_2[2] <= 36'b0;
    else if (sam_clk_ena)
        sum_level_2[2] <= sum_level_1[4];
end

reg signed [35:0] sum_level_3[1:0];
always @ (posedge clk) begin
    for (i = 0; i < 1; i = i + 1)
        if (reset)
            sum_level_3[i] <= 36'b0;
        else if (sam_clk_ena)
            sum_level_3[i] <= sum_level_2[i] + sum_level_2[i+1];
    if (reset)
        sum_level_3[1] <= 36'b0;
    else if (sam_clk_ena)
        sum_level_3[1] <= sum_level_2[2];
end

reg signed [35:0] sum_level_4[0:0];
always @ (posedge clk) begin
    for (i = 0; i < 1; i = i + 1)
        if (reset)
            sum_level_4[i] <= 36'b0;
        else if (sam_clk_ena)
            sum_level_4[i] <= sum_level_3[i] + sum_level_3[i+1];
end


always @ *
    // Slice one bit off the top here to make output 1s17
    y <= sum_level_4[0][34:17];

endmodule
