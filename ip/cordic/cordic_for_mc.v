`timescale 1 ps / 1 ps

/*
	This version of CORDIC takes an extra parameter n, which is the
	number of iterations to do. However, it always completes in 33 cycles.
	So this should only be used when testing e.g. Monte-Carlo simulation.
*/

module cordic (
	input	wire			clk,
	input	wire			reset,
	input	wire	[31:0]	theta,
	input	wire	[5:0]	n,
	output	reg		[31:0]	result
	);

	localparam N = 32;

	wire signed [31:0] ARCTAN_TABLE [31:0];
	
	assign  ARCTAN_TABLE[0]  = 32'h6487ed80;
    assign  ARCTAN_TABLE[1]  = 32'h3b58ce00;
    assign  ARCTAN_TABLE[2]  = 32'h1f5b7600;
    assign  ARCTAN_TABLE[3]  = 32'h0feadd50;
    assign  ARCTAN_TABLE[4]  = 32'h07fd56f0;
    assign  ARCTAN_TABLE[5]  = 32'h03ffaab8;
    assign  ARCTAN_TABLE[6]  = 32'h01fff556;
    assign  ARCTAN_TABLE[7]  = 32'h00fffeab;
    assign  ARCTAN_TABLE[8]  = 32'h007fffd5;
	assign  ARCTAN_TABLE[9]  = 32'h003ffffa;
	assign  ARCTAN_TABLE[10] = 32'h001fffff;
	assign  ARCTAN_TABLE[11] = 32'h000fffff;
	assign  ARCTAN_TABLE[12] = 32'h00080000;
	assign  ARCTAN_TABLE[13] = 32'h00040000;
	assign  ARCTAN_TABLE[14] = 32'h00020000;
	assign  ARCTAN_TABLE[15] = 32'h00010000;
	assign  ARCTAN_TABLE[16] = 32'h00008000;
	assign  ARCTAN_TABLE[17] = 32'h00004000;
	assign  ARCTAN_TABLE[18] = 32'h00002000;
	assign  ARCTAN_TABLE[19] = 32'h00001000;
	assign  ARCTAN_TABLE[20] = 32'h00000800;
	assign  ARCTAN_TABLE[21] = 32'h00000400;
	assign  ARCTAN_TABLE[22] = 32'h00000200;
	assign  ARCTAN_TABLE[23] = 32'h00000100;
	assign  ARCTAN_TABLE[24] = 32'h00000080;
	assign  ARCTAN_TABLE[25] = 32'h00000040;
	assign  ARCTAN_TABLE[26] = 32'h00000020;
	assign  ARCTAN_TABLE[27] = 32'h00000010;
	assign  ARCTAN_TABLE[28] = 32'h00000008;
	assign  ARCTAN_TABLE[29] = 32'h00000004;
	assign  ARCTAN_TABLE[30] = 32'h00000002;
	assign  ARCTAN_TABLE[31] = 32'h00000001;
	
	wire signed [31:0] K_RECIP;
	
	assign 	K_RECIP	= 32'h4dba7700;
	
	reg	signed [31:0]	x	[N:0];
	reg	signed [31:0]	y	[N:0];
	reg	signed [31:0]	z	[N:0];

	wire [31:0] fp2i_out, i2fp_out;

	fp_to_int fp2i(
		.x(theta),
		.y(fp2i_out)
	);

	int_to_fp i2fp(
		.x(x[N]),
		.y(i2fp_out)
	);

	always @ (posedge clk) begin
		x[0] <= K_RECIP;
		y[0] <= 0;
		z[0] <= fp2i_out;
		result <= i2fp_out;
	end

	genvar i;
	generate
	for (i = 0; i < N; i = i + 1) begin : cordic2_loop
		always @ (posedge clk) begin
			if (i < n) begin
				x[i+1] <= z[i][31] ? x[i] + (y[i] >>> i) : x[i] - (y[i] >>> i);
				y[i+1] <= z[i][31] ? y[i] - (x[i] >>> i) : y[i] + (x[i] >>> i);
				z[i+1] <= z[i][31] ? z[i] + ARCTAN_TABLE[i] : z[i] - ARCTAN_TABLE[i];
			end else begin
				x[i+1] <= x[i];
			end			
		end
	end
	endgenerate
	
endmodule