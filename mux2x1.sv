module mux2x1 (
	input  logic a,
	input  logic b,
	input  logic s, 
	
	output logic c
);

	always_comb 
	begin
		if (s) 
		begin
			c = b;
		end
		else 
		begin
			c = a;
		end
	end

endmodule: mux2x1