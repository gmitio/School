module upsampler (
    input clk,
    input reset,
    input sam_clk_ena,
    input sym_clk_ena,
    input [17:0] x_in,
    output reg signed [17:0] y
);


integer i;
parameter N = 20; 
parameter N_BY_4 = N / 4;
wire signed [17:0] b[N-1:0];


// Coefficient definitions
assign b[0] = 18'sd599;
assign b[1] = 18'sd764;
assign b[2] = -18'sd30;
assign b[3] = -18'sd2078;
assign b[4] = -18'sd4101;
assign b[5] = -18'sd3432;
assign b[6] = 18'sd2323;
assign b[7] = 18'sd13046;
assign b[8] = 18'sd25177;
assign b[9] = 18'sd33269;
assign b[10] = 18'sd33269;
assign b[11] = 18'sd25177;
assign b[12] = 18'sd13046;
assign b[13] = 18'sd2323;
assign b[14] = -18'sd3432;
assign b[15] = -18'sd4101;
assign b[16] = -18'sd2078;
assign b[17] = -18'sd30;
assign b[18] = 18'sd764;
assign b[19] = 18'sd599;


reg signed [17:0] x[N_BY_4-1:0];
always @ (posedge clk)
    if (reset)
        for (i = 0; i < N_BY_4; i = i + 1)
            x[i] <= 2'b0;
    else if (sam_clk_ena) begin
        x[0] <= x_in;
        for (i = 1; i < N_BY_4; i = i + 1)
            x[i] <= x[i-1];
    end


// Counter for multiplier sharing
reg [1:0] sam_clk_counter;
always @ (posedge clk)
    if (reset)
        sam_clk_counter <= 2'b11;
    else
        sam_clk_counter <= sam_clk_counter + 1'b1;


// Mux for delaying inputs into multipliers
reg signed [17:0] b_into_mult[N_BY_4-1:0];
always @ *
    for (i = 0; i < N_BY_4; i=i+1)
        case (sam_clk_counter)
            2'd0: b_into_mult[i] <= b[i * 4 + 0];
            2'd1: b_into_mult[i] <= b[i * 4 + 1];
            2'd2: b_into_mult[i] <= b[i * 4 + 2];
            2'd3: b_into_mult[i] <= b[i * 4 + 3];
        endcase

// Perform the appropriate multiplication
reg signed [35:0] mult_out[N_BY_4-1:0];
always @ *
    for (i = 0; i < N_BY_4; i=i+1)
        mult_out[i] <= b_into_mult[i] * x[i];

// Create the adder structure
reg signed [35:0] sum_level_0[2:0];
always @ (posedge clk) begin
    for (i = 0; i < 2; i = i + 1)
        if (reset)
            sum_level_0[i] <= 36'b0;
        else
            sum_level_0[i] <= mult_out[i] + mult_out[i+2];
    if (reset)
        sum_level_0[2] <= 36'b0;
    else
        sum_level_0[2] <= mult_out[4];
end

reg signed [35:0] sum_level_1[1:0];
always @ (posedge clk) begin
    for (i = 0; i < 1; i = i + 1)
        if (reset)
            sum_level_1[i] <= 36'b0;
        else
            sum_level_1[i] <= sum_level_0[i] + sum_level_0[i+1];
    if (reset)
        sum_level_1[1] <= 36'b0;
    else
        sum_level_1[1] <= sum_level_0[2];
end

reg signed [35:0] sum_level_2;
always @ (posedge clk) begin
    for (i = 0; i < 1; i = i + 1)
        if (reset)
            sum_level_2 <= 36'b0;
        else
            sum_level_2 <= sum_level_1[0] + sum_level_1[1];
end

// Truncate the upsampler output
always @ *
    y <= sum_level_2[34:17];

endmodule
