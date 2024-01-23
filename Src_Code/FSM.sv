module FSM (
	input  logic byte_ready,
	input  logic clk,
	input  logic t_byte,
	input  logic counter_baud,
	input  logic counter_of,
	input  logic rst, 
	
	output logic en,
	output logic shift,
	output logic load_xmt,
	output logic load_xmt_2,
	output logic clear_baud,
	output logic start,
	output logic clear
);
	
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;	

	logic [1:0] cs; 
	logic [1:0] ns;

	// NS
	always_comb 
	begin
		case(cs)
		S0: 
		begin
			if (byte_ready)
			begin 
				ns = S1;
			end
			else 
			begin
				ns = S0;
			end
		end
		S1: 
		begin
			if (t_byte)  
			begin
				ns = S2;
			end
			else 
			begin
				ns = S1;
			end
		end
		S2: 
		begin
			if ((counter_of) & (counter_baud)) 
			begin
				ns = S0;
			end
			else 
			begin
				ns = S2;
			end
		end
		default 
		begin
			ns = S0;
		end
		endcase
	end
	
	always_ff @(posedge clk) 
	begin
		if (rst) 
		begin
			cs <= S0;
		end
		else 
		begin
			cs <= ns;
		end
	end

	//output logic
	always_comb 
	begin
		case(cs)
		S0: 
		begin
			if (~byte_ready) 
			begin
				en         = 1'b0;
				clear_baud = 1'b1;
				load_xmt   = 1'b1;
				clear      = 1'b1;
				shift      = 1'b0;
				load_xmt_2 = 1'b0;
				start      = 1'b0;
			end
			else if (byte_ready) 
			begin
				en 		   = 1'b0;
				clear_baud = 1'b1;
				load_xmt   = 1'b0;
				clear      = 1'b1;
				shift      = 1'b0;
				load_xmt_2 = 1'b0;
				start      = 1'b0;
			end
		end
		S1: 
		begin
			if (~t_byte) 
			begin
				en         = 1'b0;
				clear      = 1'b1;
				clear_baud = 1'b1;
				load_xmt_2 = 1'b1;
				load_xmt   = 1'b0;
				shift      = 1'b0;
				start      = 1'b0;
			end
			else if (t_byte) 
			begin
				en         = 1'b0;
				clear_baud = 1'b1;
				load_xmt   = 1'b0;
				clear      = 1'b1;
				shift      = 1'b0;
				load_xmt_2 = 1'b0;
				start      = 1'b0;
			end
		end
		S2: 
		begin
			if ((counter_of) & (~counter_baud)) 
			begin
				en         = 1'b0;
				start      = 1'b1;
				clear_baud = 1'b0;
				load_xmt   = 1'b0;
				clear      = 1'b0;
				shift      = 1'b0;
				load_xmt_2 = 1'b0;
			end
			else if ((~counter_of) & (~counter_baud)) 
			begin
				en         = 1'b0;
				clear_baud = 1'b0;
				load_xmt   = 1'b0;
				clear      = 1'b0;
				shift      = 1'b0;
				load_xmt_2 = 1'b0;
				start      = 1'b1;
			end
			else if ((~counter_of) & (counter_baud)) 
			begin
				en         = 1'b1;
				clear_baud = 1'b0;
				load_xmt   = 1'b0;
				clear      = 1'b0;
				load_xmt_2 = 1'b0;
				start      = 1'b1;
				shift      = 1'b1;
			end
			else if ((counter_of) & (counter_baud)) 
			begin
				en         = 1'b0;
				load_xmt_2 = 1'b0;
				shift      = 1'b0;
				load_xmt   = 1'b0;
				clear_baud = 1'b0;
				start      = 1'b0;
				clear      = 1'b0;
			end
		end
		endcase
	end 

endmodule: FSM