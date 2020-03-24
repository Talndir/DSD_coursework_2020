`timescale 1 ps / 1 ps

module func_tb ();

reg				clk;
reg				reset;

reg 			clk2;
reg				start;
reg		[31:0]	base_ptr;
reg		[31:0]	size;
wire			done;
wire	[31:0]	result;

wire	[31:0]	address;
wire			read;
reg		[15:0]	readdata;
reg				waitrequest;

func fn (
	.clk(clk),
	.reset(reset),

	.clk2(clk2),
	.start(start),
	.base_ptr(base_ptr),
	.size(size),
	.done(done),
	.result(result),

	.address(address),
	.read(read),
	.readdata(readdata),
	.waitrequest(waitrequest)
);

always #100 clk = ~clk;

initial
begin
	$display($time, " << Starting Simulation >> ");
	clk = 0;
	reset = 0;
	clk2 = 0;
	start = 0;
	base_ptr = 0;
	size = 0;
	readdata = 0;
	waitrequest = 0;
	#200;
	start = 1;
	base_ptr = 32'h12345678;
	size = 2;
	#200;
	start = 0;
	base_ptr = 0;
	size = 0;
	waitrequest = 1;
	#600;
	waitrequest = 0;
	readdata = 16'h0000;
	#200;
	readdata = 16'h3f00;
	#200
	readdata = 0;
	waitrequest = 1;
	#1000
	waitrequest = 0;
	readdata = 16'h0000;
	#200
	readdata = 16'h3f80;
	#10000
	$display($time, " << Simulation Complete>> ");
	$display($time, " << Simulation Complete>> ");

	$stop;
end

endmodule