
module first_nios2_system (
	clk_clk,
	led_pio_external_connection_export,
	reset_reset_n);	

	input		clk_clk;
	output	[7:0]	led_pio_external_connection_export;
	input		reset_reset_n;
endmodule
