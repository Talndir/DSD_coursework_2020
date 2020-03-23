`timescale 1 ps / 1 ps

//`include "../fp_add/fp_add.v"
//`include "../fp_mult/fp_mult.v"
//`include "../cordic/cordic.v"

/*
	Takes 56 cycles per instruction.
	Not pipelined.
*/

module expr (
	input	wire		clk,
	input	wire		reset,
	input	wire	[31:0]	x,
	output	reg	[31:0]	result
	);

	wire [31:0] add1_a = {x[31], x[30:23] - 8'h07, x[22:0]};
	wire [31:0] add1_to_cos, cos_to_mult1, mult1_to_add2, add2_to_mult2, mult2_q;

	fp_add add1 (
		.clk(clk),
		.areset(reset),
		.a(add1_a),
		.b(32'hbf800000),
		.q(add1_to_cos)
	);

	cordic cos (
		.clk(clk),
		.reset(reset),
		.theta(add1_to_cos),
		.result(cos_to_mult1)
	);

	fp_mult mult1 (
		.clk(clk),
		.areset(reset),
		.a(x),
		.b(cos_to_mult1),
		.q(mult1_to_add2)
	);

	fp_add add2 (
		.clk(clk),
		.areset(reset),
		.a(mult1_to_add2),
		.b(32'h3f000000),
		.q(add2_to_mult2)
	);

	fp_mult mult2 (
		.clk(clk),
		.areset(reset),
		.a(x),
		.b(add2_to_mult2),
		.q(mult2_q)
	);

	always @ (posedge clk) begin
		result <= mult2_q;
	end

endmodule