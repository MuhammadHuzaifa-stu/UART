module Shift_reg (
	input  logic       Clk, 
	input  logic       load, 
	input  logic       shift_i, 
	input  logic       rst,
	input  logic [7:0] Parallel_In,
	
	output logic       Serial_Out
);
	
	logic [7:0] tmp;

	always_ff @(posedge Clk) 
	begin
		if (rst)
		begin
			Serial_Out <= 1'b0;
		end
		else if (load)
		begin
			tmp <= Parallel_In;
		end
		else if (shift_i) 
		begin
			Serial_Out <= tmp[0];
			tmp        <= {1'b0,tmp[7:1]};
		end
	end
	
endmodule: Shift_reg
