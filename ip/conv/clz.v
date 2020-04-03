`timescale 1 ps / 1 ps

module clz (
	input	wire	[31:0]	in,
	output	wire	[4:0]	out
	);
	
	wire [15:0] in16;
	wire [7:0] in8;
	wire [3:0] in4;
	
	//always @(in) begin
		assign out[4] = (in[31:16] == 0);
		assign in16 = out[4] ? in[15:0] : in[31:16];
		assign out[3] = (in16[15:8] == 0);
		assign in8 = out[3] ? in16[7:0] : in16[15:8];
		assign out[2] = (in8[7:4] == 0);
		assign in4 = out[2] ? in8[3:0] : in8[7:4];
		assign out[1] = (in4[3:2] == 0);
		assign out[0] = out[1] ? ~in4[1] : ~in4[3];
	//end
	
endmodule