module FSM(input logic byte_ready,clk,t_byte,counter_baud,counter_of,rst, 
		   output logic en,shift,load_xmt,load_xmt_2,clear_baud,start,clear);
	
	parameter S0 = 2'b00;
	parameter S1 = 2'b01;
	parameter S2 = 2'b10;	
	logic [1:0]cs, ns;
	// NS
	always_comb 
	begin
		case(cs)
		S0: begin
			if (byte_ready) ns = S1;
			else ns = S0;
			end
		S1: begin
			if (t_byte)  ns = S2;
			else ns = S1;
			end
		S2: begin
			if ((counter_of) & (counter_baud)) ns = S0;
			else ns = S2;
			end
		default begin
			ns = S0;
			end
		endcase
	end
	
	always_ff @(posedge clk) begin
		if (rst) cs <= S0;
		else cs <= ns;
	end
	//output logic
	always_comb 
	begin
		case(cs)
		S0: begin
			if (~byte_ready) begin
				en = 0;clear_baud = 1;load_xmt = 1;clear = 1;shift = 0;load_xmt_2 = 0;start = 0;
			end
			else if (byte_ready) begin
				en = 0;clear_baud = 1;load_xmt = 0;clear = 1;shift = 0;load_xmt_2 = 0;start = 0;
			end
			end
		S1: begin
			if (~t_byte) begin
				en = 0;clear = 1;clear_baud = 1;load_xmt_2 = 1;load_xmt = 0;shift = 0;start = 0;
			end
			else if (t_byte) begin
				en = 0;clear_baud = 1;load_xmt = 0;clear = 1;shift = 0;load_xmt_2 = 0;start = 0;
			end
			end
		S2: begin
			if ((counter_of) & (~counter_baud)) begin
				en = 0;start = 1;clear_baud = 0;load_xmt = 0;clear = 0;shift = 0;load_xmt_2 = 0;
			end
			else if ((~counter_of) & (~counter_baud)) begin
				en = 0;clear_baud = 0;load_xmt = 0;clear = 0;shift = 0;load_xmt_2 = 0;start = 1;
			end
			else if ((~counter_of) & (counter_baud)) begin
				en = 1;clear_baud = 0;load_xmt = 0;clear = 0;load_xmt_2 = 0;start = 1;shift = 1;
			end
			else if ((counter_of) & (counter_baud)) begin
				en = 0;load_xmt_2 = 0;shift = 0;load_xmt = 0;clear_baud = 0;start = 0;clear = 0;
			end
			end
		endcase
	end 
endmodule