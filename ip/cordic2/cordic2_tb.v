`timescale 1 ps / 1 ps

module cordic2_tb ();

reg				clk;
reg				reset;
reg		[31:0]	theta;
wire	[31:0]	result;

cordic2 cord (
	.clk(clk),
	.reset(reset),
	.theta(theta),
	.result(result)
);

always #100 clk = ~clk;

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 1;
	#300;
	theta = 32'h3f000000;
	#10100;
	$display($time, " << Simulation Complete>> ");
	$display($time, " << Simulation Complete>> ");

	$stop;
end

endmodule
