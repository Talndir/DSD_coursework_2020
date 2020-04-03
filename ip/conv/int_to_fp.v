`timescale 1 ps / 1 ps

module int_to_fp(
	input	wire	[31:0]	x,
	output	wire	[31:0]	y
	);
	
	wire	[4:0]	z;
	
	clz count (
		.in(x),
		.out(z)
	);
	
	wire s = (x > 0);
	wire [31:0] v = s ? x : ~x + 1;
	wire [5:0] q = {1'b0, z} + 6'b111000;	// -8
	wire [31:0] m = q[5] ? v >> ((~q + 1) & 32'h0000003f) : v << q;
	wire [7:0] e = 127 - z;
	
	assign y = {~s, e, m[22:0]};
	//assign y = ;
	
endmodule