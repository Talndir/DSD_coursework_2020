`timescale 1 ps / 1 ps

module conv_tb();

reg 	[31:0]	clz_in;
wire	[4:0]	clz_out;

clz count (
	.in(clz_in),
	.out(clz_out)
);

reg		[31:0]	fp_to_int_x;
wire	[31:0]	fp_to_int_y;

fp_to_int fptoi(
	.x(fp_to_int_x),
	.y(fp_to_int_y)
);

reg		[31:0]	int_to_fp_x;
wire	[31:0]	int_to_fp_y;

int_to_fp itofp(
	.x(int_to_fp_x),
	.y(int_to_fp_y)
);


initial
begin
	$display($time, " << Starting Simulation >> ");
	clz_in = 32'h01234567;	// Should be 7
	#100
	clz_in = 32'h009184fc;	// Should be 8
	#100
	fp_to_int_x = 32'h3f000000;	// Should be 1073741824
	#100
	fp_to_int_x = 32'h3f60a948;	// Should be 1884595247
	#100
	int_to_fp_x = 32'd1073741824;	// Should be 0.5
	#100
	int_to_fp_x = 32'd1884595247;	// Should be 0.87758256189
	#100
	fp_to_int_x = 32'hbf7f0000;
	#200
	$display($time, " << Simulation Complete>> ");

	$stop;
end

endmodule