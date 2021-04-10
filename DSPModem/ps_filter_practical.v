module ps_filter_practical (
            input clk, reset, reg_clr, sam_clk_ena, sym_clk_ena,
            input [1:0] delay,
            input signed [1:0] x_in,
            output reg signed [17:0] y);
 
integer i;

reg signed [2:0] x[126:0];
reg signed [17:0] mult_out[126:0];

reg signed [1:0] sym_clk_del[14:0];
always @(posedge clk)
	begin
	sym_clk_del[0] <= sym_clk_ena;
	for(i=1; i<15; i=i+1)
		sym_clk_del[i] <= sym_clk_del[i-1];
	end
	
//	begin
//	sym_clk_del[0] <= sym_clk_ena;
//	sym_clk_del[1] <= sym_clk_del[0];
//	sym_clk_del[2] <= sym_clk_del[1];
//	sym_clk_del[3] <= sym_clk_del[2];
//	sym_clk_del[4] <= sym_clk_del[3];
//	sym_clk_del[5] <= sym_clk_del[4];
//	sym_clk_del[6] <= sym_clk_del[5];
//	sym_clk_del[7] <= sym_clk_del[6];
//	sym_clk_del[8] <= sym_clk_del[7];
//	sym_clk_del[9] <= sym_clk_del[8];
//	sym_clk_del[10] <= sym_clk_del[9];
//	sym_clk_del[11] <= sym_clk_del[10];
//	sym_clk_del[12] <= sym_clk_del[11];
//	sym_clk_del[13] <= sym_clk_del[12];
//	sym_clk_del[14] <= sym_clk_del[13];
//	end
	
