`timescale 1 ps / 1 ps

module func (
	input	wire			clk,
	input	wire			reset,

	input	wire			clk2,
	input	wire			start,
	input	wire	[31:0]	base_ptr,
	input	wire	[31:0]	size,
	output	reg				done,
	output	reg		[31:0]	result,
	
	output	reg		[31:0]	address,
	output	reg				read,
	input	wire	[15:0]	readdata,
	input	wire			waitrequest
	);
	
	reg 	[3:0]	state;

	localparam STATE_IDLE	 	= 0;
	localparam STATE_FETCH_1 	= 2;
	localparam STATE_FETCH_2	= 3;
	localparam STATE_EXPR		= 4;
	localparam STATE_ADD		= 5;
	localparam STATE_DONE		= 7;

	reg		[31:0]	ptr;
	reg		[31:0]	end_ptr;
	
	reg 	[7:0] 	counter;
	
	reg 	[31:0]	val;
	wire 	[31:0] 	expr_input;
	wire 	[31:0] 	expr_output;
	
	assign expr_input = val;
	
	expr inner_expr(
		.clk(clk),
		.reset(reset),
		.x(expr_input),
		.result(expr_output)
	);
	
	wire	[31:0]	add_a;
	wire	[31:0]	add_q;
	
	assign add_a = result;
	
	fp_add add(
		.clk(clk),
		.areset(reset),
		.a(add_a),
		.b(expr_output),
		.q(add_q)
	);
	
	initial begin
		state = STATE_IDLE;
		done = 0;
		address = 0;
		read = 0;
	end

	always @ (posedge clk) begin
		case (state)
			STATE_IDLE: begin
				if (start) begin
					ptr <= base_ptr + 2;
					end_ptr <= base_ptr + (size << 2);
					result <= 0;
					address <= base_ptr;
					read <= 1;
					state <= STATE_FETCH_1;
				end
			end
		
			STATE_FETCH_1: begin
				if (~waitrequest) begin
					val[15:0] <= readdata;
					address <= ptr;
					read <= 1;
					ptr <= ptr + 2;
					state <= STATE_FETCH_2;
				end
			end
			
			STATE_FETCH_2: begin
				if (~waitrequest) begin
					val[31:16] <= readdata;
					read <= 0;
					counter <= 0;
					state <= STATE_EXPR;
				end
			end
			
			STATE_EXPR: begin
				if (counter == 40) begin
					counter <= 0;
					state <= STATE_ADD;
				end else begin
					counter <= counter + 1;
				end
			end
			
			STATE_ADD: begin
				if (counter == 4) begin
					result <= add_q;
					if (ptr == end_ptr) begin
						done <= 1;
						state <= STATE_DONE;
					end else begin
						address <= ptr;
						read <= 1;
						ptr <= ptr + 2;
						state <= STATE_FETCH_1;
					end
				end else begin
					counter <= counter + 1;
				end
			end

			STATE_DONE: begin
				done <= 0;
				state <= STATE_IDLE;
			end

			default: begin end
		endcase
	end

/*
	always @ (posedge clk) begin
		case (state)
			STATE_IDLE: begin
				if (start) begin
					ptr <= base_ptr + 2;
					end_ptr <= base_ptr + (size << 2);
					result <= 0;
					address <= base_ptr;
					read <= 1;
					state <= STATE_FETCH_1;
				end
			end
		
			STATE_FETCH_1: begin
				if (~waitrequest) begin
					val[15:0] <= readdata;
					address <= ptr;
					read <= 1;
					ptr <= ptr + 2;
					state <= STATE_FETCH_2;
				end
			end
			
			STATE_FETCH_2: begin
				if (~waitrequest) begin
					val[31:16] <= readdata;
					read <= 0;
					counter <= 0;
					state <= STATE_EXPR;
				end
			end
			
			STATE_EXPR: begin
				result <= val;
				done <= 1;
				state <= STATE_IDLE;
			end
		endcase
	end
*/
endmodule