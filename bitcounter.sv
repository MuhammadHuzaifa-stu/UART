module bitcounter (
	input  logic clk, 
	input  logic reset, 
	input  logic en, 
	
	output logic c
);

	logic [3:0] counter_up;
	
	// up counter
	always_ff @(posedge clk)
	begin
		if (reset) 
		begin
			counter_up <= 4'd0;
			c          <= 1'b0;
		end
		if (en) 
		begin
			counter_up <= counter_up + 4'd1;
			c          <= 1'b0;
		end
		if (counter_up == 4'd8) 
		begin
			c          <= 1'b1;
			counter_up <= 4'd0;
		end
	end 

endmodule: bitcounter