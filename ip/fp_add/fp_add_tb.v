`timescale 1 ps / 1 ps

module tb ();

reg		clk;
reg		areset;
reg	[31:0]  a;
reg	[31:0]  b;
wire 	[31:0] 	q;

fp_add add (
	.clk(clk),
	.areset(areset),
	.a(a),
	.b(b),
	.q(q)
);

always #100 clk = ~clk;

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 0;
	areset = 0;
	#100;
	a = 32'hbf800000;
	b = 32'h3f000000;
	#1000;
	$display($time, " << Simulation Complete>> ");
	$display($time, " << Simulation Complete>> ");
	$stop;
end

endmodule