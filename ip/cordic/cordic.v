`timescale 1 ps / 1 ps

//`include "../fp_add/fp_add.v"

/*
	Takes 3N + 2 cycles per instruction.
	Throughput is 1 instruction per cycle.
*/

module cordic (
	input 	wire		clk,
	input	wire		reset,
	input	wire	[31:0]	theta,
	output	reg	[31:0]	result
	);

	localparam N = 9;
	wire 	[31:0]	ARCTAN_TABLE	[(N-1):0];

        assign  ARCTAN_TABLE[ 0] = 32'h3f490fdb;
        assign  ARCTAN_TABLE[ 1] = 32'h3eed6338;
        assign  ARCTAN_TABLE[ 2] = 32'h3e7adbb0;
        assign  ARCTAN_TABLE[ 3] = 32'h3dfeadd5;
        assign  ARCTAN_TABLE[ 4] = 32'h3d7faade;
        assign  ARCTAN_TABLE[ 5] = 32'h3cffeaae;
        assign  ARCTAN_TABLE[ 6] = 32'h3c7ffaab;
        assign  ARCTAN_TABLE[ 7] = 32'h3bfffeab;
        assign  ARCTAN_TABLE[ 8] = 32'h3b7fffab;/*
        assign  ARCTAN_TABLE[ 9] = 32'h3affffeb;
        assign  ARCTAN_TABLE[10] = 32'h3a7ffffb;
        assign  ARCTAN_TABLE[11] = 32'h39ffffff;
        assign  ARCTAN_TABLE[12] = 32'h39800000;
        assign  ARCTAN_TABLE[13] = 32'h39000000;
        assign  ARCTAN_TABLE[14] = 32'h38800000;*/

	reg	[31:0]	x [N:0];
	reg	[31:0]	y [N:0];
	reg	[31:0]	z [N:0];

	always @ (posedge clk) begin
		z[0] <= theta;
		x[0] <= 32'h3f1b74ee;
		y[0] <= 0;
		result <= x[N];
	end

	genvar i;
	generate
	for (i = 0; i < N; i = i + 1) begin : loop
		wire [31:0] xb = {y[i][31] ^ ~z[i][31], y[i][30:23] - i[7:0], y[i][22:0]};
		wire [31:0] yb = {x[i][31] ^  z[i][31], x[i][30:23] - i[7:0], x[i][22:0]};
		wire [31:0] zb = ARCTAN_TABLE[i] ^ (~z[i] & (1 << 31));
		wire [31:0] xout, yout, zout;

		fp_add add_x (
			.clk(clk),
			.areset(reset),
			.a(x[i]),
			.b(xb),
			.q(xout)
		);

		fp_add add_y (
			.clk(clk),
			.areset(reset),
			.a(y[i]),
			.b(yb),
			.q(yout)
		);

		fp_add add_z (
			.clk(clk),
			.areset(reset),
			.a(z[i]),
			.b(zb),
			.q(zout)
		);

		always @ (posedge clk) begin
			x[i+1] <= xout;
			y[i+1] <= yout;
			z[i+1] <= zout;
		end
	end
	endgenerate
	
endmodule