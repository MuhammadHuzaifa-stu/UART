module mux2x1(input logic a,b,s, output logic c);
	always_comb 
	begin
		if (s) c = b;
		else c = a;
	end
endmodule