`timescale 1 ps / 1 ps

module cordic_tb ();

reg				clk;
reg				reset;
reg		[31:0]	theta;
reg		[5:0]	n;
wire	[31:0]	result;

cordic cord (
	.clk(clk),
	.reset(reset),
	.theta(theta),
	.n(n),
	.result(result)
);

always #100 clk = ~clk;

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 1;
	#100;
	theta = 32'hbf7f0000;
	n = 4;
	#10100;
	$display($time, " << Simulation Complete>> ");
	$display($time, " << Simulation Complete>> ");

	$stop;
end

endmodule
