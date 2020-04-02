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
	input	wire			waitrequest,
	input	wire			readdatavalid
	);
	
	reg 	[3:0]	state_req;
	reg		[3:0]	state_fetch;

	localparam STATE_REQ_IDLE 	= 0;
	localparam STATE_REQ_1		= 1;
	localparam STATE_REQ_2		= 2;
	localparam STATE_REQ_WAIT	= 3;
	localparam STATE_REQ_END	= 5;
	localparam STATE_REQ_DONE	= 6;
	
	localparam STATE_FETCH_1 	= 0;
	localparam STATE_FETCH_2	= 1;

	reg		[31:0]	ptr;
	reg		[31:0]	end_ptr;
	
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
	
	reg		[45:0]	valid;
	
	initial begin
		state_req = STATE_REQ_IDLE;
		state_fetch = STATE_FETCH_1;
		done = 0;
		address = 0;
		read = 0;
		valid = 0;
	end

	always @ (posedge clk) begin
		valid[45:1] <= valid[44:0];
		valid[0] <= 0;
	
		case (state_req)
			STATE_REQ_IDLE: begin
				if (start) begin
					ptr <= base_ptr + 2;
					address <= base_ptr;
					read <= 1;
					end_ptr <= base_ptr + (size << 2);
					result <= 0;
					state_req <= STATE_REQ_1;
					state_fetch <= STATE_FETCH_1;
				end
			end
			
			STATE_REQ_1: begin
				if (~waitrequest) begin
					address <= ptr;
					ptr <= ptr + 2;
					state_req <= STATE_REQ_2;
				end
			end
			
			STATE_REQ_2: begin
				if (~waitrequest) begin
					read <= 0;
					state_req <= STATE_REQ_WAIT;
				end
			end

			STATE_REQ_WAIT: begin
				if (valid[0]) begin
					if (ptr == end_ptr) begin
						state_req <= STATE_REQ_END;
					end else begin
						address <= ptr;
						ptr <= ptr + 2;
						read <= 1;
						state_req <= STATE_REQ_1;
					end
				end
			end
			
			STATE_REQ_END: begin
				if (!valid[44:0]) begin
					done <= 1;
					state_req <= STATE_REQ_DONE;
					state_fetch <= STATE_FETCH_1;
				end
			end
			
			STATE_REQ_DONE: begin
				done <= 0;
				state_req <= STATE_REQ_IDLE;
			end
			
			default: begin end
		endcase
		
		case (state_fetch)
			STATE_FETCH_1: begin
				if (readdatavalid) begin
					val[15:0] <= readdata;
					state_fetch <= STATE_FETCH_2;
				end
			end
			
			STATE_FETCH_2: begin
				if (readdatavalid) begin
					val[31:16] <= readdata;
					valid[0] <= 1;
					state_fetch <= STATE_FETCH_1;
				end
			end
			
			default: begin end
		endcase
	
		if (valid[45]) begin
			result <= add_q;
		end
	end
	
endmodule