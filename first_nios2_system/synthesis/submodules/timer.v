`timescale 1 ps / 1 ps

module timer(
	input	wire		clk,
	output	reg			result
	);
	
	initial result = 0;
	
	always @ (posedge clk) result <= result + 1;
	
endmodule