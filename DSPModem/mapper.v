module mapper (
    input [1:0] mapper_in,
    input signed [17:0] ref_level,
    output reg [17:0] mapper_out

);

always @ *
    case (mapper_in)
		2'b00: mapper_out <= -ref_level - {ref_level[17], ref_level[17:1]}; // -ref level - half ref level
		2'b01: mapper_out <= -{ref_level[17], ref_level[17:1]};	// -half ref level
		2'b10: mapper_out <= {ref_level[17], ref_level[17:1]};	// pos half ref level
		2'b11: mapper_out <= ref_level + {ref_level[17], ref_level[17:1]};	// ref level + half ref level
    endcase

endmodule