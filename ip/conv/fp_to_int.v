`timescale 1 ps / 1 ps

module fp_to_int(
	input	wire	[31:0]	x,
	output	wire	[31:0]	y
	);
	
	wire s = x[31];
	wire [7:0] e = x[30:23] - 119;	// 119 = -127 + 8
	wire [23:0] m = {1'b1, x[22:0]};	// Implicit leading 1
	wire [31:0] v = e > 0 ? m << e : m >> -e;
	assign y = s ? ~v + 1 : v;
	
endmodule