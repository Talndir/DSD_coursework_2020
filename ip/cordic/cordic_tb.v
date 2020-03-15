`timescale 1 ps / 1 ps

module cordic_tb ();

reg		clk;
reg	[31:0]	theta;
wire	[31:0]	result;

cordic cord (
	.clk(clk),
	.theta(theta),
	.result(result)
);

always #100 clk = ~clk;

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 0;
	theta = 32'h00000000;
	#600;
	theta = 32'h3f000000;
	#200;
	theta = 32'h3f800000;
	#20000;
	$display($time, " << Simulation Complete>> ");
	$display($time, " << Simulation Complete>> ");

	$stop;
end

endmodule