always @ (posedge clk)
	if (delay == 2'b00 && sam_clk_ena == 1'b1 && sym_clk_ena == 1'b1)
		x[0] <= {reset, x_in};
	else if (delay == 2'b01 && sam_clk_ena == 1'b1 && sym_clk_del[3] == 1'b1)
		x[0] <= {reset, x_in};
	else if (delay == 2'b10 && sam_clk_ena == 1'b1 && sym_clk_del[7] == 1'b1)
		x[0] <= {reset, x_in};
	else if (delay == 2'b11 && sam_clk_ena == 1'b1 && sym_clk_del[11] == 1'b1)
		x[0] <= {reset, x_in};
	else
		if (sam_clk_ena == 1'b1)
			x[0] <= 3'b100;
	
// reg signed [1:0] x_in1, x_in2, x_in3, x_in4, x_in5, x_in6, x_in7, x_in8, x_in9, x_in10, x_in11, x_in12, x_in13, x_in14, x_in15;
// 	always @ (posedge clk)
//// if (sam_clk_ena == 1'b1
//    begin
//    x_in1 <= sym_clk_ena; //x_in;
//    x_in2 <= x_in1;
//    x_in3 <= x_in2;
//    x_in4 <= x_in3;
//    x_in5 <= x_in4;
//    x_in6 <= x_in5;
//    x_in7 <= x_in6;
//    x_in8 <= x_in7;
//    x_in9 <= x_in8;
//    x_in10 <= x_in9;
//    x_in11 <= x_in10;
//    x_in12 <= x_in11;
//    x_in13 <= x_in12;
//    x_in14 <= x_in13;
//    x_in15 <= x_in14;
//    end
//always @ (posedge clk)
//	if (delay == 2'b00 && sam_clk_ena == 1'b1 && sym_clk_ena == 1'b1)
//		x[0] <= {reset, x_in};
//	else if (delay == 2'b01 && sam_clk_ena == 1'b1 && x_in4 == 1'b1)
//		x[0] <= {reset, x_in};
//	else if (delay == 2'b10 && sam_clk_ena == 1'b1 && x_in8 == 1'b1)
//		x[0] <= {reset, x_in};
//	else if (delay == 2'b11 && sam_clk_ena == 1'b1 && x_in12 == 1'b1)
//		x[0] <= {reset, x_in};
//	else
//		if (sam_clk_ena == 1'b1)
//			x[0] <= 3'b100;
// 
// Update the input registers every clock cycle
always @ (posedge clk)
    if (reset == 1'b1)
        begin
        for (i=1; i<127; i=i+1)
            x[i] <= 3'b100;
        end
    else if (sam_clk_ena == 1'b1)
        begin
        for (i=1; i<127; i=i+1)
            x[i] <= {reset, x[i-1]};
        end
 
 
always @ *
     case(x[0])
     3'b000: mult_out[0] = -18'sd40;
     3'b001: mult_out[0] = -18'sd13;
     3'b010: mult_out[0] = 18'sd13;
     3'b011: mult_out[0] = 18'sd40;
     default: mult_out[0] = 18'sd0;
endcase
always @ *
     case(x[1])
     3'b000: mult_out[1] = -18'sd53;
     3'b001: mult_out[1] = -18'sd18;
     3'b010: mult_out[1] = 18'sd18;
     3'b011: mult_out[1] = 18'sd53;
     default: mult_out[1] = 18'sd0;
endcase
always @ *
     case(x[2])
     3'b000: mult_out[2] = -18'sd28;
     3'b001: mult_out[2] = -18'sd9;
     3'b010: mult_out[2] = 18'sd9;
     3'b011: mult_out[2] = 18'sd28;
     default: mult_out[2] = 18'sd0;
endcase
always @ *
     case(x[3])
     3'b000: mult_out[3] = 18'sd19;
     3'b001: mult_out[3] = 18'sd6;
     3'b010: mult_out[3] = -18'sd6;
     3'b011: mult_out[3] = -18'sd19;
     default: mult_out[3] = 18'sd0;
endcase
always @ *
     case(x[4])
     3'b000: mult_out[4] = 18'sd56;
     3'b001: mult_out[4] = 18'sd19;
     3'b010: mult_out[4] = -18'sd19;
     3'b011: mult_out[4] = -18'sd56;
     default: mult_out[4] = 18'sd0;
endcase
always @ *
     case(x[5])
     3'b000: mult_out[5] = 18'sd54;
     3'b001: mult_out[5] = 18'sd18;
     3'b010: mult_out[5] = -18'sd18;
     3'b011: mult_out[5] = -18'sd54;
     default: mult_out[5] = 18'sd0;
endcase
always @ *
     case(x[6])
     3'b000: mult_out[6] = 18'sd10;
     3'b001: mult_out[6] = 18'sd3;
     3'b010: mult_out[6] = -18'sd3;
     3'b011: mult_out[6] = -18'sd10;
     default: mult_out[6] = 18'sd0;
endcase
always @ *
     case(x[7])
     3'b000: mult_out[7] = -18'sd46;
     3'b001: mult_out[7] = -18'sd15;
     3'b010: mult_out[7] = 18'sd15;
     3'b011: mult_out[7] = 18'sd46;
     default: mult_out[7] = 18'sd0;
endcase
always @ *
     case(x[8])
     3'b000: mult_out[8] = -18'sd72;
     3'b001: mult_out[8] = -18'sd24;
     3'b010: mult_out[8] = 18'sd24;
     3'b011: mult_out[8] = 18'sd72;
     default: mult_out[8] = 18'sd0;
endcase
always @ *
     case(x[9])
     3'b000: mult_out[9] = -18'sd45;
     3'b001: mult_out[9] = -18'sd15;
     3'b010: mult_out[9] = 18'sd15;
     3'b011: mult_out[9] = 18'sd45;
     default: mult_out[9] = 18'sd0;
endcase
always @ *
     case(x[10])
     3'b000: mult_out[10] = 18'sd22;
     3'b001: mult_out[10] = 18'sd7;
     3'b010: mult_out[10] = -18'sd7;
     3'b011: mult_out[10] = -18'sd22;
     default: mult_out[10] = 18'sd0;
endcase
always @ *
     case(x[11])
     3'b000: mult_out[11] = 18'sd82;
     3'b001: mult_out[11] = 18'sd27;
     3'b010: mult_out[11] = -18'sd27;
     3'b011: mult_out[11] = -18'sd82;
     default: mult_out[11] = 18'sd0;
endcase
always @ *
     case(x[12])
     3'b000: mult_out[12] = 18'sd86;
     3'b001: mult_out[12] = 18'sd29;
     3'b010: mult_out[12] = -18'sd29;
     3'b011: mult_out[12] = -18'sd86;
     default: mult_out[12] = 18'sd0;
endcase
always @ *
     case(x[13])
     3'b000: mult_out[13] = 18'sd22;
     3'b001: mult_out[13] = 18'sd7;
     3'b010: mult_out[13] = -18'sd7;
     3'b011: mult_out[13] = -18'sd22;
     default: mult_out[13] = 18'sd0;
endcase
always @ *
     case(x[14])
     3'b000: mult_out[14] = -18'sd72;
     3'b001: mult_out[14] = -18'sd24;
     3'b010: mult_out[14] = 18'sd24;
     3'b011: mult_out[14] = 18'sd72;
     default: mult_out[14] = 18'sd0;
endcase
always @ *
     case(x[15])
     3'b000: mult_out[15] = -18'sd127;
     3'b001: mult_out[15] = -18'sd42;
     3'b010: mult_out[15] = 18'sd42;
     3'b011: mult_out[15] = 18'sd127;
     default: mult_out[15] = 18'sd0;
endcase
always @ *
     case(x[16])
     3'b000: mult_out[16] = -18'sd93;
     3'b001: mult_out[16] = -18'sd31;
     3'b010: mult_out[16] = 18'sd31;
     3'b011: mult_out[16] = 18'sd93;
     default: mult_out[16] = 18'sd0;
endcase
always @ *
     case(x[17])
     3'b000: mult_out[17] = 18'sd21;
     3'b001: mult_out[17] = 18'sd7;
     3'b010: mult_out[17] = -18'sd7;
     3'b011: mult_out[17] = -18'sd21;
     default: mult_out[17] = 18'sd0;
endcase
always @ *
     case(x[18])
     3'b000: mult_out[18] = 18'sd143;
     3'b001: mult_out[18] = 18'sd48;
     3'b010: mult_out[18] = -18'sd48;
     3'b011: mult_out[18] = -18'sd143;
     default: mult_out[18] = 18'sd0;
endcase
always @ *
     case(x[19])
     3'b000: mult_out[19] = 18'sd182;
     3'b001: mult_out[19] = 18'sd61;
     3'b010: mult_out[19] = -18'sd61;
     3'b011: mult_out[19] = -18'sd182;
     default: mult_out[19] = 18'sd0;
endcase
always @ *
     case(x[20])
     3'b000: mult_out[20] = 18'sd90;
     3'b001: mult_out[20] = 18'sd30;
     3'b010: mult_out[20] = -18'sd30;
     3'b011: mult_out[20] = -18'sd90;
     default: mult_out[20] = 18'sd0;
endcase
always @ *
     case(x[21])
     3'b000: mult_out[21] = -18'sd89;
     3'b001: mult_out[21] = -18'sd30;
     3'b010: mult_out[21] = 18'sd30;
     3'b011: mult_out[21] = 18'sd89;
     default: mult_out[21] = 18'sd0;
endcase
always @ *
     case(x[22])
     3'b000: mult_out[22] = -18'sd239;
     3'b001: mult_out[22] = -18'sd80;
     3'b010: mult_out[22] = 18'sd80;
     3'b011: mult_out[22] = 18'sd239;
     default: mult_out[22] = 18'sd0;
endcase
always @ *
     case(x[23])
     3'b000: mult_out[23] = -18'sd244;
     3'b001: mult_out[23] = -18'sd81;
     3'b010: mult_out[23] = 18'sd81;
     3'b011: mult_out[23] = 18'sd244;
     default: mult_out[23] = 18'sd0;
endcase
always @ *
     case(x[24])
     3'b000: mult_out[24] = -18'sd70;
     3'b001: mult_out[24] = -18'sd23;
     3'b010: mult_out[24] = 18'sd23;
     3'b011: mult_out[24] = 18'sd70;
     default: mult_out[24] = 18'sd0;
endcase
always @ *
     case(x[25])
     3'b000: mult_out[25] = 18'sd190;
     3'b001: mult_out[25] = 18'sd63;
     3'b010: mult_out[25] = -18'sd63;
     3'b011: mult_out[25] = -18'sd190;
     default: mult_out[25] = 18'sd0;
endcase
always @ *
     case(x[26])
     3'b000: mult_out[26] = 18'sd366;
     3'b001: mult_out[26] = 18'sd122;
     3'b010: mult_out[26] = -18'sd122;
     3'b011: mult_out[26] = -18'sd366;
     default: mult_out[26] = 18'sd0;
endcase
always @ *
     case(x[27])
     3'b000: mult_out[27] = 18'sd313;
     3'b001: mult_out[27] = 18'sd104;
     3'b010: mult_out[27] = -18'sd104;
     3'b011: mult_out[27] = -18'sd313;
     default: mult_out[27] = 18'sd0;
endcase
always @ *
     case(x[28])
     3'b000: mult_out[28] = 18'sd27;
     3'b001: mult_out[28] = 18'sd9;
     3'b010: mult_out[28] = -18'sd9;
     3'b011: mult_out[28] = -18'sd27;
     default: mult_out[28] = 18'sd0;
endcase
always @ *
     case(x[29])
     3'b000: mult_out[29] = -18'sd333;
     3'b001: mult_out[29] = -18'sd111;
     3'b010: mult_out[29] = 18'sd111;
     3'b011: mult_out[29] = 18'sd333;
     default: mult_out[29] = 18'sd0;
endcase
always @ *
     case(x[30])
     3'b000: mult_out[30] = -18'sd527;
     3'b001: mult_out[30] = -18'sd176;
     3'b010: mult_out[30] = 18'sd176;
     3'b011: mult_out[30] = 18'sd527;
     default: mult_out[30] = 18'sd0;
endcase
always @ *
     case(x[31])
     3'b000: mult_out[31] = -18'sd387;
     3'b001: mult_out[31] = -18'sd129;
     3'b010: mult_out[31] = 18'sd129;
     3'b011: mult_out[31] = 18'sd387;
     default: mult_out[31] = 18'sd0;
endcase
always @ *
     case(x[32])
     3'b000: mult_out[32] = 18'sd49;
     3'b001: mult_out[32] = 18'sd16;
     3'b010: mult_out[32] = -18'sd16;
     3'b011: mult_out[32] = -18'sd49;
     default: mult_out[32] = 18'sd0;
endcase
always @ *
     case(x[33])
     3'b000: mult_out[33] = 18'sd530;
     3'b001: mult_out[33] = 18'sd177;
     3'b010: mult_out[33] = -18'sd177;
     3'b011: mult_out[33] = -18'sd530;
     default: mult_out[33] = 18'sd0;
endcase
always @ *
     case(x[34])
     3'b000: mult_out[34] = 18'sd730;
     3'b001: mult_out[34] = 18'sd243;
     3'b010: mult_out[34] = -18'sd243;
     3'b011: mult_out[34] = -18'sd730;
     default: mult_out[34] = 18'sd0;
endcase
always @ *
     case(x[35])
     3'b000: mult_out[35] = 18'sd463;
     3'b001: mult_out[35] = 18'sd154;
     3'b010: mult_out[35] = -18'sd154;
     3'b011: mult_out[35] = -18'sd463;
     default: mult_out[35] = 18'sd0;
endcase
always @ *
     case(x[36])
     3'b000: mult_out[36] = -18'sd170;
     3'b001: mult_out[36] = -18'sd57;
     3'b010: mult_out[36] = 18'sd57;
     3'b011: mult_out[36] = 18'sd170;
     default: mult_out[36] = 18'sd0;
endcase
always @ *
     case(x[37])
     3'b000: mult_out[37] = -18'sd797;
     3'b001: mult_out[37] = -18'sd266;
     3'b010: mult_out[37] = 18'sd266;
     3'b011: mult_out[37] = 18'sd797;
     default: mult_out[37] = 18'sd0;
endcase
always @ *
     case(x[38])
     3'b000: mult_out[38] = -18'sd988;
     3'b001: mult_out[38] = -18'sd329;
     3'b010: mult_out[38] = 18'sd329;
     3'b011: mult_out[38] = 18'sd988;
     default: mult_out[38] = 18'sd0;
endcase
always @ *
     case(x[39])
     3'b000: mult_out[39] = -18'sd537;
     3'b001: mult_out[39] = -18'sd179;
     3'b010: mult_out[39] = 18'sd179;
     3'b011: mult_out[39] = 18'sd537;
     default: mult_out[39] = 18'sd0;
endcase
always @ *
     case(x[40])
     3'b000: mult_out[40] = 18'sd356;
     3'b001: mult_out[40] = 18'sd119;
     3'b010: mult_out[40] = -18'sd119;
     3'b011: mult_out[40] = -18'sd356;
     default: mult_out[40] = 18'sd0;
endcase
always @ *
     case(x[41])
     3'b000: mult_out[41] = 18'sd1162;
     3'b001: mult_out[41] = 18'sd387;
     3'b010: mult_out[41] = -18'sd387;
     3'b011: mult_out[41] = -18'sd1162;
     default: mult_out[41] = 18'sd0;
endcase
always @ *
     case(x[42])
     3'b000: mult_out[42] = 18'sd1318;
     3'b001: mult_out[42] = 18'sd439;
     3'b010: mult_out[42] = -18'sd439;
     3'b011: mult_out[42] = -18'sd1318;
     default: mult_out[42] = 18'sd0;
endcase
always @ *
     case(x[43])
     3'b000: mult_out[43] = 18'sd608;
     3'b001: mult_out[43] = 18'sd203;
     3'b010: mult_out[43] = -18'sd203;
     3'b011: mult_out[43] = -18'sd608;
     default: mult_out[43] = 18'sd0;
endcase
always @ *
     case(x[44])
     3'b000: mult_out[44] = -18'sd639;
     3'b001: mult_out[44] = -18'sd213;
     3'b010: mult_out[44] = 18'sd213;
     3'b011: mult_out[44] = 18'sd639;
     default: mult_out[44] = 18'sd0;
endcase
always @ *
     case(x[45])
     3'b000: mult_out[45] = -18'sd1675;
     3'b001: mult_out[45] = -18'sd558;
     3'b010: mult_out[45] = 18'sd558;
     3'b011: mult_out[45] = 18'sd1675;
     default: mult_out[45] = 18'sd0;
endcase
always @ *
     case(x[46])
     3'b000: mult_out[46] = -18'sd1762;
     3'b001: mult_out[46] = -18'sd587;
     3'b010: mult_out[46] = 18'sd587;
     3'b011: mult_out[46] = 18'sd1762;
     default: mult_out[46] = 18'sd0;
endcase
always @ *
     case(x[47])
     3'b000: mult_out[47] = -18'sd671;
     3'b001: mult_out[47] = -18'sd224;
     3'b010: mult_out[47] = 18'sd224;
     3'b011: mult_out[47] = 18'sd671;
     default: mult_out[47] = 18'sd0;
endcase
always @ *
     case(x[48])
     3'b000: mult_out[48] = 18'sd1084;
     3'b001: mult_out[48] = 18'sd361;
     3'b010: mult_out[48] = -18'sd361;
     3'b011: mult_out[48] = -18'sd1084;
     default: mult_out[48] = 18'sd0;
endcase
always @ *
     case(x[49])
     3'b000: mult_out[49] = 18'sd2444;
     3'b001: mult_out[49] = 18'sd815;
     3'b010: mult_out[49] = -18'sd815;
     3'b011: mult_out[49] = -18'sd2444;
     default: mult_out[49] = 18'sd0;
endcase
always @ *
     case(x[50])
     3'b000: mult_out[50] = 18'sd2413;
     3'b001: mult_out[50] = 18'sd804;
     3'b010: mult_out[50] = -18'sd804;
     3'b011: mult_out[50] = -18'sd2413;
     default: mult_out[50] = 18'sd0;
endcase
always @ *
     case(x[51])
     3'b000: mult_out[51] = 18'sd723;
     3'b001: mult_out[51] = 18'sd241;
     3'b010: mult_out[51] = -18'sd241;
     3'b011: mult_out[51] = -18'sd723;
     default: mult_out[51] = 18'sd0;
endcase
always @ *
     case(x[52])
     3'b000: mult_out[52] = -18'sd1844;
     3'b001: mult_out[52] = -18'sd615;
     3'b010: mult_out[52] = 18'sd615;
     3'b011: mult_out[52] = 18'sd1844;
     default: mult_out[52] = 18'sd0;
endcase
always @ *
     case(x[53])
     3'b000: mult_out[53] = -18'sd3751;
     3'b001: mult_out[53] = -18'sd1250;
     3'b010: mult_out[53] = 18'sd1250;
     3'b011: mult_out[53] = 18'sd3751;
     default: mult_out[53] = 18'sd0;
endcase
always @ *
     case(x[54])
     3'b000: mult_out[54] = -18'sd3533;
     3'b001: mult_out[54] = -18'sd1178;
     3'b010: mult_out[54] = 18'sd1178;
     3'b011: mult_out[54] = 18'sd3533;
     default: mult_out[54] = 18'sd0;
endcase
always @ *
     case(x[55])
     3'b000: mult_out[55] = -18'sd763;
     3'b001: mult_out[55] = -18'sd254;
     3'b010: mult_out[55] = 18'sd254;
     3'b011: mult_out[55] = 18'sd763;
     default: mult_out[55] = 18'sd0;
endcase
always @ *
     case(x[56])
     3'b000: mult_out[56] = 18'sd3430;
     3'b001: mult_out[56] = 18'sd1143;
     3'b010: mult_out[56] = -18'sd1143;
     3'b011: mult_out[56] = -18'sd3430;
     default: mult_out[56] = 18'sd0;
endcase
always @ *
     case(x[57])
     3'b000: mult_out[57] = 18'sd6638;
     3'b001: mult_out[57] = 18'sd2213;
     3'b010: mult_out[57] = -18'sd2213;
     3'b011: mult_out[57] = -18'sd6638;
     default: mult_out[57] = 18'sd0;
endcase
always @ *
     case(x[58])
     3'b000: mult_out[58] = 18'sd6244;
     3'b001: mult_out[58] = 18'sd2081;
     3'b010: mult_out[58] = -18'sd2081;
     3'b011: mult_out[58] = -18'sd6244;
     default: mult_out[58] = 18'sd0;
endcase
always @ *
     case(x[59])
     3'b000: mult_out[59] = 18'sd787;
     3'b001: mult_out[59] = 18'sd262;
     3'b010: mult_out[59] = -18'sd262;
     3'b011: mult_out[59] = -18'sd787;
     default: mult_out[59] = 18'sd0;
endcase
always @ *
     case(x[60])
     3'b000: mult_out[60] = -18'sd9067;
     3'b001: mult_out[60] = -18'sd3022;
     3'b010: mult_out[60] = 18'sd3022;
     3'b011: mult_out[60] = 18'sd9067;
     default: mult_out[60] = 18'sd0;
endcase
always @ *
     case(x[61])
     3'b000: mult_out[61] = -18'sd20515;
     3'b001: mult_out[61] = -18'sd6838;
     3'b010: mult_out[61] = 18'sd6838;
     3'b011: mult_out[61] = 18'sd20515;
     default: mult_out[61] = 18'sd0;
endcase
always @ *
     case(x[62])
     3'b000: mult_out[62] = -18'sd29655;
     3'b001: mult_out[62] = -18'sd9885;
     3'b010: mult_out[62] = 18'sd9885;
     3'b011: mult_out[62] = 18'sd29655;
     default: mult_out[62] = 18'sd0;
endcase
always @ *
     case(x[63])
     3'b000: mult_out[63] = -18'sd33140;
     3'b001: mult_out[63] = -18'sd11047;
     3'b010: mult_out[63] = 18'sd11047;
     3'b011: mult_out[63] = 18'sd33140;
     default: mult_out[63] = 18'sd0;
endcase
always @ *
     case(x[64])
     3'b000: mult_out[64] = -18'sd29655;
     3'b001: mult_out[64] = -18'sd9885;
     3'b010: mult_out[64] = 18'sd9885;
     3'b011: mult_out[64] = 18'sd29655;
     default: mult_out[64] = 18'sd0;
endcase
always @ *
     case(x[65])
     3'b000: mult_out[65] = -18'sd20515;
     3'b001: mult_out[65] = -18'sd6838;
     3'b010: mult_out[65] = 18'sd6838;
     3'b011: mult_out[65] = 18'sd20515;
     default: mult_out[65] = 18'sd0;
endcase
always @ *
     case(x[66])
     3'b000: mult_out[66] = -18'sd9067;
     3'b001: mult_out[66] = -18'sd3022;
     3'b010: mult_out[66] = 18'sd3022;
     3'b011: mult_out[66] = 18'sd9067;
     default: mult_out[66] = 18'sd0;
endcase
always @ *
     case(x[67])
     3'b000: mult_out[67] = 18'sd787;
     3'b001: mult_out[67] = 18'sd262;
     3'b010: mult_out[67] = -18'sd262;
     3'b011: mult_out[67] = -18'sd787;
     default: mult_out[67] = 18'sd0;
endcase
always @ *
     case(x[68])
     3'b000: mult_out[68] = 18'sd6244;
     3'b001: mult_out[68] = 18'sd2081;
     3'b010: mult_out[68] = -18'sd2081;
     3'b011: mult_out[68] = -18'sd6244;
     default: mult_out[68] = 18'sd0;
endcase
always @ *
     case(x[69])
     3'b000: mult_out[69] = 18'sd6638;
     3'b001: mult_out[69] = 18'sd2213;
     3'b010: mult_out[69] = -18'sd2213;
     3'b011: mult_out[69] = -18'sd6638;
     default: mult_out[69] = 18'sd0;
endcase
always @ *
     case(x[70])
     3'b000: mult_out[70] = 18'sd3430;
     3'b001: mult_out[70] = 18'sd1143;
     3'b010: mult_out[70] = -18'sd1143;
     3'b011: mult_out[70] = -18'sd3430;
     default: mult_out[70] = 18'sd0;
endcase
always @ *
     case(x[71])
     3'b000: mult_out[71] = -18'sd763;
     3'b001: mult_out[71] = -18'sd254;
     3'b010: mult_out[71] = 18'sd254;
     3'b011: mult_out[71] = 18'sd763;
     default: mult_out[71] = 18'sd0;
endcase
always @ *
     case(x[72])
     3'b000: mult_out[72] = -18'sd3533;
     3'b001: mult_out[72] = -18'sd1178;
     3'b010: mult_out[72] = 18'sd1178;
     3'b011: mult_out[72] = 18'sd3533;
     default: mult_out[72] = 18'sd0;
endcase
always @ *
     case(x[73])
     3'b000: mult_out[73] = -18'sd3751;
     3'b001: mult_out[73] = -18'sd1250;
     3'b010: mult_out[73] = 18'sd1250;
     3'b011: mult_out[73] = 18'sd3751;
     default: mult_out[73] = 18'sd0;
endcase
always @ *
     case(x[74])
     3'b000: mult_out[74] = -18'sd1844;
     3'b001: mult_out[74] = -18'sd615;
     3'b010: mult_out[74] = 18'sd615;
     3'b011: mult_out[74] = 18'sd1844;
     default: mult_out[74] = 18'sd0;
endcase
always @ *
     case(x[75])
     3'b000: mult_out[75] = 18'sd723;
     3'b001: mult_out[75] = 18'sd241;
     3'b010: mult_out[75] = -18'sd241;
     3'b011: mult_out[75] = -18'sd723;
     default: mult_out[75] = 18'sd0;
endcase
always @ *
     case(x[76])
     3'b000: mult_out[76] = 18'sd2413;
     3'b001: mult_out[76] = 18'sd804;
     3'b010: mult_out[76] = -18'sd804;
     3'b011: mult_out[76] = -18'sd2413;
     default: mult_out[76] = 18'sd0;
endcase
always @ *
     case(x[77])
     3'b000: mult_out[77] = 18'sd2444;
     3'b001: mult_out[77] = 18'sd815;
     3'b010: mult_out[77] = -18'sd815;
     3'b011: mult_out[77] = -18'sd2444;
     default: mult_out[77] = 18'sd0;
endcase
always @ *
     case(x[78])
     3'b000: mult_out[78] = 18'sd1084;
     3'b001: mult_out[78] = 18'sd361;
     3'b010: mult_out[78] = -18'sd361;
     3'b011: mult_out[78] = -18'sd1084;
     default: mult_out[78] = 18'sd0;
endcase
always @ *
     case(x[79])
     3'b000: mult_out[79] = -18'sd671;
     3'b001: mult_out[79] = -18'sd224;
     3'b010: mult_out[79] = 18'sd224;
     3'b011: mult_out[79] = 18'sd671;
     default: mult_out[79] = 18'sd0;
endcase
always @ *
     case(x[80])
     3'b000: mult_out[80] = -18'sd1762;
     3'b001: mult_out[80] = -18'sd587;
     3'b010: mult_out[80] = 18'sd587;
     3'b011: mult_out[80] = 18'sd1762;
     default: mult_out[80] = 18'sd0;
endcase
always @ *
     case(x[81])
     3'b000: mult_out[81] = -18'sd1675;
     3'b001: mult_out[81] = -18'sd558;
     3'b010: mult_out[81] = 18'sd558;
     3'b011: mult_out[81] = 18'sd1675;
     default: mult_out[81] = 18'sd0;
endcase
always @ *
     case(x[82])
     3'b000: mult_out[82] = -18'sd639;
     3'b001: mult_out[82] = -18'sd213;
     3'b010: mult_out[82] = 18'sd213;
     3'b011: mult_out[82] = 18'sd639;
     default: mult_out[82] = 18'sd0;
endcase
always @ *
     case(x[83])
     3'b000: mult_out[83] = 18'sd608;
     3'b001: mult_out[83] = 18'sd203;
     3'b010: mult_out[83] = -18'sd203;
     3'b011: mult_out[83] = -18'sd608;
     default: mult_out[83] = 18'sd0;
endcase
always @ *
     case(x[84])
     3'b000: mult_out[84] = 18'sd1318;
     3'b001: mult_out[84] = 18'sd439;
     3'b010: mult_out[84] = -18'sd439;
     3'b011: mult_out[84] = -18'sd1318;
     default: mult_out[84] = 18'sd0;
endcase
always @ *
     case(x[85])
     3'b000: mult_out[85] = 18'sd1162;
     3'b001: mult_out[85] = 18'sd387;
     3'b010: mult_out[85] = -18'sd387;
     3'b011: mult_out[85] = -18'sd1162;
     default: mult_out[85] = 18'sd0;
endcase
always @ *
     case(x[86])
     3'b000: mult_out[86] = 18'sd356;
     3'b001: mult_out[86] = 18'sd119;
     3'b010: mult_out[86] = -18'sd119;
     3'b011: mult_out[86] = -18'sd356;
     default: mult_out[86] = 18'sd0;
endcase
always @ *
     case(x[87])
     3'b000: mult_out[87] = -18'sd537;
     3'b001: mult_out[87] = -18'sd179;
     3'b010: mult_out[87] = 18'sd179;
     3'b011: mult_out[87] = 18'sd537;
     default: mult_out[87] = 18'sd0;
endcase
always @ *
     case(x[88])
     3'b000: mult_out[88] = -18'sd988;
     3'b001: mult_out[88] = -18'sd329;
     3'b010: mult_out[88] = 18'sd329;
     3'b011: mult_out[88] = 18'sd988;
     default: mult_out[88] = 18'sd0;
endcase
always @ *
     case(x[89])
     3'b000: mult_out[89] = -18'sd797;
     3'b001: mult_out[89] = -18'sd266;
     3'b010: mult_out[89] = 18'sd266;
     3'b011: mult_out[89] = 18'sd797;
     default: mult_out[89] = 18'sd0;
endcase
always @ *
     case(x[90])
     3'b000: mult_out[90] = -18'sd170;
     3'b001: mult_out[90] = -18'sd57;
     3'b010: mult_out[90] = 18'sd57;
     3'b011: mult_out[90] = 18'sd170;
     default: mult_out[90] = 18'sd0;
endcase
always @ *
     case(x[91])
     3'b000: mult_out[91] = 18'sd463;
     3'b001: mult_out[91] = 18'sd154;
     3'b010: mult_out[91] = -18'sd154;
     3'b011: mult_out[91] = -18'sd463;
     default: mult_out[91] = 18'sd0;
endcase
always @ *
     case(x[92])
     3'b000: mult_out[92] = 18'sd730;
     3'b001: mult_out[92] = 18'sd243;
     3'b010: mult_out[92] = -18'sd243;
     3'b011: mult_out[92] = -18'sd730;
     default: mult_out[92] = 18'sd0;
endcase
always @ *
     case(x[93])
     3'b000: mult_out[93] = 18'sd530;
     3'b001: mult_out[93] = 18'sd177;
     3'b010: mult_out[93] = -18'sd177;
     3'b011: mult_out[93] = -18'sd530;
     default: mult_out[93] = 18'sd0;
endcase
always @ *
     case(x[94])
     3'b000: mult_out[94] = 18'sd49;
     3'b001: mult_out[94] = 18'sd16;
     3'b010: mult_out[94] = -18'sd16;
     3'b011: mult_out[94] = -18'sd49;
     default: mult_out[94] = 18'sd0;
endcase
always @ *
     case(x[95])
     3'b000: mult_out[95] = -18'sd387;
     3'b001: mult_out[95] = -18'sd129;
     3'b010: mult_out[95] = 18'sd129;
     3'b011: mult_out[95] = 18'sd387;
     default: mult_out[95] = 18'sd0;
endcase
always @ *
     case(x[96])
     3'b000: mult_out[96] = -18'sd527;
     3'b001: mult_out[96] = -18'sd176;
     3'b010: mult_out[96] = 18'sd176;
     3'b011: mult_out[96] = 18'sd527;
     default: mult_out[96] = 18'sd0;
endcase
always @ *
     case(x[97])
     3'b000: mult_out[97] = -18'sd333;
     3'b001: mult_out[97] = -18'sd111;
     3'b010: mult_out[97] = 18'sd111;
     3'b011: mult_out[97] = 18'sd333;
     default: mult_out[97] = 18'sd0;
endcase
always @ *
     case(x[98])
     3'b000: mult_out[98] = 18'sd27;
     3'b001: mult_out[98] = 18'sd9;
     3'b010: mult_out[98] = -18'sd9;
     3'b011: mult_out[98] = -18'sd27;
     default: mult_out[98] = 18'sd0;
endcase
always @ *
     case(x[99])
     3'b000: mult_out[99] = 18'sd313;
     3'b001: mult_out[99] = 18'sd104;
     3'b010: mult_out[99] = -18'sd104;
     3'b011: mult_out[99] = -18'sd313;
     default: mult_out[99] = 18'sd0;
endcase
always @ *
     case(x[100])
     3'b000: mult_out[100] = 18'sd366;
     3'b001: mult_out[100] = 18'sd122;
     3'b010: mult_out[100] = -18'sd122;
     3'b011: mult_out[100] = -18'sd366;
     default: mult_out[100] = 18'sd0;
endcase
always @ *
     case(x[101])
     3'b000: mult_out[101] = 18'sd190;
     3'b001: mult_out[101] = 18'sd63;
     3'b010: mult_out[101] = -18'sd63;
     3'b011: mult_out[101] = -18'sd190;
     default: mult_out[101] = 18'sd0;
endcase
always @ *
     case(x[102])
     3'b000: mult_out[102] = -18'sd70;
     3'b001: mult_out[102] = -18'sd23;
     3'b010: mult_out[102] = 18'sd23;
     3'b011: mult_out[102] = 18'sd70;
     default: mult_out[102] = 18'sd0;
endcase
always @ *
     case(x[103])
     3'b000: mult_out[103] = -18'sd244;
     3'b001: mult_out[103] = -18'sd81;
     3'b010: mult_out[103] = 18'sd81;
     3'b011: mult_out[103] = 18'sd244;
     default: mult_out[103] = 18'sd0;
endcase
always @ *
     case(x[104])
     3'b000: mult_out[104] = -18'sd239;
     3'b001: mult_out[104] = -18'sd80;
     3'b010: mult_out[104] = 18'sd80;
     3'b011: mult_out[104] = 18'sd239;
     default: mult_out[104] = 18'sd0;
endcase
always @ *
     case(x[105])
     3'b000: mult_out[105] = -18'sd89;
     3'b001: mult_out[105] = -18'sd30;
     3'b010: mult_out[105] = 18'sd30;
     3'b011: mult_out[105] = 18'sd89;
     default: mult_out[105] = 18'sd0;
endcase
always @ *
     case(x[106])
     3'b000: mult_out[106] = 18'sd90;
     3'b001: mult_out[106] = 18'sd30;
     3'b010: mult_out[106] = -18'sd30;
     3'b011: mult_out[106] = -18'sd90;
     default: mult_out[106] = 18'sd0;
endcase
always @ *
     case(x[107])
     3'b000: mult_out[107] = 18'sd182;
     3'b001: mult_out[107] = 18'sd61;
     3'b010: mult_out[107] = -18'sd61;
     3'b011: mult_out[107] = -18'sd182;
     default: mult_out[107] = 18'sd0;
endcase
always @ *
     case(x[108])
     3'b000: mult_out[108] = 18'sd143;
     3'b001: mult_out[108] = 18'sd48;
     3'b010: mult_out[108] = -18'sd48;
     3'b011: mult_out[108] = -18'sd143;
     default: mult_out[108] = 18'sd0;
endcase
always @ *
     case(x[109])
     3'b000: mult_out[109] = 18'sd21;
     3'b001: mult_out[109] = 18'sd7;
     3'b010: mult_out[109] = -18'sd7;
     3'b011: mult_out[109] = -18'sd21;
     default: mult_out[109] = 18'sd0;
endcase
always @ *
     case(x[110])
     3'b000: mult_out[110] = -18'sd93;
     3'b001: mult_out[110] = -18'sd31;
     3'b010: mult_out[110] = 18'sd31;
     3'b011: mult_out[110] = 18'sd93;
     default: mult_out[110] = 18'sd0;
endcase
always @ *
     case(x[111])
     3'b000: mult_out[111] = -18'sd127;
     3'b001: mult_out[111] = -18'sd42;
     3'b010: mult_out[111] = 18'sd42;
     3'b011: mult_out[111] = 18'sd127;
     default: mult_out[111] = 18'sd0;
endcase
always @ *
     case(x[112])
     3'b000: mult_out[112] = -18'sd72;
     3'b001: mult_out[112] = -18'sd24;
     3'b010: mult_out[112] = 18'sd24;
     3'b011: mult_out[112] = 18'sd72;
     default: mult_out[112] = 18'sd0;
endcase
always @ *
     case(x[113])
     3'b000: mult_out[113] = 18'sd22;
     3'b001: mult_out[113] = 18'sd7;
     3'b010: mult_out[113] = -18'sd7;
     3'b011: mult_out[113] = -18'sd22;
     default: mult_out[113] = 18'sd0;
endcase
always @ *
     case(x[114])
     3'b000: mult_out[114] = 18'sd86;
     3'b001: mult_out[114] = 18'sd29;
     3'b010: mult_out[114] = -18'sd29;
     3'b011: mult_out[114] = -18'sd86;
     default: mult_out[114] = 18'sd0;
endcase
always @ *
     case(x[115])
     3'b000: mult_out[115] = 18'sd82;
     3'b001: mult_out[115] = 18'sd27;
     3'b010: mult_out[115] = -18'sd27;
     3'b011: mult_out[115] = -18'sd82;
     default: mult_out[115] = 18'sd0;
endcase
always @ *
     case(x[116])
     3'b000: mult_out[116] = 18'sd22;
     3'b001: mult_out[116] = 18'sd7;
     3'b010: mult_out[116] = -18'sd7;
     3'b011: mult_out[116] = -18'sd22;
     default: mult_out[116] = 18'sd0;
endcase
always @ *
     case(x[117])
     3'b000: mult_out[117] = -18'sd45;
     3'b001: mult_out[117] = -18'sd15;
     3'b010: mult_out[117] = 18'sd15;
     3'b011: mult_out[117] = 18'sd45;
     default: mult_out[117] = 18'sd0;
endcase
always @ *
     case(x[118])
     3'b000: mult_out[118] = -18'sd72;
     3'b001: mult_out[118] = -18'sd24;
     3'b010: mult_out[118] = 18'sd24;
     3'b011: mult_out[118] = 18'sd72;
     default: mult_out[118] = 18'sd0;
endcase
always @ *
     case(x[119])
     3'b000: mult_out[119] = -18'sd46;
     3'b001: mult_out[119] = -18'sd15;
     3'b010: mult_out[119] = 18'sd15;
     3'b011: mult_out[119] = 18'sd46;
     default: mult_out[119] = 18'sd0;
endcase
always @ *
     case(x[120])
     3'b000: mult_out[120] = 18'sd10;
     3'b001: mult_out[120] = 18'sd3;
     3'b010: mult_out[120] = -18'sd3;
     3'b011: mult_out[120] = -18'sd10;
     default: mult_out[120] = 18'sd0;
endcase
always @ *
     case(x[121])
     3'b000: mult_out[121] = 18'sd54;
     3'b001: mult_out[121] = 18'sd18;
     3'b010: mult_out[121] = -18'sd18;
     3'b011: mult_out[121] = -18'sd54;
     default: mult_out[121] = 18'sd0;
endcase
always @ *
     case(x[122])
     3'b000: mult_out[122] = 18'sd56;
     3'b001: mult_out[122] = 18'sd19;
     3'b010: mult_out[122] = -18'sd19;
     3'b011: mult_out[122] = -18'sd56;
     default: mult_out[122] = 18'sd0;
endcase
always @ *
     case(x[123])
     3'b000: mult_out[123] = 18'sd19;
     3'b001: mult_out[123] = 18'sd6;
     3'b010: mult_out[123] = -18'sd6;
     3'b011: mult_out[123] = -18'sd19;
     default: mult_out[123] = 18'sd0;
endcase
always @ *
     case(x[124])
     3'b000: mult_out[124] = -18'sd28;
     3'b001: mult_out[124] = -18'sd9;
     3'b010: mult_out[124] = 18'sd9;
     3'b011: mult_out[124] = 18'sd28;
     default: mult_out[124] = 18'sd0;
endcase
always @ *
     case(x[125])
     3'b000: mult_out[125] = -18'sd53;
     3'b001: mult_out[125] = -18'sd18;
     3'b010: mult_out[125] = 18'sd18;
     3'b011: mult_out[125] = 18'sd53;
     default: mult_out[125] = 18'sd0;
endcase
always @ *
     case(x[126])
     3'b000: mult_out[126] = -18'sd40;
     3'b001: mult_out[126] = -18'sd13;
     3'b010: mult_out[126] = 18'sd13;
     3'b011: mult_out[126] = 18'sd40;
     default: mult_out[126] = 18'sd0;
endcase




//always @ *
//		sum_level_7 = mult_out[0] + mult_out[1] + mult_out[2] + mult_out[3] + mult_out[4] + mult_out[5] + mult_out[6] + mult_out[7] + mult_out[8] + mult_out[9] + mult_out[10] + mult_out[11] + mult_out[12] + mult_out[13] + mult_out[14] + mult_out[15] + mult_out[16] + mult_out[17] + mult_out[18] + mult_out[19] + mult_out[20] + mult_out[21] + mult_out[22] + mult_out[23] + mult_out[24] + mult_out[25] + mult_out[26] + mult_out[27] + mult_out[28] + mult_out[29] + mult_out[30] + mult_out[31] + mult_out[32] + mult_out[33] + mult_out[34] + mult_out[35] + mult_out[36] + mult_out[37] + mult_out[38] + mult_out[39] + mult_out[40] + mult_out[41] + mult_out[42] + mult_out[43] + mult_out[44] + mult_out[45] + mult_out[46] + mult_out[47] + mult_out[48] + mult_out[49] + mult_out[50] + mult_out[51] + mult_out[52] + mult_out[53] + mult_out[54] + mult_out[55] + mult_out[56] + mult_out[57] + mult_out[58] + mult_out[59] + mult_out[60] + mult_out[61] + mult_out[62] + mult_out[63] + mult_out[64] + mult_out[65] + mult_out[66] + mult_out[67] + mult_out[68] + mult_out[69] + mult_out[70] + mult_out[71] + mult_out[72] + mult_out[73] + mult_out[74] + mult_out[75] + mult_out[76] + mult_out[77] + mult_out[78] + mult_out[79] + mult_out[80] + mult_out[81] + mult_out[82] + mult_out[83] + mult_out[84] + mult_out[85] + mult_out[86] + mult_out[87] + mult_out[88] + mult_out[89] + mult_out[90] + mult_out[91] + mult_out[92] + mult_out[93] + mult_out[94] + mult_out[95] + mult_out[96] + mult_out[97] + mult_out[98] + mult_out[99] + mult_out[100] + mult_out[101] + mult_out[102] + mult_out[103] + mult_out[104] + mult_out[105] + mult_out[106] + mult_out[107] + mult_out[108] + mult_out[109] + mult_out[110] + mult_out[111] + mult_out[112] + mult_out[113] + mult_out[114] + mult_out[115] + mult_out[116] + mult_out[117] + mult_out[118] + mult_out[119] + mult_out[120] + mult_out[121] + mult_out[122] + mult_out[123] + mult_out[124] + mult_out[125] + mult_out[126];

reg signed [17:0] sum_level_0[63:0];
always @ * begin
    for (i = 0; i < 63; i = i + 1)
        sum_level_0[i] = mult_out[i] + mult_out[i+63];
        sum_level_0[63] = mult_out[126];
end

reg signed [17:0] sum_level_1[31:0];
always @ (posedge clk) begin
    for (i = 0; i < 32; i = i + 1)
        if (reg_clr)
            sum_level_1[i] <= 18'b0;
        else
            sum_level_1[i] <= sum_level_0[i] + sum_level_0[i+32];
end

reg signed [17:0] sum_level_2[15:0];
always @ * begin
    for (i = 0; i < 16; i = i + 1)
            sum_level_2[i] <= sum_level_1[i] + sum_level_1[i+16];
end

reg signed [17:0] sum_level_3[7:0];
always @ * begin
    for (i = 0; i < 8; i = i + 1)
            sum_level_3[i] <= sum_level_2[i] + sum_level_2[i+8];
end

reg signed [17:0] sum_level_4[3:0];
always @ * begin
    for (i = 0; i < 4; i = i + 1)
            sum_level_4[i] <= sum_level_3[i] + sum_level_3[i+4];
end

reg signed [17:0] sum_level_5[1:0];
always @ * begin
    for (i = 0; i < 2; i = i + 1)
            sum_level_5[i] <= sum_level_4[i] + sum_level_4[i+2];
end

reg signed [17:0] sum_level_6;
always @ (posedge clk) 
        if (reg_clr)
            sum_level_6 <= 18'b0;
        else
            sum_level_6 <= sum_level_5[0] + sum_level_5[1];

always @ (posedge clk)
    if (reset == 1'b1)
        y <= 18'b0;
    else if (sam_clk_ena == 1'b1)
        y <= sum_level_6;
 
 
endmodule