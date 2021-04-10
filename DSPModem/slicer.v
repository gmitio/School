// Implement the decision rule for the system based on 18 bit output

module slicer (
	input clk,
    input signed [17:0] slicer_in, ref_level,
    output reg [1:0] slicer_out
);

always @ (posedge clk)
    if (slicer_in >= ref_level)	// 3b on constellation
        slicer_out <= 2'b11;
    else if (slicer_in > 18'sd0)	// b on constellation
        slicer_out <= 2'b10;
    else if (slicer_in > -ref_level)	// -b on constellation
        slicer_out <= 2'b01;
    else
        slicer_out <= 2'b00;	// -3b on constellation

endmodule