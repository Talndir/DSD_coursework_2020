`timescale 1 ps / 1 ps

module expr_tb ();

reg		clk;
reg		reset;
reg	[31:0]	x;
wire	[31:0]	result;

expr ex (
	.clk(clk),
	.reset(reset),
	.x(x),
	.result(result)
);

always #100 clk = ~clk;

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 1;
	reset = 0;
	#100
	x = 32'h3f000000;
	#200;
	x = 32'h3f800000;
	#10000;
	$display($time, " << Simulation Complete>> ");
	$display($time, " << Simulation Complete>> ");

	$stop;
end

endmodule