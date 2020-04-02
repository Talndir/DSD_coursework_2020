`timescale 1 ps / 1 ps

module experiment ();

reg				clk;
reg				areset;
reg		[31:0]  a;
reg		[31:0]  b;
wire 	[31:0] 	q;

fp_add add (
	.clk(clk),
	.areset(areset),
	.a(a),
	.b(b),
	.q(q)
);

always #100 clk = ~clk;

reg go;

always @ (negedge clk) begin
	if (go)
		b <= q;
end

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 0;
	areset = 0;
	a = 0;
	b = 0;
	go = 0;
	#200;
	go = 1;
	#400;
	a = 32'h3fe8a090;
	#200
	a = 32'h3f800000;
	#200
	a = 32'h3f000000;
	#200
	a = 32'hbe800000;
	#200
	a = 0;
	#2000;
	$display($time, " << Simulation Complete>> ");
	$stop;
end

endmodule