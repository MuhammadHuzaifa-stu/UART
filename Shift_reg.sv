module Shift_reg(input logic Clk, load, shift_i, rst,input logic [7:0]Parallel_In,
				 output logic Serial_Out);
	
	logic [7:0]tmp;
	always_ff @(posedge Clk) begin
		if (rst)
			Serial_Out <= 1'b0;
		else if(load)
			tmp <= Parallel_In;
		else if (shift_i) begin
			Serial_Out <= tmp[0];
			tmp <= {1'b0,tmp[7:1]};
		end
	end
endmodule
